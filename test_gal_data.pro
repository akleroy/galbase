pro test_gal_data
  
;+
;
; Test the galaxy data program by calling it for each galaxy.
;
;-

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

  STOP

end
