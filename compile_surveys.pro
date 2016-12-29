pro compile_surveys

; Make one column files in gal_data/ following the convention
; survey_SURVEYNAME.txt. These are aggregated into semicolon delimited
; tags in the galbase. So please don't use semicolons. This is
; just a long hacky script. The output is used in the more formal
; programs.

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; ULTRAVIOLET
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; GALEX NGS
  
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; OPTICAL
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; ATLAS 3D
  readcol, 'gal_data/atlas3d_release.txt', comment='#', format='A' $
           , atlas3d_name
  atlas3d_name = strupcase(strcompress(atlas3d_name,/rem))
  atlas3d_name = atlas3d_name[sort(atlas3d_name)]
  atlas3d_name = atlas3d_name[uniq(atlas3d_name)]

  openw,1, 'gal_data/survey_atlas3d.txt'
  for ii = 0, n_elements(atlas3d_name)-1 do $
     printf,1,atlas3d_name[ii]
  close,1

; CALIFA DR3  
  readcol, 'gal_data/califa_dr3_release.txt', comment='#', format='A' $
           , califa_name
  califa_name = strupcase(strcompress(califa_name,/rem))
  califa_name = califa_name[sort(califa_name)]
  califa_name = califa_name[uniq(califa_name)]

  openw,1, 'gal_data/survey_califa.txt'
  for ii = 0, n_elements(califa_name)-1 do $
     printf,1,califa_name[ii]
  close,1

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; NEAR-IR SURVEYS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; S4G
  readcol, 'gal_data/s4g_release.txt' $
           , comment='#', format='A', s4g_name
  s4g_name = strupcase(strcompress(s4g_name,/rem))
  s4g_name = s4g_name[sort(s4g_name)]
  s4g_name = s4g_name[uniq(s4g_name)]
  
  openw,1, 'gal_data/survey_s4g.txt'
  for ii = 0, n_elements(s4g_name)-1 do $
     printf,1,s4g_name[ii]
  close,1

; 2MASS LGA
  readcol, 'gal_data/lga2mass_release.txt' $
           , comment='#', format='A', lga_name
  lga_name = strupcase(strcompress(lga_name,/rem))
  lga_name = lga_name[sort(lga_name)]
  lga_name = lga_name[uniq(lga_name)]
  
  openw,1, 'gal_data/survey_lga2mass.txt'
  for ii = 0, n_elements(lga_name)-1 do $
     printf,1,lga_name[ii]
  close,1

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FAR-IR SURVEYS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; SINGS
  readcol, 'gal_data/singsir_release.txt' $
           , comment='#', format='A', sings_name
  sings_name = strupcase(strcompress(sings_name,/rem))
  sings_name = sings_name[sort(sings_name)]
  sings_name = sings_name[uniq(sings_name)]
  
  openw,1, 'gal_data/survey_sings.txt'
  for ii = 0, n_elements(sings_name)-1 do $
     printf,1,sings_name[ii]
  close,1

; KINGFISH

; BENDO SPITZER

; OTHER HERSCHEL

; GOALS

; IRAS RBGS

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; CO SURVEYS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; CARMA ATLAS3D
  readcol, 'gal_data/carma_atlas3d_release.txt' $
           , comment='#', format='A', atlas3dcarma_name
  atlas3dcarma_name = strupcase(strcompress(atlas3dcarma_name,/rem))
  atlas3dcarma_name = atlas3dcarma_name[sort(atlas3dcarma_name)]
  atlas3dcarma_name = atlas3dcarma_name[uniq(atlas3dcarma_name)]
  
  openw,1, 'gal_data/survey_atlas3dcarma.txt'
  for ii = 0, n_elements(atlas3dcarma_name)-1 do $
     printf,1,atlas3dcarma_name[ii]
  close,1

; JCMT NGLS
  readcol, 'gal_data/ngls_release.txt' $
           , comment='#', format='A', jcmtngls_name
  jcmtngls_name = strupcase(strcompress(jcmtngls_name,/rem))
  jcmtngls_name = jcmtngls_name[sort(jcmtngls_name)]
  jcmtngls_name = jcmtngls_name[uniq(jcmtngls_name)]
  
  openw,1, 'gal_data/survey_jcmtngls.txt'
  for ii = 0, n_elements(jcmtngls_name)-1 do $
     printf,1,jcmtngls_name[ii]
  close,1

; NRO GALAXY ATLAS
  readcol, 'gal_data/nroatlas_release.txt' $
           , comment='#', format='A', nroatlas_name
  nroatlas_name = strupcase(strcompress(nroatlas_name,/rem))
  nroatlas_name = nroatlas_name[sort(nroatlas_name)]
  nroatlas_name = nroatlas_name[uniq(nroatlas_name)]
  
  openw,1, 'gal_data/survey_nroatlas.txt'
  for ii = 0, n_elements(nroatlas_name)-1 do $
     printf,1,nroatlas_name[ii]
  close,1

; BIMA SONG
  readcol, 'gal_data/bima_song_release.txt' $
           , comment='#', format='A', bimasong_name
  bimasong_name = strupcase(strcompress(bimasong_name,/rem))
  bimasong_name = bimasong_name[sort(bimasong_name)]
  bimasong_name = bimasong_name[uniq(bimasong_name)]
  
  openw,1, 'gal_data/survey_bimasong.txt'
  for ii = 0, n_elements(bimasong_name)-1 do $
     printf,1,bimasong_name[ii]
  close,1

; HERACLES
  readcol, 'gal_data/heracles_release.txt' $
           , comment='#', format='A', heracles_name
  heracles_name = strupcase(strcompress(heracles_name,/rem))
  heracles_name = heracles_name[sort(heracles_name)]
  heracles_name = heracles_name[uniq(heracles_name)]
  
  openw,1, 'gal_data/survey_heracles.txt'
  for ii = 0, n_elements(heracles_name)-1 do $
     printf,1,heracles_name[ii]
  close,1

; EXTENDED HERA

; COLDGASS

; FCRAO

; ALLSMOG

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; HI SURVEYS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; THINGS

; WHISP

end
