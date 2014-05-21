pro generate_ebv_scratch

; DIRECTORY FOR FILES
  if n_elements(data_dir) eq 0 then begin
     data_dir = 'gal_data/'
  endif

; ASSUME THAT THE LEDA FITS FILES GIVE YOU THE NAME LIST
  infile = data_dir+"leda_vlsr3500.fits"
  leda = mrdfits(infile, 1, hdr)

; PRINT OUT A LIST OF COORDINATES AS A SCRATCH FILE THEN GO TO 

; irsa.ipac.caltech.edu/applications/DUST/  

  openw, 1, data_dir+"scratch_for_ipac.txt"
  printf, 1, "| objname   | ra     | dec    |"
  printf, 1, "| char      | double | double |" 
  for i = 0, n_elements(test)-1 do begin
     printf, 1, leda[i].name, " ", leda[i].al2000*15., " ", leda[i].de2000
  endfor  
  close, 1

end
