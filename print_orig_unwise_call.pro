pro print_unwise_cutout_call

;+
;
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PICK THE SAMPLE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; First, down select to get the list of galaxies for which we want
; cutouts.

  data = gal_data(/all)

  n_gals = n_elements(data)

  distmod = 5.*alog10(data.dist_mpc*1d6)-5.
  abs_b_mag = data.btc_mag - distmod

  keep = bytarr(n_gals)
  keep[where(abs_b_mag lt -18.)] = 1B

  for ii = 0, n_gals-1 do begin
     this_tag = strupcase(strsplit(strcompress(data[ii].tags,/rem), ';', /extract))
     if total(this_tag eq 'S4G') eq 1 or $
        total(this_tag eq 'ATLAS3D') then $
           keep[ii] = 1B
  endfor

  data = data[where(keep)]

  n_gals = n_elements(data)

  stop
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE THE CALL
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Pixel scale of unwise in arcseconds.

  pix_scale = 2.75

; Loop over galaxies and write calls to extract the data.

  base_call = 'python -u unwise_coadd.py'
  band1_ext = ' --band 1'
  band2_ext = ' --band 2'
  band3_ext = ' --band 3 --bgmatch --medfilt 0'
  band4_ext = ' --band 4 --bgmatch --medfilt 0'
  
  out_dir = 'z0mgs/'
  
  openw, unit, 'unwise_call.txt', /get_lun

  for ii = 0, n_gals-1 do begin

     this_data = data[ii]

     pgc_name = 'PGC'+str(this_data.pgc)
     ra_str = str(this_data.ra_deg)
     dec_str = str(this_data.dec_deg)

     this_r25 = this_data.r25_deg*3600.
     if finite(this_r25) eq 0 then $     
        size_str = '655' $
     else begin
        target_size = 6.*this_r25/pix_scale
        if target_size gt 655 then begin
           print, "Big galaxy: ", this_data.name
           size_str = str(long(round(target_size)))
        endif else begin
           size_str = '655'
        endelse
     endelse

     for band = 1, 4 do begin

        if band eq 1 then this_band_ext = band1_ext
        if band eq 2 then this_band_ext = band2_ext
        if band eq 3 then this_band_ext = band3_ext
        if band eq 4 then this_band_ext = band4_ext

        call = base_call + ' -o '+out_dir+ $
               ' --size '+size_str+ $
               ' --ra '+ra_str+ $
               ' --dec '+dec_str+ $
               ' --name '+pgc_name+ $
               this_band_ext

        printf, unit, call

     endfor

  endfor

  close, unit

end
