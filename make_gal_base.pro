pro make_gal_base $
   , data_dir = data_dir

  print, ""
  print, "... Reading data from disk."
  print, ""

  @constants.bat
  lsun = 3.862d33
  pc = 3.0857000d18
  nan = !values.f_nan

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  data_dir = 'gal_data/'
  infile = data_dir + 'leda_database.fits'
  leda = mrdfits(infile, 1, hdr)
  n_leda = n_elements(leda)

  dist_base = mrdfits(data_dir + 'dist_base.fits', 1, hdr)

  s4g_fname = data_dir+'s4g_ipac_table.txt'
  s4g_tab = read_ipac_table(s4g_fname, /debug)
  s4g_pgc = get_pgc(s4g_tab.object)

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE THE DATABASE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  empty = empty_gal_struct()
  this_data = replicate(empty, n_leda)

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ IN THE LEDA INFORMATION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... reading LEDA data into our structure."
  print, ""
  
  this_data.objname = strupcase(strcompress(leda.objname,/rem))
  this_data.pgc = leda.pgc
  this_data.pgcname = 'PGC'+strupcase(strcompress(str(leda.pgc),/rem))
  
  this_data.vhel_kms = leda.v
  this_data.e_vhel = leda.e_v
  this_data.ref_vhel = 'LEDA'

  this_data.vvir_kms = leda.vvir
  this_data.e_vvir = leda.e_v ; ASSUME
  this_data.ref_vvir = 'LEDA'

  this_data.ra_deg = leda.al2000*15.0
  this_data.dec_deg = leda.de2000  
  this_data.ref_pos = 'LEDA'   

  this_data.posang_deg = leda.pa
  this_data.e_posang = nan
  this_data.ref_posang = 'LEDA'   

  this_data.incl_deg = leda.incl
  this_data.e_incl = nan
  this_data.ref_incl = 'LEDA'   

  this_data.logaxisratio = leda.logr25
  this_data.e_logaxisratio = leda.e_logr25
  this_data.ref_logaxisratio = 'LEDA'

  this_data.r25_deg = 10.^(leda.logd25)/10./60./2.
  this_data.e_r25 = (10.^(leda.e_logd25)-1.)*this_data.r25_deg
  this_data.ref_r25 = 'LEDA'

  this_data.t = leda.t
  this_data.e_t = leda.e_t
  this_data.ref_t = 'LEDA'
     
  this_data.morph = leda.type
  this_data.bar = leda.bar
  this_data.ref_morph = 'LEDA'
       
  this_data.vrot_kms = leda.vrot
  this_data.e_vrot = leda.e_vrot
  this_data.ref_vrot = 'LEDA'

  this_data.vmaxg_kms = leda.vmaxg
  this_data.e_vmaxg = leda.e_vmaxg
  this_data.ref_vmaxg = 'LEDA'

; APPARENT MAGNITUDES

  this_data.ut = leda.ut
  this_data.e_ut = leda.e_ut

  this_data.bt = leda.bt
  this_data.e_bt = leda.e_bt
  this_data.btc = leda.btc

  this_data.vt = leda.vt
  this_data.e_vt = leda.e_vt

  this_data.it = leda.it
  this_data.e_it = leda.e_it

  this_data.kt = leda.kt
  this_data.e_kt = leda.e_kt


; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; OVERRIDE LEDA POSITION ANGLES WITH S4G WHEN AVAILABLE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... overriding LEDA position angles and inclinations with S4G when available."
  print, ""

  s4g_logr25 = alog10(1.0/(1.0-s4g_tab.ellip1_25p5))
  
  n_s4g = n_elements(s4g_pgc)
  a = !values.f_nan*this_data.incl_deg
  b = a
  for ii = 0L, n_s4g-1 do begin
     counter, ii, n_s4g, 'S4G gals'

     this_s4g_pgc = s4g_pgc[ii]
     this_ind = where(this_s4g_pgc eq this_data.pgc, this_ct)
     if this_ct eq 0 then continue

     this_s4g_pa = s4g_tab.pa1_25p5[ii]

; Method follows HyperLEDA
     num = 1.0-10.^(-2.0*s4g_logr25[ii])
     
     t_for_logr0 = this_data[this_ind].t
     low_ind = where(t_for_logr0 lt -5, low_ct)
     if low_ct gt 0 then $
        t_for_logr0[low_ind] = -5.0
     nan_ind = where(finite(t_for_logr0) eq 0, nan_ct) 
     if nan_ct gt 0 then $
        t_for_logr0[nan_ind] = 6.0
     logr0 = 0.43 + 0.053*t_for_logr0
     high_ind = where(t_for_logr0 gt 7, high_ct) 
     if high_ct gt 0 then $
        logr0[high_ind] = 0.38
     
     denom = 1.0-10.^(-2.0*logr0)

     this_s4g_incl = (asin(sqrt(num/denom)))/!dtor

     ;this_s4g_incl = s4g_incl[ii]
     this_data[this_ind].posang_deg = this_s4g_pa
     this_data[this_ind].ref_posang = 'S4GIPAC'

     a[this_ind] = this_data[this_ind].incl_deg
     this_data[this_ind].incl_deg = this_s4g_incl
     b[this_ind] = this_s4g_incl
  endfor

;  stop

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; TAG SURVEY MEMBERSHIP
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... tagging survey membership."
  print, ""

  survey_files = file_search("gal_data/survey_*.txt", count=ct)

; LOOP THROUGH THE SURVEY FILES
  for ii = 0L, ct-1 do begin

     survey_name = strmid(survey_files[ii] $
                          , 0, strlen(survey_files[ii])-4)
     survey_name = strupcase(survey_name)
     survey_name = $
        (strmid(survey_name, strpos(survey_name,'SURVEY_')+strlen('SURVEY_')))
     
     print, "... applying survey file : ", survey_files[ii], " as survey ", survey_name

     readcol, survey_files[ii], comment="#" $
              , format="A" $
              , galaxy
     pgc_list = get_pgc(galaxy)
     for jj = 0L, n_elements(pgc_list)-1 do begin
        if pgc_list[jj] eq -1 then continue
        data_ind = where(this_data.pgc eq pgc_list[jj])
        tags = this_data[data_ind].tags
        tags += ';'+survey_name+';'
        this_data[data_ind].tags = tags
     endfor
     
  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FIGURE OUT DISTANCE AND UNCERTAINTY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... Working out the distance to our targets."
  print, ""

  vthresh_hubble_flow = 3500.

  this_data.dist_mpc = 10.^(leda.modbest/5.+1.)/1d6
  this_data.e_dist_dex = leda.e_modbest/2.5
  this_data.dist_code = 4
  this_data.ref_dist = 'LEDA'
  
  for ii = 0L, n_leda-1 do begin    
     if total(leda[ii].pgc eq dist_base.pgc) eq 0 then $
        continue
     
     ind_dist_base = where(dist_base.pgc eq leda[ii].pgc)
     this_dist_base = dist_base[ind_dist_base]

     if this_dist_base.edd_code eq 1 then begin
        this_data[ii].dist_mpc = this_dist_base.edd_dist_mpc
        this_data[ii].e_dist_dex = 0.035
        this_data[ii].dist_code = 1
        this_data[ii].ref_dist = 'EDD'
     endif else if this_dist_base.edd_code eq 2 then begin
        this_data[ii].dist_mpc = this_dist_base.edd_dist_mpc
        this_data[ii].e_dist_dex = 0.06
        this_data[ii].dist_code = 2
        this_data[ii].ref_dist = 'EDD'
     endif else begin
        if this_dist_base.vvir_kms gt vthresh_hubble_flow then begin
           continue
        endif

        if finite(this_dist_base.edd_dist_mpc) then begin
           this_data[ii].dist_mpc = this_dist_base.edd_dist_mpc
           this_data[ii].e_dist_dex = 0.125
           this_data[ii].dist_code = 3
           this_data[ii].ref_dist = 'EDD'
        endif else if finite(this_dist_base.cf_dist_mpc) then begin
           this_data[ii].dist_mpc = this_dist_base.cf_dist_mpc
           this_data[ii].e_dist_dex = 0.125
           this_data[ii].dist_code = 3
           this_data[ii].ref_dist = 'CF3'
        endif else begin
           this_data[ii].dist_mpc = this_dist_base.leda_bestdist_mpc
           this_data[ii].e_dist_dex = 0.125
           this_data[ii].dist_code = 3
           this_data[ii].ref_dist = 'LEDA'
        endelse

     endelse

  endfor
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW READ IN ANY USER-SUPPLIED OVERRIDE FILES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... applying user overrides."
  print, ""

  override_files = file_search("gal_data/override_*.txt", count=ct)

; ADD A FEW HIGH PRIORITY OVERRIDE FILES TO THE END OF THE AUTOMATIC
; LIST. THESE WILL RUN TWICE, BUT THEY WILL ALSO BE SURE TO OVERWRITE
; ANY EARLIER CASES.
  override_files = [override_files, 'gal_data/override_phangs_orient.txt']

; BUILD THE INFRASTRUCTURE TO LOOK UP TAG NAMES
  data_tags = tag_names(this_data)

; LOOP THROUGH THE OVERRIDE FILES
  for ii = 0L, ct-1 do begin

     print, "... applying override file : ", override_files[ii]

;    Convention is NAME, FIELD, VALUE

     readcol, override_files[ii], comment="#" $
              , format="A,A,A" $
              , galaxy, field, value
     galaxy = strupcase(strcompress(galaxy, /rem))
     field = strupcase(strcompress(field, /rem))
     
     pgc_list = get_pgc(galaxy)

     for jj = 0L, n_elements(pgc_list)-1 do begin
        if pgc_list[jj] eq -1 then begin
           message, "... OVERRIDE FILE: "+override_files[ii]+" No match for name "+galaxy[jj], /info
           continue
        endif

        data_ind = where(this_data.pgc eq pgc_list[jj])
        tag_ind = where(data_tags eq field[jj], tag_ct)
        if tag_ct eq 0 then begin
           message, "... OVERRIDE FILE: "+override_files[ii]+" No match for field "+field[jj], /info
           continue
        endif

        this_data[data_ind].(tag_ind) = value[jj]

     endfor

  endfor
     
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; SOME DERIVED QUANTITIES - PLACED HERE TO FOLLOW USER OVERRIDES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... converting to Galactic coordinates."
  print, ""

  glactc, this_data.ra_deg, this_data.dec_deg, 2000., l, b, 1, /degree
  this_data.gl_deg = l
  this_data.gb_deg = b

  print, ""
  print, "... calculating SFD 98 extinction."
  print, ""

  this_data.av_sfd98 = $
     dust_getval(this_data.gl_deg, this_data.gb_deg $
                 , ipath='~/idl/dustmaps/maps/', /interp, /noloop)*3.1

  print, ""
  print, "... ... large galaxy corrections."
  print, ""

; M31
  ind = where(this_data.pgc eq 2557, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 0.206

; M33
  ind = where(this_data.pgc eq 5818, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 0.139

; SMC
  ind = where(this_data.pgc eq 3085, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 0.123
  
; LMC
  ind = where(this_data.pgc eq 17223, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 0.249

; IC342
  ind = where(this_data.pgc eq 13826, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 1.849

; IC10
  ind = where(this_data.pgc eq 1305, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 5.062

; CIRCINUS
  ind = where(this_data.pgc eq 50779, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 4.822

; MAFFEI I
  ind = where(this_data.pgc eq 9892, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 3.872

; MAFEII II
  ind = where(this_data.pgc eq 10217, ct)
  if ct gt 0 then this_data[ind].av_sfd98 = 7.706

  print, ""
  print, "... calculating other secondary quantities."
  print, ""

  this_data.distmod = 5.*alog10(this_data.dist_mpc*1d6)-5.0
  this_data.e_distmod = 2.5*this_data.e_dist_dex
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PHOTOMETRY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%  

  this_data.logmhi = $
     alog10(10.^((leda.m21 - 17.4)/(-1.*2.5))*(2.36d5*this_data.dist_mpc^2))

  this_data.e_logmhi = $
     leda.e_m21/2.5
      
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; REMOVE DUPLICATIONS BASED ON PGC NUMBER AND SORT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "... removing duplicates"
  print, ""
  
  uniq_ind = uniq(this_data.pgc, sort(this_data.pgc))
  this_data = this_data[uniq_ind]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE THE WHOLE THING TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  outfile = "gal_data/gal_base.fits"
  mwrfits, this_data, outfile, hdr, /create

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE A FEW SMALLER SUBSETS TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  local = $
     (strpos(this_data.tags,'Z0MGS') ne -1) or $
     (strpos(this_data.tags,'S4G') ne -1) or $
     (strpos(this_data.tags,'PHANGS') ne -1) or $
     (strpos(this_data.tags,'BIMASONG') ne -1) or $
     (strpos(this_data.tags,'DEGAS') ne -1) or $
     (strpos(this_data.tags,'HERACLES') ne -1) or $
     (strpos(this_data.tags,'PHANGSEXT') ne -1) or $
     (strpos(this_data.tags,'SINGS') ne -1) or $
     (this_data.dist_mpc le 50.) or $
     (this_data.vhel_kms le 3500.)

  outfile = "gal_data/gal_base_local.fits"
  mwrfits, this_data[where(local)], outfile, hdr, /create  

  stop

end
