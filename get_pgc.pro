function get_pgc $
   , alias_in $   
   , data_dir = data_dir

;+
;
; Ge the list of PGC numbers corresponding to some set of aliases.
;
;-
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if n_elements(data_dir) eq 0 then begin
     result = routine_info('get_pgc', /function, /source)        
     progpos = stregex(result.path,'get_pgc.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif
     
  restore, data_dir+'superset_alias.idl', /v
  n_alias = n_elements(alias_vec)

  n = n_elements(alias_in)

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET THE PGC NUMBER
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  pgc_out = lonarr(n)*0L - 1L
 
  sorted_alias = strcompress(strupcase(alias_in), /rem)
  sort_ind = sort(sorted_alias)
  sorted_alias = sorted_alias[sort_ind]
  sorted_pgc = pgc_out[sort_ind]

  min_to_check = 0L
  for ii = 0L, n-1 do begin
     for jj = min_to_check, n_alias-1 do begin
        min_to_check = jj
        if sorted_alias[ii] eq alias_vec[jj] then begin
           sorted_pgc[ii] = pgc_vec[jj]
           break
        endif
        if sorted_alias[ii] lt alias_vec[jj] then begin
           break
        endif
     endfor
  endfor

  pgc_out[sort_ind] = sorted_pgc

  return, pgc_out

end
