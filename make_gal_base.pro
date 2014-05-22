pro make_gal_base $
   , data_dir = data_dir

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  empty = empty_gal_struct()

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; BUILD THE BASIC DATABASE USING LEDA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  data_dir = "gal_data/"

  infile = data_dir+"leda_vlsr3500.fits"
  leda = mrdfits(infile, 1, hdr)

  n_leda = n_elements(leda)
  data = replicate(empty, n_leda)

;    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;    FILL IN LEDA INFORMATION
;    -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  data.name = strupcase(strcompress(leda.objname,/rem))
  data.pgc = strupcase(strcompress(leda.pgc,/rem))

  has_modz = where(finite(leda.modz), ct)
  if ct gt 0 then data[has_modz].dist_mpc = 10.^(leda[has_modz].modz/5.+1.)/1d6
  
; PREFER MOD0 - THIS IS A MEASUREMENT
  has_mod0 = where(finite(leda.mod0), ct)
  if ct gt 0 then data[has_mod0].dist_mpc = 10.^(leda[has_mod0].mod0/5.+1.)/1d6

; RECESSIONAL VELOCITY
  data.vhel_kms = leda.v
  data.e_vhel_kms = leda.e_v
  
  data.vrad_kms = leda.vrad
  data.e_vrad_kms = leda.e_vrad
  
  data.vvir_kms = leda.vvir
  
; POSITION
  data.ra_deg = leda.al2000*15.0
  data.dec_deg = leda.de2000
  
; ORIENTATION
  data.posang_deg = leda.pa
  data.incl_deg = leda.incl
  
  data.log_raxis = leda.logr25
  data.e_log_raxis = leda.e_logr25
  
; MORPHOLOGY
  data.t = leda.t
  data.e_t = leda.e_t
    
  data.morph = leda.type
  data.bar = strupcase(leda.bar) eq 'B'
  data.ring = strupcase(leda.bar) eq 'R'
  data.multiple = strupcase(leda.bar) eq 'M'

; SIZE  
  data.r25_deg = 10.^(leda.logd25)/10./60./2.
  data.e_r25_deg = 10.^(leda.e_logd25)-1. ; TRANSLATE TO A PERCENTAGE ERROR (ROUGHLY)
  
  data.vmaxg_kms = leda.vmaxg
  data.e_vmaxg_kms = leda.e_vmaxg

  data.vrot_kms = leda.vrot
  data.e_vrot_kms = leda.e_vrot

; LUMINOSITIES/FLUXES

; ... HI
  data.hi_msun = 10.^((leda.m21 - 17.4)/2.5)*(2.36d5*data.dist_mpc^2)

; ... IR
  lsun = 3.862d33
  pc = 3.0857000d18
  data.lfir_lsun = 10.^((leda.mfir -14.75)/(-2.5))*1.26d-14*1d3*(4.0*!pi*(data.dist_mpc*1d6*pc)^2)/lsun
  
; ... OPTICAL
  data.btc_mag = leda.btc
  data.ubtc_mag = leda.ubtc
  data.bvtc_mag = leda.bvtc
  data.itc_mag = leda.itc

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; EXTINCTION  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  data.ext_b = leda.ag

  extinction_files = file_search("gal_data/extinction*.tbl", count=ext_ct)

  data_name = strcompress(data.name, /rem)

; LOOP THROUGH THE EXTINCTION FILES
  for j = 0L, ext_ct-1 do begin

     print, "Reading extinction file : ", extinction_files[j]

     readcol, extinction_files[j], comment="#" $
              , format="A,X,X,X,X,F,X,X,X,X,X,F" $
              , objname, mean_ebv_sf11, mean_ebv_sfd98
     objname = strupcase(strcompress(objname, /rem))
     n_obj = n_elements(objname)

     for k = 0, n_obj-1 do begin
        data_ind = where(data_name eq objname[k], data_ct)
        if data_ct eq 0 then begin
           print, "No match for ", objname[k]
        endif
        data[data_ind].ext_bmv_sfd98 = mean_ebv_sfd98[k]
        data[data_ind].ext_bmv_sf11 = mean_ebv_sf11[k]
     endfor

  endfor     

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FILL IN ALIASES 
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; ALIASES THAT LEDA KNOWS
  for i = 0L, n_leda-1 do begin
     if strcompress(leda[i].hl_names,/rem) eq '' then continue
     names = strsplit(strcompress(leda[i].hl_names,/rem), ',', /extract)
     for j = 0, n_elements(names)-1 do begin
        if data[i].alias eq '' then $
           data[i].alias = names[j] $
        else $
           data[i].alias += ';'+names[j]
     endfor
  endfor

; USER INPUT ALIASES
  readcol, data_dir+"alias.txt", format="A,A" $
           , comment="#", name, alias, /silent
  name = strupcase(strcompress(name,/rem))
  alias = strupcase(strcompress(alias, /rem))

  n_alias = n_elements(alias)

  for i = 0L, n_alias-1 do begin
     ind = where(data.name eq name[i], match_ct)
     if match_ct eq 0 then begin
        for j = 0L, n_leda-1 do begin
           names = strsplit(data[j].alias, ';', /extract)
           if total(strupcase(names) eq name[i]) eq 1 then begin
              ind = j
              match_ct = 1
              break
           endif           
        endfor
        if match_ct eq 0 then begin
           print, "No matches for "+name[i]
           continue
        endif
     endif
     
     names = strsplit(data[ind].alias, ';', /extract)
     if total(strupcase(alias[i]) eq strupcase(names)) eq 0 then begin
        if data[ind].alias eq '' then $
           data[ind].alias = alias[i] $
        else $
           data[ind].alias += ';'+alias[i]
     endif

  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW READ IN ANY USER-SUPPLIED OVERRIDE FILES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  override_files = file_search("gal_data/override_*.txt", count=ct)

; BUILD THE INFRASTRUCTURE TO LOOKUP ACROSS ALIASES
  n_data = n_elements(data)-1
  n_names = 0
  for i = 0L, n_data-1 do begin
     n_names += 1
     aliases = strsplit(data[i].alias, ';', /extract)     
     n_names += n_elements(aliases)
  endfor

  alias_vec = strarr(n_names)
  name_vec = strarr(n_names)
  counter = 0L
  for i = 0L, n_data-1 do begin
     counter, i, n_data, " out of "

     alias_vec[counter] = data[i].name
     name_vec[counter] = data[i].name
     counter += 1
     
     if data[i].alias eq '' then continue
     aliases = strsplit(data[i].alias, ';', /extract)     
     n_alias = n_elements(aliases)

     alias_vec[counter:(counter+n_alias-1)] = aliases
     name_vec[counter:(counter+n_alias-1)] = replicate(data[i].name, n_alias)
     counter += n_alias
  endfor

; BUILD THE INFRASTRUCTURE TO LOOK UP TAG NAMES
  data_tags = tag_names(data)

; LOOP THROUGH THE OVERRIDE FILES
  for j = 0L, ct-1 do begin

     print, "Applying override file : ", override_files[j]

;    Convention is NAME, FIELD, VALUE, REFERENCE
;    ... need to generalize to allow strings.
     readcol, override_files[j], comment="#" $
              , format="A,A,A" $
              , galaxy, field, value
     galaxy = strupcase(strcompress(galaxy, /rem))
     field = strupcase(strcompress(field, /rem))
     
     for k = 0L, n_elements(galaxy)-1 do begin

        tag_ind = where(data_tags eq field[k], tag_ct)
        if tag_ct eq 0 then begin
           message, "No match for field "+field[k], /info
           continue
        endif
        
        name_ind = where(alias_vec eq galaxy[k], name_ct)
        if name_ct eq 0 then begin
           message, "No match for name "+galaxy[k], /info
           continue
        endif
        data_ind = where(data.name eq (name_vec[name_ind])[0])
        data[data_ind].(tag_ind) = value[k]

     endfor
     

  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  outfile = "gal_data/gal_base.fits"
  spawn, "rm "+outfile
  mwrfits, data, outfile, hdr

  stop

end
