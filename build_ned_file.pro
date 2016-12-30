pro build_ned_file $
   , rebuild=rebuild

  ned_file = 'gal_data/ned_data.txt'

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE LEDA DATABASE FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  infiles = $
     ["gal_data/leda_vlsr5000.fits" $
      ,"gal_data/leda_atlas3d.fits" $
      ,"gal_data/leda_califa.fits" $
      ,"gal_data/leda_s4g.fits" $
      ,"gal_data/leda_lga2mass.fits" $      
      ,"gal_data/leda_sings.fits" $ 
      ]
  n_infiles = n_elements(infiles)
  
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
  
  for zz = 0, n_infiles-1 do begin

     tab = mrdfits(infiles[zz], 1, hdr)

;     list = tab.objname
     list = 'PGC'+str(tab.pgc)
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
                  , found=found $
                  , header=header $
                  , outline=line
        
        if found eq 0 then begin
           message, "Skipping "+list[ii], /info
           continue
        endif

        if keyword_set(rebuild) and first then begin
           for kk = 0, n_elements(header)-1 do $
              printf, unit, header[kk]
        endif
        printf, unit, line

        first = 0B

     endfor

  endfor

  close, unit

end
