function gal_data $
   , name_in $
   , pgc=pgc_in $
   , dir=data_dir $
   , data=data $
   , found=found $
   , all=all $
   , tag=tag $
   , quiet=quiet $
   , full=full

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
; dir : the location of structure
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
; total overhaul - may 18
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFAULTS READ AND DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; DEFAULT TO NOT FOUND
  found = 0B

; CHECK THAT WE GOT A NAME
  if n_elements(name_in) eq 0 and n_elements(pgc_in) eq 0 and $
     keyword_set(all) eq 0 and $
     n_elements(tag) eq 0 then begin
     message, 'Need a name or a PGC number to find a galaxy. Returning empty structure', /info    
     return, empty_gal_struct()
  endif

  use_pgc = 0B
  use_name = 1B
  if n_elements(name_in) eq 0 and n_elements(pgc_in) ne 0 then begin
     use_pgc = 1B
     use_name = 0B
  endif
     
; READ THE DATA BASE
  if n_elements(data_dir) eq 0 then begin
     result = routine_info('gal_data',/function,/source)
     progpos = stregex(result.path,'gal_data.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif

  if n_elements(data) eq 0 then begin
     if keyword_set(full) then begin
        infile = data_dir+"gal_base.fits"
     endif else begin
        infile = data_dir+"gal_base_local.fits"
     endelse
     data = mrdfits(infile, 1, hdr)
  endif
  n_data = n_elements(data)

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEAL WITH THE CASE WHERE THEY WANT ALL DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
     
  if keyword_set(all) then $
     return, data

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEAL WITH THE CASE WHERE THEY WANT DATA WITH JUST SOME TAGS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if n_elements(tag) gt 0 then begin
     n_data = n_elements(data)
     keep = bytarr(n_data)+1B
     for ii = 0, n_data-1 do begin
        this_tag = strsplit(strcompress(data[ii].tags,/rem), ';', /extract)
        for jj = 0, n_elements(tag)-1 do $
           keep[ii] = keep[ii]*total(this_tag eq strupcase(tag[jj]))
     endfor
     if total(keep) eq 0 then begin
        message, 'No targets found with that tag combination. Returning an empty structure.', /info
        return, empty_gal_struct()
     endif
     return, data[where(keep)]
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; QUERY ON GALAXY NAME
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if use_pgc then begin
     pgc_num = pgc_in
  endif else begin
     pgc_num = get_pgc(name_in)
  endelse
  sort_ind = sort(pgc_num)
  sorted_pgc = pgc_num[sort_ind]
  n_names = n_elements(pgc_num)

  output = replicate(empty_gal_struct(), n_names)
  found = bytarr(n_names)
  
  min_to_check = 0L
  for ii = 0L, n_names-1 do begin
     this_pgc = sorted_pgc[ii]
     output_ind = sort_ind[ii]
     if this_pgc eq -1 then continue
     for jj = min_to_check, n_data-1 do begin
        min_to_check = jj
        if this_pgc eq data[jj].pgc then begin
           output[output_ind] = data[jj]
           found[output_ind] = 1B
           break
        endif
        if this_pgc lt data[jj].pgc then begin
           break
        endif
     endfor
  endfor
  
  return, output

end                           
