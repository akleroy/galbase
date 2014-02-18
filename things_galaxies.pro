function things_galaxies, name $
                          , data_dir=data_dir $
                          , found=found $
                          , quiet=quiet
;+
; NAME:
;
; things_galaxies
;
; PURPOSE:
;
; Retreives structure and other information for THINGS galaxies.
;
; CATEGORY:
;
; Science helper?
;
; CALLING SEQUENCE:
;
; s = things_galaxies('ngc5055')
;
; INPUTS:
;
; The name of the galaxy you want a structure for in a format of:
;
; lower case catalog + number (e.g. ngc5055 or ic2574)
;
; OPTIONAL INPUTS:
;
; data_dir : the location of the THINGS structure files
;
; KEYWORD PARAMETERS:
;
; none
;
; OUTPUTS:
;
; A structure containing the following fields:
;
; name
; dist
; posang
; incl
; vlsr
; ra
; dec
; d25
; babs
; t
; e_bmv
; vrot_r25
; vflat_kms
; lflat_kpc
; vdisp_kms
; lstar_kpc
;
; MODIFICATION HISTORY:
;
; documented - leroy@mpia.de 22 June 2007
; added vrot - leroy@mpia.de 13 Nov 2007
; added vdisp - leroy@mpia.de 27 Nov 2007
; fixed vdisp at 11 - leroy@mpia.de 28 Jan 2007
; changed rotcur handling to vflat_kms / lflat_kms
; added lstar_kpc (needed for, e.g., stellar disp)
; changed defaults to allow some data missing - sep 2008
; added kingfish targets - sep 2008
; defaults to nans to handle missing data - sep 2008
;-

; ###################################
; ### DEFAULTS AND INITIALIZATION ###
; ###################################

; INITIALIZE THE FOUND FLAG
found = -1

; INITIALIZE COMMENTS
comment = ""

; ERROR CATCHING
if n_elements(name) eq 0 then begin
   message, 'I need a name to find a galaxy, you jerk. Returning -1.', /info
   return, -1
endif

; INITIALIZE ALIASES
alias = [strlowcase(name)]
if strmid(strlowcase(name),0,3) eq 'ngc' then $
   alias = [alias, 'n'+strmid(name,3,strlen(name)-3) $
            , 'N'+strmid(name,3,strlen(name)-3)]
if strlowcase(name) eq 'm81dwa' then $
   alias = [alias, 'PGC023521']
if strlowcase(name) eq 'm81dwb' then $
   alias = [alias, 'PGC029284']
if strlowcase(name) eq 'hoi' then $
   alias = [alias, 'holmbergi']
if strlowcase(name) eq 'hoii' then $
   alias = [alias, 'holmbergii']
if strlowcase(name) eq 'holmbergi' then $
   alias = [alias, 'hoi']
if strlowcase(name) eq 'holmbergii' then $
   alias = [alias, 'hoii']

; INITIALIZE EMPTY STRUCTURE
s = {name:'' $
     , dist_mpc:!values.f_nan $
;    POSITION AND ORIENTATION
     , ra_deg:!values.d_nan $
     , dec_deg:!values.d_nan $
     , posang_deg:!values.f_nan $
     , incl_deg:!values.f_nan $
;    KINEMATICS ... FIRST TWO ARE LEDA HI, LAST TWO ARE MY FITS
     , vhel_kms:!values.f_nan $
     , vrot_kms:!values.f_nan $
     , vrot_r25:!values.f_nan $
     , vflat_kms:!values.f_nan $
     , lflat_kpc:!values.f_nan $
     , hi_vhel_kms:!values.f_nan $
     , hi_vrot_kms:!values.f_nan $
;    GALACTIC (MILKY WAY) EXTINCTION FROM LEDA
     , e_bmv:!values.f_nan $
;    TOTAL APPARENT B MAGNITUDE FROM LEDA
     , b_mag:!values.f_nan $
;    SIZE: OPTICAL DIAMETER FROM LEDA, STELLAR SCALE LENGTH IN KPC, AS
     , d25_am:!values.f_nan $
     , lstar_kpc:!values.f_nan $
     , l3p6_as:!values.f_nan $
;    EFFECTIVE B-V COLOR FROM LEDA
     , bmv_eff:!values.f_nan $
;    MORPHOLOGICAL TYPE T FROM LEDA
     , t:!values.f_nan $
;    MEDIAN VELOCITY DISPERSION FROM 0.5 - 1 R25 (PROBABLY SHOULD BE CUT)
     , vdisp_kms:!values.f_nan $
;    CHARACTERISTIC METALLICITY (NEEDS UPDATING)
     , logoh:!values.f_nan $
    }

; DIRECTORY FOR FILES
if n_elements(data_dir) eq 0 then begin
    data_dir = '$MY_IDL/nearby_galaxies/gal_data/'
endif

; ################################
; ### POSITION AND ORIENTATION ###
; ################################

posfile = data_dir+'position.txt'
readcol, posfile, pos_name, pos_incl, pos_pa $
         , rah,ram,ras $
         , dec_sign,ddeg,dmin,dsec $
         , hasrotcur $
         , format='A,F,F,F,F,F,A,F,F,F,I',skip=1, /silent $
         , comment='#'

rctr = (rah+ram/60.+ras/3600.)*15.
dctr = abs(ddeg)+dmin/60.+dsec/3600.

sign = (dec_sign eq '-')*(-1.0) + (dec_sign eq '+')*1.0

dctr *= sign

; MATCH NAME TO STRUCTURE
ind = where(pos_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(pos_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
    s.name = name
    s.posang_deg = pos_pa[ind]
    s.incl_deg   = pos_incl[ind]
    s.ra_deg     = rctr[ind]
    s.dec_deg    = dctr[ind]
endif else begin
;   IF YOU CAN'T MATCH THE STRUCTURE, YOU ARE SUNK, RETURN -1
   if keyword_set(quiet) eq 0 then $
      message, 'No match for '+name+'. Returning -1.', /info
   return, -1
endelse

; ################
; ### DISTANCE ###
; ################

distfile = data_dir+'table_dist.txt'
readcol, distfile, dist_name, dist, format='A,F', comment='#', /silent
ind = where(dist_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(dist_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
   s.dist_mpc = dist[ind]
endif else begin
   comment = [comment, "Distance not found." ]
endelse

; ###################
; ### B MAGNITUDE ###
; ###################

bmagfile = data_dir+'table_bmag.txt'
readcol, bmagfile, bmag_name, bmag, format='A,F', comment='#', /silent
ind = where(bmag_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(bmag_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
   s.b_mag = bmag[ind]
endif else begin
   comment = [comment, "B mag not found." ]
endelse

; ###########################
; ### GALACTIC EXTINCTION ###
; ###########################

extfile = data_dir+'table_galext.txt'
readcol, extfile, ebmv_name, ebmv, format='A,F', comment='#', /silent
ind = where(ebmv_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(ebmv_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
   s.e_bmv = ebmv[ind]
endif else begin
   comment = [comment, "Extinction not found." ]
endelse

; #########################
; ### ROTATION VELOCITY ###
; #########################

vrotfile = data_dir+'table_vrot.txt'
readcol, vrotfile, vrot_name, vrot, format='A,F' $
         , comment='#', delim='|', /silent
vrot_name = strcompress(vrot_name, /rem)
ind = where(vrot_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(vrot_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
   s.vrot_kms = vrot[ind]
endif else begin
   comment = [comment, "Rotation velocity not found." ]
endelse

; ##################
; ### MORPHOLOGY ###
; ##################

ttypefile = data_dir+'table_ttype.txt'
readcol, ttypefile, ttype_name, ttype, format='A,F' $
         , comment='#', delim='|', /silent
ttype_name = strcompress(ttype_name, /rem)
ind = where(ttype_name eq name, ct)
if ct eq 0 then begin
   for i = 0, n_elements(alias)-1 do begin
      if ct gt 0 then continue
      ind = where(ttype_name eq alias[i], ct)
   endfor
endif
if ct gt 0 then begin
   s.t = ttype[ind]
endif else begin
   comment = [comment, "Rotation velocity not found." ]
endelse

; #######################
; ### LEDA PARAMETERS ###
; #######################

; BASIC PARAMETERS
bparamfile = data_dir+'table_basic_paras.txt'
readcol, bparamfile, bparam_name,bparam_dist,bparam_bapp,bparam_babs $
  , bparam_logd25, bparam_metal, bparam_hi, bparam_sfr, bparam_t $
  , bparam_ebmv, bparam_vrotr25, bparam_bmveff $
  , format='A,F,F,F,F,F,F,F,F,F,F', /silent

; MATCH NAME TO BASIC OBSERVATIONAL PARAMETERS
bparam_ind = where(bparam_name eq name, ct)
if ct gt 0 then begin
    s.d25_am = 0.1*10.^(bparam_logd25[bparam_ind])    
    s.vrot_r25 = bparam_vrotr25[bparam_ind]    
    s.logoh = bparam_metal[bparam_ind]
    s.bmv_eff = bparam_bmveff[bparam_ind]
endif else begin
;   WARN, BUT DON'T CRASH WHEN WE CANNOT FIND BASIC PARAMETERS
   if keyword_set(quiet) eq 0 then $
      message, 'No match for '+name+' in basic parameters.', /info
 endelse

; ############################
; ### KINEMATIC PROPERTIES ###
; ############################

; A FIXED VELOCITY DISPERSION
s.vdisp_kms = 11.0

; ROTATION CURVES IN A BOTTLE; READ IN OUR FIT PARAMETERS
kinfile = data_dir + 'table_rcfit.txt'
readcol, kinfile, $
         delim='|', $
         comment='#', $
         format='A,F,F,F,F' $
         ,/silent $
         , kin_name, kin_vflat, kin_lflat_deg, kin_lflat_kpc, kin_vsys

for kk = 0, n_elements(kin_name)-1 do $
  kin_name[kk] = strcompress(kin_name[kk],/remove_all)

kin_ind = where(kin_name eq name, ct)
if ct gt 0 then begin
    if (finite(kin_vflat[kin_ind])) then begin
        s.vflat_kms = kin_vflat[kin_ind]
        s.lflat_kpc = kin_lflat_kpc[kin_ind]
        s.vhel_kms = kin_vsys[kin_ind]
    endif
endif else begin
;   WARN, BUT DON'T CRASH WHEN WE CANNOT FIND ROTATION CURVE
   if keyword_set(quiet) eq 0 then $
      message, 'No match for '+name+' in rotation curves.', /info
endelse

; READ THE HI FILE
hi_file = data_dir + 'leda_hi_line.txt'
readcol, hi_file, delim = '|', format='A,F,X,F,X' $
         , hi_name, rotation_velocity, radial_velocity, /silent
hi_name = strcompress(hi_name,/remove_all)
hi_ind = where(hi_name eq name,ct)
if ct gt 0 then begin
   s.hi_vhel_kms = radial_velocity[hi_ind]
   s.hi_vrot_kms = rotation_velocity[hi_ind]
endif

; ##########################
; ### STELLAR PROPERTIES ###
; ##########################

; STELLAR SCALE LENGTH IN ARCSECONDS
sl_file = data_dir+ 'i3p6_sl.txt'
readcol, sl_file, format='A,F,F', i3p6_gal, i3p6_sl_as, i3p6_uc $
         , /nan, comment='#', /silent
sl_ind = where(i3p6_gal eq name, ct)
if ct gt 0 then begin
   s.l3p6_as = i3p6_sl_as[sl_ind]
endif

; STELLAR SCALE LENGTH (EVENTUALLY ADD MASS?)
starfile = data_dir + 'starstruct.txt'
readcol, starfile, delim='|', skip=2 $
  , star_name, star_sl_kpc, format='A,X,X,F',/silent
star_name = strcompress(star_name,/remove_all)
star_ind = where(star_name eq name,ct)
if (ct gt 0) then begin
    if finite(star_sl_kpc[star_ind]) then begin
        s.lstar_kpc = star_sl_kpc[star_ind]
    endif
endif else begin
;   WARN, BUT DON'T CRASH WHEN WE CANNOT FIND STELLAR SCALE LENGTH
   if keyword_set(quiet) eq 0 then $
      message, 'No match for '+name+' in stellar parameters.', /info
endelse

; RETURN
found = 1
return, s

end                             ; of things_galaxies
