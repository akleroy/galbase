pro convert_ned_to_pgc

;+
;
; This script should convert our NED distances file to only use PGC
; names. This standardization should make duplicate detection easier
; and resolve some ambiguities. We should only need to run it
; once, so it's not a general part of the galbase
; construction. Instead, it's here to patch results of the
; previous version to avoid another days-long query.
;
;-
  
; Start the new ned file

  new_ned_file = 'gal_data/ned_data.txt'

  queryned, 'NGC3184' $
            , found=found $
            , header=header $
            , outline=line  

  openw, unit, new_ned_file, /get_lun
  for kk = 0, n_elements(header)-1 do $
     printf, unit, header[kk]

; Loop over the LEDA input files to build a matched OBJNAME<->PGCNAME list

  infiles = $
     ["gal_data/leda_vlsr5000.fits" $
      ,"gal_data/leda_atlas3d.fits" $
      ,"gal_data/leda_califa.fits" $
      ,"gal_data/leda_s4g.fits" $
      ,"gal_data/leda_lga2mass.fits" $      
      ,"gal_data/leda_sings.fits" $ 
     ]
  n_infiles = n_elements(infiles)
  
  for ii = 0, n_infiles-1 do begin
     this_tab = mrdfits(infiles[ii], 1, hdr)
     
     if n_elements(objname_key) eq 0 then begin
        objname_key = strupcase(strcompress(this_tab.objname,/rem))
        pgcname_key = "PGC"+str(this_tab.pgc)
     endif else begin
        objname_key = $
           [objname_key, this_tab.objname]
        pgcname_key = $
           [pgcname_key, "PGC"+str(this_tab.pgc)]
     endelse

  endfor

; Now loop over the NED file

; Read the old ned file

  old_ned_file = 'old_data/old_ned_data.txt'

  readcol $
     , old_ned_file, commen='#', delim='|' $
     , format = 'A,F,F,F,F,F,F,F,F,F,F,F' $
     , ned_name, ned_ra, ned_dec, ned_distmod, e_ned_distmod $
     , ned_d, e_ned_d, ned_mind, ned_maxd, ned_vhel, ned_vhel_err $
     , ned_av

  ned_name = strupcase(strcompress(ned_name,/rem))
  n_ned_names = n_elements(ned_name)
  
  new_pgc_name = strarr(n_ned_names)
  found_match = bytarr(n_ned_names)

  for ii = 0, n_ned_names-1 do begin
     
     ind = where(ned_name[ii] eq objname_key, ct)
     if ct ge 1 then found_match[ii] = 1B else $
        print, "No match for "+ ned_name[ii]
     new_pgc_name[ii] = pgcname_key[ind[0]]

  endfor

; Now write out the cases where we have a match

  for ii = 0, n_ned_names-1 do begin
     if found_match[ii] eq 0 then $
        continue

     line = ''
     line += string(new_pgc_name[ii], format='(a15)')+' | '
     line += string(ned_ra[ii], format='(d12.6)')+' | '
     line += string(ned_dec[ii], format='(d12.6)')+' | '
     line += string(ned_distmod[ii], format='(d12.6)')+' | '
     line += string(e_ned_distmod[ii], format='(d12.6)')+' | '
     line += string(ned_d[ii], format='(d12.6)')+' | '
     line += string(e_ned_d[ii], format='(d12.6)')+' | '
     line += string(ned_mind[ii], format='(d12.6)')+' | '
     line += string(ned_maxd[ii], format='(d12.6)')+' | '
     line += string(ned_vhel[ii], format='(d12.6)')+' | '
     line += string(ned_vhel_err[ii], format='(d12.6)')+' | '
     line += string(ned_av[ii], format='(d12.6)')  

     printf, unit, line
  endfor

  close, unit

end
