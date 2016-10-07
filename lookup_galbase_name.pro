function lookup_galbase_name $
   , name_in $
   , data_dir=data_dir $
   , found=found $
   , alias_vec=alias $
   , name_vec=name


; DEFAULT TO NOT FOUND
  found = 0B

; CHECK THAT WE GOT A NAME
  if n_elements(name_in) eq 0 then begin
     message, 'Need an input name', /info    
     return, 'NONE'
  endif

; DIRECTORY FOR THE DATABASE
  if n_elements(data_dir) eq 0 then begin
     result = routine_info('lookup_galbase_name',/function,/source)
     progpos = stregex(result.path,'lookup_galbase_name.pro')
     data_dir = strmid(result.path,0,progpos)+'gal_data/'
  endif

  if n_elements(alias) eq 0 then begin
     readcol $
        , data_dir+'gal_base_alias.txt' $
        , format='A,A', comment='#' $
        , alias, name
     
     alias = strcompress(alias, /rem)
     name = strcompress(name, /rem)
  endif

  ind = where(alias eq strupcase(strcompress(name_in,/rem)), ct)
  if ct eq 0 then begin
     found = 0
     message, 'No match found.', /info
     return, 'NONE'
  endif
  
  return, name[ind]

end
