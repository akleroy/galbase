pro build_simbad_file

;+
;
; Query simbad to get the VJHK magnitudes. This is a test for now to
; see if simbad's archival photometry gives us enough coverage to be
; useful. Initially it appears not to me.
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE LEDA DATABASE FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  infile = "gal_data/leda_vlsr5000.fits"
  tab = mrdfits(infile, 1, hdr)
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW FOR ALL OF OUR TARGETS, QUERY SIMBAD
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  list = tab.objname
  n_list = n_elements(list)
  nan = !values.f_nan

  for ii = 0, n_list-1 do begin
     name = list[ii]
     vmag = nan
     jmag = nan
     hmag = nan
     kmag = nan
     querysimbad, name, ra, de, id $
                  , found = found, errmsg = errmsg $
                  , vmag=vmag, jmag=jmag, hmag=hmag, kmag=kmag
     print, found, vmag, jmag, hmag, kmag, tab[ii].btc, tab[ii].itc
     if found eq 0 then stop
  endfor

end
