pro generate_ebv_scratch

; DIRECTORY FOR FILES
  if n_elements(data_dir) eq 0 then begin
     data_dir = 'gal_data/'
  endif

; ASSUME THAT THE LEDA FITS FILES GIVE YOU THE NAME LIST
  infile = data_dir+"leda_vlsr3500.fits"
  leda = mrdfits(infile, 1, hdr)

; PRINT OUT A LIST OF COORDINATES AS A SCRATCH FILE THEN GO TO 

  counter = 0L
  sub_counter = 0L
  fnum = 1L
  while counter lt n_elements(leda) do begin
     
     if sub_counter eq 0 then begin
        fname = data_dir+"scratch_for_ipac_"+str(fnum)+".txt"
        print, "Opening "+fname
        openw, 1, fname
        printf, 1, "| objname   | ra     | dec    |"
        printf, 1, "| char      | double | double |" 
     endif

     objname = "pgc"+strcompress(str(leda[counter].pgc),/rem)
     printf, 1, objname, " ", leda[counter].al2000*15., " ", leda[counter].de2000

     sub_counter += 1
     counter += 1 
     if sub_counter eq 20e3 then begin
        close, 1
        sub_counter = 0
        fnum += 1
        print, "I hit the limit for an IPAC upload, starting a new file."
     endif
  endwhile

  print, "Now go to: irsa.ipac.caltech.edu/applications/DUST/ "
  

end
