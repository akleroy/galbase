function get_good_name $
   , pgc_in $   
   , data_dir = data_dir $
   , ngc = prefer_ngc

;+
;
; Translate a PGC number into a common name.
;
;-
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if n_elements(data_dir) eq 0 then begin
     result = routine_info('get_good_name', /function, /source)        
     progpos = stregex(result.path,'get_good_name.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif
     
  restore, data_dir+'superset_alias.idl', /v
  n_alias = n_elements(alias_vec)
  sort_master = sort(pgc_vec)
  alias_vec = strupcase(alias_vec[sort_master])
  pgc_vec = pgc_vec[sort_master]

  n = n_elements(pgc_in)

  if keyword_set(prefer_ngc) then $
     priority_list = ['NGC','MES','IC','UGC','PGC'] $
  else $
     priority_list = ['MES','NGC','IC','UGC','PGC']

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; LOOP OVER INPUTS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  name_out = strarr(n)
 
  sort_ind = sort(pgc_in)
  sorted_pgc = pgc_in[sort_ind]
  sorted_name = strarr(n)

  min_to_check = 0L
  for ii = 0L, n-1 do begin
     this_name = 'none'
     for jj = min_to_check, n_alias-1 do begin
        min_to_check = jj
        if sorted_pgc[ii] eq pgc_vec[jj] then begin
           if this_name eq 'none' then $
              this_name = alias_vec[jj] $
           else begin
              current_prefix = strmid(this_name,0,3)
              new_prefix = strmid(alias_vec[jj],0,3)
              priority_current = where(current_prefix eq priority_list)
              priority_new = where(new_prefix eq priority_list)
              if priority_new lt 0 then continue
              if priority_current lt 0 then begin
                 this_name = alias_vec[jj]
              endif else begin
                 if priority_new lt priority_current then begin
                    this_name = alias_vec[jj]
                 endif
              endelse
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
