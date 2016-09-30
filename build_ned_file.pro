pro build_ned_file $
   , rebuild=rebuild

  ned_file = 'gal_data/ned_data.txt'

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE LEDA DATABASE FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  infile = "gal_data/leda_vlsr5000.fits"
  tab = mrdfits(infile, 1, hdr)
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW FOR ALL OF OUR TARGETS, QUERY NED
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if keyword_set(rebuild) eq 0 then begin
     readcol $
        , ned_file $
        , comment='#', delim='|' $
        , format='A,F,F,F,F,F,F,F,F,F,F,F' $
        , name, ra, dec, mu, e_mu, d, e_d, min_d, max_d, vhel, e_vhel, a_v
     openw, unit, ned_file, /get_lun, /append
  endif else begin
     openw, unit, ned_file, /get_lun
  endelse
  
  list = tab.objname
  n_list = n_elements(list)
  
  first = 1B
  for ii = 0, n_list-1 do begin

     if keyword_set(rebuild) eq 0 then begin
        if total(strupcase(strcompress(list[ii],/rem)) eq $
                 strupcase(strcompress(name,/rem))) ge 1 then begin
           message, list[ii]+" already in file and /rebuild not set.", /info
           continue
        endif
     endif

     queryned, list[ii] $
               , header=header $
               , outline=line
     
     if keyword_set(rebuild) and first then begin
        for kk = 0, n_elements(header)-1 do $
           printf, unit, header[kk]
     endif
     printf, unit, line

     first = 0B

  endfor

  close, unit

end
