pro generate_ebv

; DIRECTORY FOR FILES
  if n_elements(data_dir) eq 0 then begin
     data_dir = '$MY_IDL/nearby_galaxies/gal_data/'
  endif

; READ THE FULL LIST
  readcol, data_dir+"target_list.txt" $
           , format='A' $
           , comment="#" $
           , all_names

; GET THE DATA
  test = gal_data(all_names)

; LOOP OVER GALAXIES
  for i = 0, n_elements(test)-1 do begin
     glactc, test[i].ra_deg, test[i].dec_deg, 2000, gl, gb, 1
     ebv = dust_getval(gl, gb, /interp)
     tg = things_galaxies(test[i].name, found=found)
     if found eq 1 then $
        print, test[i].name, ebv, tg.e_bmv
  endfor

; PRINT OUT A LIST OF COORDINATES AS A SCRATCH FILE THEN GO TO 

; irsa.ipac.caltech.edu/applications/DUST/  

  openw, 1, data_dir+"scratch_for_ipac.txt"
  printf, 1, "| objname   | ra     | dec    |"
  printf, 1, "| char      | double | double |" 
  for i = 0, n_elements(test)-1 do begin
     printf, 1, test[i].name, " ", test[i].ra_deg, " ", test[i].dec_deg
  endfor  
  close, 1

  STOP

end


end
