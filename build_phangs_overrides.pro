pro build_phangs_overrides

;
; Translate the Lang & Meidt orientations into an override file.
;

  infile = 'gal_data/LangMeidt_orientations_April16.txt'
  outfile = 'gal_data/override_phangs_orient.txt'

  readcol, infile $
           , comment='#', format='A,I,F,F,F,F,F' $
           , lm_gal, lm_code $
           , lm_incl, lm_posang, lm_vlsrk, lm_ra, lm_dec
  n_lm = n_elements(lm_gal)
  
  lm_e_incl = 5.0+0.0*lm_incl
  lm_e_posang = 5.0+0.0*lm_posang

  gals = gal_data(lm_gal)

  helio2lsr, lm_vhel_kms, lm_vlsrk $
             , ra = gals.ra_deg, dec = gals.dec_deg $
             , /reverse
  lm_e_vhel = 5.0+lm_vhel_kms*0.0

  get_lun, lun
  openw, lun, outfile

  printf, lun, '# This is a procedurally generated file. Editing not recommended.'
  printf, lun, '# Column 1: galaxy'
  printf, lun, '# Column 2: field'
  printf, lun, '# Column 3: value'

  for ii = 0, n_lm-1 do begin
     
     printf, lun, '#'

     line = ''
     line += lm_gal[ii]+'   '
     line += 'incl_deg'+'   '
     line += string(lm_incl[ii], format='(F5.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'e_incl'+'   '
     line += string(lm_e_incl[ii], format='(F5.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'ref_incl'+'   '
     line += 'LANGMEIDT19'
     printf, lun, line

     printf, lun, '#'

     line = ''
     line += lm_gal[ii]+'   '
     line += 'posang_deg'+'   '
     line += string(lm_posang[ii], format='(F5.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'e_posang'+'   '
     line += string(lm_e_posang[ii], format='(F5.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'ref_posang'+'   '
     line += 'LANGMEIDT19'
     printf, lun, line

     printf, lun, '#'

     line = ''
     line += lm_gal[ii]+'   '
     line += 'vhel_kms'+'   '
     line += string(lm_vhel_kms[ii], format='(F6.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'e_vhel'+'   '
     line += string(lm_e_vhel[ii], format='(F6.1)')
     printf, lun, line

     line = ''
     line += lm_gal[ii]+'   '
     line += 'ref_vhel'+'   '
     line += 'LANGMEIDT19'
     printf, lun, line

  endfor

  close, lun
  
  spawn, 'cat '+outfile

  stop
  
end
