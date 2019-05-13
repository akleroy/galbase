function pgc_to_othername $
   , pgc_in $
   , prefix=prefix $
   , data_dir = data_dir

;+
;
; Get other names given some prefix and a PGC number.
;
;-

  if n_elements(prefix) eq 0 then $
     prefix = 'NGC'
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if n_elements(data_dir) eq 0 then begin
     result = routine_info('pgc_to_othername', /function, /source)        
     progpos = stregex(result.path,'pgc_to_othername.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif
     
  restore, data_dir+'superset_alias.idl', /v

  n_pgc_in = n_elements(pgc_in)
  nameout = strarr(n_pgc_in)

  for ii = 0, n_pgc_in-1 do begin
     pgc_ind = where(pgc_vec eq pgc_in[ii], pgc_ct)

     if pgc_ct eq 0 then continue

     this_name = ''
     first = 1B
     for jj = 0, pgc_ct-1 do begin
        this_alias = alias_vec[pgc_ind[jj]]
        if strpos(this_alias, prefix) ne 0 then $
           continue
        if first then begin
           first = 0B
        endif else begin
           this_name += ';'
        endelse
        this_name += this_alias
     endfor
     nameout[ii] = this_name

  endfor

  return, nameout

end
