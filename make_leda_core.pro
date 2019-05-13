pro make_leda_core $
   , for_sample = sample_file $
   , send = do_send $
   , parse = do_parse
  
;+
;
; Makes the core LEDA database that underpins the galbase. In the
; refactored version, we will pull EVERY galaxy within a velocity and
; a 'galaxy' type with v < 30,000 km/s.
;
;-

  nan = !values.f_nan
  empty_struct = $
     { $
     pgc:-1L $
     ,objname:'' $
     ,hl_names:'' $
     ,modz:nan $
     ,e_modz:nan $
     ,mod0:nan $
     ,e_mod0:nan $
     ,modbest:nan $
     ,e_modbest:nan $
     ,al2000:nan $
     ,de2000:nan $
     ,logd25: nan $
     ,e_logd25: nan $
     ,logr25: nan $
     ,e_logr25: nan $
     ,v:nan $
     ,e_v:nan $
     ,vrad:nan $
     ,e_vrad:nan $
     ,vopt:nan $
     ,e_vopt:nan $
     ,vvir:nan $
     ,pa: nan $
     ,incl: nan $
     ,vrot:nan $
     ,e_vrot:nan $
     ,vmaxg:nan $
     ,e_vmaxg:nan $
     ,vmaxs:nan $
     ,e_vmaxs:nan $
     ,vdis:nan $
     ,e_vdis:nan $
     ,ut:nan $
     ,e_ut:nan $
     ,bt:nan $
     ,e_bt:nan $
     ,btc:nan $
     ,vt:nan $
     ,e_vt:nan $
     ,it:nan $
     ,e_it:nan $
     ,kt:nan $
     ,e_kt:nan $
     ,m21:nan $
     ,e_m21:nan $
     ,mfir:nan $
     ,t:nan $
     ,e_t:nan $
     ,type:'' $
     ,bar:'' $
     ,ring:'' $
     ,multiple:'' $
     ,agnclass:'' $
     }
       
  fields_to_query = tag_names(empty_struct)
  ind = where(fields_to_query eq 'HL_NAMES')
  fields_to_query[ind] = 'HL_NAMES(PGC)'
  n_fields = n_elements(fields_to_query)

  out_file = 'gal_data/leda_scratch.txt'
  fits_file = 'gal_data/leda_database.fits'

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFINE THE QUERY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  url_base = 'http://leda.univ-lyon1.fr/fG.cgi?n=meandata&c=o&of=1,leda,ned&nra=l&nakd=1'
 
  url_fields = 'd='
  for ii = 0, n_fields-1 do begin
     if ii gt 0 then url_fields += '%2C'
     url_fields += fields_to_query[ii]
  endfor
  
  url_format = 'ob=&a=csv%5B%7C%5D'
 
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFINE THE SELECTION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Adjust this to change the redshift selection
  vcut = '30000'

  url_select = 'sql=v%20%3C%20'+vcut+'%20and%20objtype%3D%27G%27&'

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; ASSEMBLE AND SEND THE QUERY
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  whole_url = url_base + '&' + url_fields + '&' + url_select + '&' + url_format

  print, "HyperLEDA SQL query URL was: ", whole_url
  
  if keyword_set(do_send) then begin

     spawn, 'rm -rf '+out_file
     spawn, 'wget -O '+out_file+' "'+whole_url+'"'
     spawn, 'cat '+out_file
     
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PARSE THE OUTPUT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
   
  if keyword_set(do_parse) then begin

     print, "Counting lines in the file."

     get_lun, lun
     openr, lun, out_file
     n_entry = 0L
     while not eof(lun) do begin
        line = ''
        readf, lun, line
        if strmid(line,0,1) eq '#' then continue
        if strmid(line,0,1) eq '-' then continue
        if strupcase(strmid(line,0,1)) eq 'P' then continue
        n_entry += 1
     endwhile
     close, 1

     print, "Found "+string(n_entry)+" lines."

     data = replicate(empty_struct, n_entry)

     print, "Parsing the file."

     get_lun, lun
     openr, lun, out_file
     this_entry = 0L
     while not eof(lun) do begin
        counter, this_entry, n_entry, 'Reading line '
        line = ''
        readf, lun, line
        if strmid(line,0,1) eq '#' then continue
        if strmid(line,0,1) eq '-' then continue
        if strupcase(strmid(line,0,1)) eq 'P' then continue
        tokens = strsplit(line,'|',/extract,/preserve_null)
        n_tokens = n_elements(tokens)
        for jj = 0, n_elements(tokens)-1 do begin
           if tokens[jj] eq '' then continue
           data[this_entry].(jj) = tokens[jj]
        endfor
        this_entry += 1
     endwhile
     close, 1
    
     mwrfits, data, fits_file, hdr, /create
  
  endif  
  
  stop
  
end
