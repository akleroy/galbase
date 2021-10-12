pro print_unwise_cutout_call $
   , infile = infile $
   , galname = galname $
   , outdir = outdir $
   , ra_deg = ra_deg $
   , dec_deg = dec_deg $
   , size_deg = size_deg $
   , outfile = outfile $
   , min_size_in_pix = min_size_in_pix

;+
;
; Converts a CSV file or a set of arrays of format
;
; Galaxy Name, RA, Dec, Size, Output Directory
;
; into a series of unwise calls in a text file outfile.
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INPUT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Set the minimum size of a requested cutout in pixels. Defaults to
; 655 2.75" pixels. OK to leave unset.

  if n_elements(min_size_in_pix) eq 0 then $
     min_size_in_pix = 655

; Read a file if supplied. This is given priority.

  if n_elements(infile) eq 0 then begin
     readcol, infile, comments='#', delimiter=',' $
              , format='A,A,F,F,F' $
              , galname, outdir, ra_deg, dec_deg, size_deg
  endif

  if n_elements(galname) eq 0 then $
     return

  if n_elements(galname) ne n_elements(ra_deg) then $
     return

  if n_elements(galname) ne n_elements(dec_deg) then $
     return

  if n_elements(galname) ne n_elements(size_deg) then $
     return

  if n_elements(outdir) eq 1 then $
     outdir = replicate(outdir, n_elements(galname))

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; CONVERT TO THE FORMAT FOR THE CALL
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Pixel scale of unwise in arcseconds.

  pix_scale = 2.75
  
  n_gal = n_elements(ra_deg)
  ra_str = strarr(n_gal)
  dec_str = strarr(n_gal)
  size_str = strarr(n_gal)

  for ii = 0, n_gal-1 do begin
     
     ra_str = str(ra_deg[ii])     
     dec_str = str(dec_deg[ii])
     
     size_in_pix = size_deg[ii]/(pix_scale/3600.)
     if size_in_pix lt min_size_in_pix then $
        size_in_pix = min_size_in_pix
     size_str = str(long(round(size_in_pix)))   
     
  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PRINT CALL TO A TEXT FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  base_call = 'python -u unwise_coadd.py'
  band1_ext = ' --band 1'
  band2_ext = ' --band 2'
  band3_ext = ' --band 3 --bgmatch --medfilt 0'
  band4_ext = ' --band 4 --bgmatch --medfilt 0'
  
  get_lun, unit
  openw, unit, outfile, /get_lun

  for ii = 0, n_gal-1 do begin
     
     for band = 1, 4 do begin
        
        if band eq 1 then this_band_ext = band1_ext
        if band eq 2 then this_band_ext = band2_ext
        if band eq 3 then this_band_ext = band3_ext
        if band eq 4 then this_band_ext = band4_ext

        call = base_call + ' -o '+outdir[ii]+ $
               ' --size '+size_str[ii]+ $
               ' --ra '+ra_str[ii]+ $
               ' --dec '+dec_str[ii]+ $
               ' --name '+galname[ii]+ $
               this_band_ext

        printf, unit, call

     endfor

  endfor

  close, unit

end
