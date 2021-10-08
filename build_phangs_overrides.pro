pro build_phangs_overrides

;
; Translate the official PHANGS orientations into an override file.
;

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE SAMPLE TABLE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  infile = '~/projects/phangs_sample/export/phangs_sample_table_v1p5.fits'
  tab = mrdfits(infile, 1, tab_hdr)
  n_tab = n_elements(tab)

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PRINT THE CENTERS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  outfile = 'gal_data/override_phangs_centers.txt'

  get_lun, lun
  openw, lun, outfile

  printf, lun, '# This is a procedurally generated file.'
  printf, lun, '# Editing not recommended.'
  printf, lun, '# Column 1: galaxy'
  printf, lun, '# Column 2: field'
  printf, lun, '# Column 3: value'

  for ii = 0, n_tab-1 do begin

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'ra_deg'+'   '
     line += string(tab[ii].orient_ra, format='(F11.6)')
     printf, lun, line

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'dec_deg'+'   '
     line += string(tab[ii].orient_dec, format='(F11.6)')
     printf, lun, line

  endfor

  close, lun

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NOW PRINT THE ORIENTATIONS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  outfile = 'gal_data/override_phangs_orient.txt'

  helio2lsr, vhel_kms, tab.orient_vlsr $
             , ra = tab.orient_ra $
             , dec = tab.orient_dec $
             , /reverse

  get_lun, lun
  openw, lun, outfile

  printf, lun, '# This is a procedurally generated file.'
  printf, lun, '# Editing not recommended.'
  printf, lun, '# Column 1: galaxy'
  printf, lun, '# Column 2: field'
  printf, lun, '# Column 3: value'

  for ii = 0, n_tab-1 do begin

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'incl_deg'+'   '
     line += string(tab[ii].orient_incl, format='(F5.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'e_incl'+'   '
     line += string(tab[ii].orient_incl_unc, format='(F5.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'ref_incl'+'   '
     line += tab[ii].orient_ref
     printf, lun, line

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'posang_deg'+'   '
     line += string(tab[ii].orient_posang, format='(F5.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'e_posang'+'   '
     line += string(tab[ii].orient_posang_unc, format='(F5.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'ref_posang'+'   '
     line += tab[ii].orient_ref
     printf, lun, line

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'vhel_kms'+'   '
     line += string(vhel_kms[ii], format='(F6.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'e_vhel'+'   '
     line += string(tab[ii].orient_vlsr_unc, format='(F6.1)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'ref_vhel'+'   '
     line += tab[ii].orient_vlsr_ref
     printf, lun, line

  endfor

  close, lun
  
  spawn, 'cat '+outfile

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PRINT THE DISTANCES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  outfile = 'gal_data/override_phangs_dist.txt'

  get_lun, lun
  openw, lun, outfile

  printf, lun, '# This is a procedurally generated file.'
  printf, lun, '# Editing not recommended.'
  printf, lun, '# Column 1: galaxy'
  printf, lun, '# Column 2: field'
  printf, lun, '# Column 3: value'

  for ii = 0, n_tab-1 do begin

     if finite(tab[ii].dist) eq 0 then $
        continue

     printf, lun, '#'

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'dist_mpc'+'   '
     line += string(tab[ii].dist, format='(F6.2)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'e_dist_dex'+'   '
     line += string(tab[ii].dist_unc, format='(F5.3)')
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'dist_code'+'   '
     this_dist_code = '4'
     if strcompress(tab[ii].dist_label,/rem) eq 'TRGB' then $
        this_dist_code = '1'
     if strcompress(tab[ii].dist_label,/rem) eq 'Cepheid' then $
        this_dist_code = '2'
     if strcompress(tab[ii].dist_label,/rem) eq 'SBF' then $
        this_dist_code = '2'
     if strcompress(tab[ii].dist_label,/rem) eq 'TF' then $
        this_dist_code = '3'
     if strcompress(tab[ii].dist_label,/rem) eq 'Group' then $
        this_dist_code = '3'
     if tab[ii].dist_label eq 'TRGB' then $
        this_dist_code = '1'
     line += this_dist_code
     printf, lun, line

     line = ''
     line += strcompress(tab[ii].name,/rem)+'   '
     line += 'ref_dist'+'   '
     line += tab[ii].dist_ref
     printf, lun, line

     printf, lun, '#'

  endfor

  close, lun
  
  spawn, 'cat '+outfile

  stop
  
end
