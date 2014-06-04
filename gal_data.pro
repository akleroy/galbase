function gal_data $
   , name_in $
   , data_dir=data_dir $
   , found=found $
   , all=all $
   , quiet=quiet

;+
; NAME:
;
; gal_data
;
; PURPOSE:
;
; Retreives information about a galaxy or list of galaxies as IDL structures.
;
; CATEGORY:
;
; Science tool
;
; CALLING SEQUENCE:
;
; s = gal_data('ngc5055')
;
; INPUTS:
;
; The name of the galaxy you want a structure for.
;
; OPTIONAL INPUTS:
;
; data_dir : the location of structure
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
; total overhaul - may 14
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFAULTS, DEFINITIONS, AND ERROR HANDLING
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; DEFAULT TO NOT FOUND
  found = 0B

; CHECK THAT WE GOT A NAME
  if n_elements(name_in) eq 0 and keyword_set(all) eq 0 then begin
     message, 'Need a name to find a galaxy. Returning empty structure', /info    
     return, empty_gal_struct()
  endif

; DIRECTORY FOR THE DATABASE
  if n_elements(data_dir) eq 0 then begin
     data_dir = '$MY_IDL/nearby_galaxies/gal_data/'
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE DATA BASE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; N.B. - could make this faster by saving the ALIASES + NAMES (as an
;        IDL file?) but this breaks FITS generality. Mull.

  infile = data_dir+"gal_base.fits"
  data = mrdfits(infile, 1, hdr)

  if keyword_set(all) then begin
     return, data
  endif
  
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

; WE NOW HAVE A PAIRED LIST OF {ALIAS, NAME} - A PSUEDODICTIONARY

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; IDENTIFY THE GALAXY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  n_names = n_elements(name_in)
  output = replicate(empty_gal_struct(), n_names)
  found = bytarr(n_names)
  
  name_in = strupcase(strcompress(name_in,/rem))
  name_vec = strupcase(strcompress(name_vec,/rem))
  alias_vec = strupcase(strcompress(alias_vec,/rem))
  data_name = strupcase(strcompress(data.name,/rem))

  for i = 0, n_names-1 do begin

     ind = where(alias_vec eq name_in[i], ct)
     
     if ct eq 0 then begin
        message, "No match for "+name_in[i], /info
        found[i] = 0B
        continue
     endif

     data_ind = where(data_name eq (name_vec[ind])[0], ct)
     output[i] = data[data_ind]
     found[i] = 1B
  endfor

  return, output

end                             ; of gal_data
