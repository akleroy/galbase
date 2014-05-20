pro make_gal_base $
   , data_dir = data_dir

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; INITIALIZE NOT-A-NUMBER
  nan = !values.d_nan

; EMPTY MEASUREMENT STRUCTURE
  empty = { $
;         NAMES
          name:'' $
          , pgc: 0L $
          , alias:'' $
;         DISTANCE AND RECESSIONAL VELOCITY
          , dist_mpc: nan $
          , e_dist: nan $
          , ref_dist: 'LEDA' $
          , vhel_kms: nan $
          , e_vhel_kms: nan $
          , ref_vhel: 'LEDA' $
          , vrad_kms: nan $
          , e_vrad_kms: nan $
          , ref_vrad: 'LEDA' $
          , vvir_kms: nan $
          , e_vvir_kms: nan $
          , ref_vvir: 'LEDA' $
;         POSITION
          , ra_deg: nan $
          , dec_deg: nan $
          , ref_pos: 'LEDA' $
;         ORIENTATION
          , posang_deg: nan $
          , e_posang: nan $
          , ref_posang: 'LEDA' $
          , incl_deg: nan $
          , e_incl: nan $
          , ref_incl: 'LEDA' $
          , log_raxis: nan $
          , e_log_raxis: nan $
          , ref_log_raxis: 'LEDA' $
;         MORPHOLOGY
          , t: nan $     
          , e_t: nan $     
          , ref_t: 'LEDA' $
          , morph: '' $
          , bar: 0B $
          , ring: 0B $
          , multiple: 0B $
          , ref_morph: 'LEDA' $
;         EXTINCTION
          , ext_b: nan $
          , ext_bmv_sfd98: nan $
          , ext_bmv_sf11: nan $
;         SIZES AND ROTATION CURVE
          , r25_deg: nan $
          , e_r25_deg: nan $
          , ref_r25: 'LEDA' $
          , vmaxg_kms: nan $
          , e_vmaxg_kms: nan $
          , ref_vmaxg: 'LEDA' $
          , vrot_kms: nan $
          , e_vrot_kms: nan $
          , ref_vrot: 'LEDA' $
;         PHOTOMETRY
          , hi_msun: nan $
          , ref_hi: 'LEDA' $
          , lfir_lsun: nan $
          , ref_ir: 'LEDA' $
          , btc_mag: nan $
          , ref_btc: 'LEDA' $
          , ubtc_mag: nan $
          , ref_ubtc: 'LEDA' $
          , bvtc_mag: nan $
          , ref_bvtc: 'LEDA' $
          , itc_mag: nan $
          , ref_itc: 'LEDA' $
          }

; ADD LATER
;          , lstar_kpc: nan $
;          , l3p6_as: nan $
;          , vrot_kms: nan $
;          , vrot_r25: nan $
;          , vflat_kms: nan $
;          , lflat_kpc: nan $

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
  data.r25_deg = 10.^(leda.logd25)/10./60.
  data.e_r25_deg = 10.^(leda.e_logd25)-1.
  
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

; EXTINCTION  
  data.ext_b = leda.ag

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FILL IN ALIASES 
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; ALIASES THAT LEDA KNOWS
  for i = 0L, n_leda-1 do begin
     if leda[i].hl_names eq '' then continue
     names = strsplit(leda[i].hl_names, ',', /extract)
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
; EXTINCTION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; ext_bmv_sfd98
; ext_bmv_sf11

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW READ IN ANY USER-SUPPLIED OVERRIDE FILES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  override_files = file_search("gal_data/override_*.txt", count=ct)

  for j = 0, ct-1 do begin

     readcol, override_files[j]

  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  outfile = "gal_data/gal_base.fits"
  spawn, "rm "+outfile
  mwrfits, data, outfile, hdr

  stop

end
