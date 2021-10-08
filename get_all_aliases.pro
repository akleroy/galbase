function get_all_aliases $
   , pgc_in $   
   , data_dir = data_dir $
   , delimiter = delimiter
  
;+
;
; Translate a PGC number into a string of aliases.
;
;-
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  if n_elements(delimiter) eq 0 then $
     delimiter = ';'

  if n_elements(data_dir) eq 0 then begin
     result = routine_info('get_all_aliases', /function, /source)
     progpos = stregex(result.path,'get_all_aliases.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif
     
  restore, data_dir+'superset_alias.idl', /v
  n_alias = n_elements(alias_vec)
  sort_master = sort(pgc_vec)
  alias_vec = strupcase(alias_vec[sort_master])
  pgc_vec = pgc_vec[sort_master]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; LOOP OVER INPUTS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  n = n_elements(pgc_in)
  name_out = strarr(n) 
  sort_ind = sort(pgc_in)
  sorted_pgc = pgc_in[sort_ind]
  sorted_name = strarr(n)

  min_to_check = 0L
  for ii = 0L, n-1 do begin
     this_name = ''
     for jj = min_to_check, n_alias-1 do begin
        min_to_check = jj
        if sorted_pgc[ii] eq pgc_vec[jj] then begin
           if this_name eq '' then $
              this_name = alias_vec[jj] $
           else begin
              this_name = this_name+delimiter+alias_vec[jj]
           endelse
        endif
        if sorted_pgc[ii] lt pgc_vec[jj] then begin
           break
        endif
     endfor
     sorted_name[ii] = this_name
  endfor

  name_out[sort_ind] = sorted_name

  return, name_out

end
