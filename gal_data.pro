function gal_data $
   , name_in $
   , data_dir=data_dir $
   , found=found $
   , quiet=quiet

;+
; NAME:
;
; galaxies
;
; PURPOSE:
;
; Retreives basic information a galaxy and returns an IDL structure.
;
; CATEGORY:
;
; Science tool
;
; CALLING SEQUENCE:
;
; s = galaxies('ngc5055')
;
; INPUTS:
;
; The name of the galaxy you want a structure for in a format of:
;
; lower case catalog + number (e.g. ngc5055 or ic2574)
;
; OPTIONAL INPUTS:
;
; data_dir : the location of my structure files
;
; KEYWORD PARAMETERS:
;
; none
;
; OUTPUTS:
;
; A structure containing fields corresponding to galaxy properties.
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
; cleanup, aliases, still could use a dedicated day - dec 11
; revamp, cleanup, checkin to GIT - feb 14
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; HANDLE VECTORS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; Check that we got a name. Also handle the case where we got a vector
; of names by looping over the list of names and calling the program
; each time (inefficient because of the re-reading, but cleaner
; code). Else, pass through this section to the main body.

; ERROR CATCHING
  if n_elements(name_in) eq 0 then begin
     message, 'Need a name to find a galaxy. Returning empty structure', /info    
     return, empty_gal_struct()
  endif

; IF WE HAVE A VECTOR SET UP A RECURSIVE LOOP
  if n_elements(name_in) gt 1 then begin
     for j = 0, n_elements(name_in)-1 do begin
        if j eq 0 then $
           s_vec = [gal_data(name_in[j])] $
        else $
           s_vec = [s_vec, gal_data(name_in[j])]
     endfor

;    RETURN THE VECTOR
     return, s_vec
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFAULTS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Initialize default values, directories, etc.

; INITIALIZE AN EMPTY GALAXY STRUCTURE
  s = empty_gal_struct()

; SHIFT THE NAME TO LOWER CASE
  name = strcompress(strlowcase(name_in), /rem) 

; INITIALIZE THE FOUND FLAG
  found = -1
  
; INITIALIZE COMMENTS
  comment = ""
  
; DIRECTORY FOR FILES
  if n_elements(data_dir) eq 0 then begin
     data_dir = '$MY_IDL/nearby_galaxies/gal_data/'
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; IDENTIFY THE GALAXY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Check if the galaxy is in the target list.
  
  readcol, data_dir+"target_list.txt" $
           , format='A' $
           , comment="#" $
           , all_names $
           , /silent
  found = total(all_names eq name)
  
  if found gt 1 then begin
     message, "Too many matches. Stopping for debugging.", /info
  endif
  
; If the galaxy is not in the target list, check for aliases.

  if found eq 0 then begin

     readcol, data_dir+"alias.txt" $
              , format='A,A' $
              , alist_name, alist_alias $
              , comment = "#" $
              , /silent
     n_alias = n_elements(alist_name)
     
;    LOOP OVER ALIASES
     for i = 0, n_alias-1 do begin

;       CONTINUE IF WE ALREADY FOUND THE GALAXY
        if found then $
           continue

;       IF WE HAVE A MATCH, NOTE THAT WE FOUND THE GALAXY AND WRITE
;       DOWN THE NAME.
        if name eq alist_alias[i] eq 0 then begin
           name = alist_name[i]
           found = 1B
        endif

     endfor

;    HANDLE THE CASE OF NO MATCH
     if found eq 0 then begin
        message $
           , 'No match for '+name_in+ $
           ' in database. Returning empty structure.', /info
        return, s 
     endif
     
  endif

; RECORD THE NAME
  s.name = name
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; BASICS: POSITION AND DISTANCE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; Every galaxy has a distance, a center position, a Galactic (Milky
; Way) foreground extinction, and an isophotal radius.

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; DISTANCE
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  dist_file = data_dir+'table_dist.txt'
  readcol, dist_file $
           , dist_name $
           , dist_mpc $
           , format="A,F" $
           , /silent $
           , comment='#'

  ind = where(dist_name eq name, ct)
  if ct eq 1 then begin
     s.dist_mpc = dist_mpc[ind]
  endif else begin
     message $
        , 'No distance for '+name, /info
  endelse

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CENTER POSITION
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  pos_file = data_dir+'leda_position.txt'
  readcol, pos_file $
           , pos_name $
           , pos_al2000 $
           , pos_de2000 $
           , format="A,F,F" $
           , delim="|" $
           , /silent $
           , comment='#'
  pos_name = strcompress(pos_name, /rem)

  ind = where(pos_name eq name, ct)
  if ct eq 1 then begin
     s.ra_deg = pos_al2000[ind]*15.
     s.dec_deg = pos_de2000[ind]
  endif else begin
     message $
        , 'No position for '+name, /info
  endelse
  
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; GALACTIC EXTINCTION
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  mwext_file = data_dir+'extinction.tbl'
  readcol, mwext_file $
           , mwext_name $
           , mwext_sf11 $
           , mwext_sf11_mean $
           , mwext_sfd98 $
           , mwext_sfd98_mean $
           , format="A,X,X,X,F,F,X,X,X,X,F,F" $
           , /silent $
           , comment='#' $
           , /nan
  mwext_name = strcompress(mwext_name, /rem)

  ind = where(mwext_name eq name, ct)
  if ct eq 1 then begin
     s.e_bmv = mwext_sf11_mean[ind]
  endif else begin
     message $
        , 'No extinction for '+name, /info
  endelse

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ISOPHOTAL RADIUS
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  diam_file = data_dir+'leda_diameter.txt'
  readcol, diam_file $
           , diam_name $
           , diam_logd25 $
           , diam_elogd25 $
           , format="A,F,F" $
           , delim="|" $
           , /silent $
           , comment='#' $
           , /nan
  diam_name = strcompress(diam_name, /rem)

  ind = where(diam_name eq name, ct)
  if ct eq 1 then begin
     s.d25_am = 10.^(diam_logd25[ind])*10.
     s.e_logd25 = diam_elogd25[ind]
     s.r25_deg = 2.0*s.d25_am/60.
     s.e_logr25 = s.e_logr25
  endif else begin
     message $
        , 'No position for '+name, /info
  endelse

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; MORPHOLOGY
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  morph_file = data_dir+'leda_morphology.txt'
  readcol, morph_file $
           , morph_name $
           , morph_type $
           , morph_bar $
           , morph_ring $
           , morph_multiple $
           , morph_compact $
           , morph_t $
           , morph_et $
           , format="A,A,A,A,A,A,F,F" $
           , delim="|" $
           , /silent $
           , comment='#'
  morph_name = strcompress(morph_name, /rem)

  ind = where(morph_name eq name, ct)
  if ct eq 1 then begin
     s.t = morph_t[ind]
     s.e_t = morph_et[ind]
     if strcompress(morph_bar[ind], /remove_all) eq "B" then $
        s.bar = 1B
     if strcompress(morph_ring[ind], /remove_all) eq "R" then $
        s.ring = 1B
  endif else begin
     message $
        , 'No morphology for '+name, /info
  endelse

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ORIENTATION
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  orient_file = data_dir+'leda_orient.txt'
  readcol, orient_file $
           , orient_name $
           , orient_logr25 $
           , orient_elogr25 $
           , orient_pa $
           , orient_incl $
           , format="A,F,F,F,F" $
           , delim="|" $
           , /silent $
           , comment='#' $
           , /nan
  orient_name = strcompress(orient_name, /rem)

  ind = where(orient_name eq name, ct)
  if ct eq 1 then begin
     s.posang_deg = orient_pa[ind]
     s.incl_deg = orient_incl[ind]
  endif else begin
     message $
        , 'No orientation for '+name, /info
  endelse

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; VALUE-ADDED (GALAXY INTEGRATED) INFORMATION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FINISH
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  return, s

end                             ; of gal_data
