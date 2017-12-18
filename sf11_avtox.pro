function sf11_avtox $
   , av $
   , band

; I pulled the band ratios, which should be fixed from the NED entry
; for NGC6946. Added GALEX by hand, it's not in the nominal SF11 list.

  fid_av = 0.938 
  band_to_av = !values.f_nan
  
  band = strupcase(band)
  if band eq 'LANDOLTU' then $
     band_to_av = 1.483/fid_av
  if band eq 'LANDOLTB' then $
     band_to_av = 1.241/fid_av
  if band eq 'LANDOLTV' then $
     band_to_av = 0.938/fid_av
  if band eq 'LANDOLTR' then $
     band_to_av = 0.742/fid_av
  if band eq 'LANDOLTI' then $
     band_to_av = 0.515/fid_av

  if band eq 'CTIOU' then $
     band_to_av = 1.405/fid_av
  if band eq 'CTIOB' then $
     band_to_av = 1.246/fid_av
  if band eq 'CTIOV' then $
     band_to_av = 0.918/fid_av
  if band eq 'CTIOR' then $
     band_to_av = 0.725/fid_av
  if band eq 'CTIOI' then $
     band_to_av = 0.519/fid_av

  if band eq 'UKIRTJ' then $
     band_to_av = 0.243/fid_av
  if band eq 'UKIRTH' then $
     band_to_av = 0.154/fid_av
  if band eq 'UKIRTK' then $
     band_to_av = 0.103/fid_av
  if band eq 'UKIRTL' then $
     band_to_av = 0.052/fid_av

  if band eq 'GUNNG' then $
     band_to_av = 0.997/fid_av
  if band eq 'GUNNR' then $
     band_to_av = 0.703/fid_av
  if band eq 'GUNNI' then $
     band_to_av = 0.532/fid_av
  if band eq 'GUNNZ' then $
     band_to_av = 0.422/fid_av

  if band eq 'SPINRADR_S' then $
     band_to_av = 0.657/fid_av

  if band eq 'STROMGRENU' then $
     band_to_av = 1.473/fid_av
  if band eq 'STROMGRENB' then $
     band_to_av = 1.146/fid_av
  if band eq 'STROMGRENV' then $
     band_to_av = 1.298/fid_av
  if band eq 'STROMGRENBETA' then $
     band_to_av = 1.089/fid_av
  if band eq 'STROMGRENY' then $
     band_to_av = 0.919/fid_av

  if band eq 'SDSSU' then $
     band_to_av = 1.451/fid_av
  if band eq 'SDSSG' then $
     band_to_av = 1.130/fid_av
  if band eq 'SDSSR' then $
     band_to_av = 0.782/fid_av
  if band eq 'SDSSI' then $
     band_to_av = 0.581/fid_av
  if band eq 'SDSSZ' then $
     band_to_av = 0.432/fid_av

  if band eq 'DSS-IIG' then $
     band_to_av = 1.157/fid_av
  if band eq 'DSS-IIR' then $
     band_to_av = 0.715/fid_av
  if band eq 'DSS-III' then $
     band_to_av = 0.509/fid_av

  if band eq 'PS1G' then $
     band_to_av = 1.085/fid_av
  if band eq 'PS1R' then $
     band_to_av = 0.777/fid_av
  if band eq 'PS1I' then $
     band_to_av = 0.576/fid_av
  if band eq 'PS1Z' then $
     band_to_av = 0.452/fid_av
  if band eq 'PS1Y' then $
     band_to_av = 0.372/fid_av
  if band eq 'PS1W' then $
     band_to_av = 0.801/fid_av

  if band eq 'LSSTU' then $
     band_to_av = 1.418/fid_av
  if band eq 'LSSTG' then $
     band_to_av = 1.108/fid_av
  if band eq 'LSSTR' then $
     band_to_av = 0.778/fid_av
  if band eq 'LSSTI' then $
     band_to_av = 0.576/fid_av
  if band eq 'LSSTZ' then $
     band_to_av = 0.453/fid_av
  if band eq 'LSSTY' then $
     band_to_av = 0.372/fid_av

  if band eq 'WFPC2F300W' then $
     band_to_av = 1.678/fid_av
  if band eq 'WFPC2F450W' then $
     band_to_av = 1.167/fid_av
  if band eq 'WFPC2F555W' then $
     band_to_av = 0.943/fid_av
  if band eq 'WFPC2F606W' then $
     band_to_av = 0.826/fid_av
  if band eq 'WFPC2F702W' then $
     band_to_av = 0.667/fid_av
  if band eq 'WFPC2F814W' then $
     band_to_av = 0.530/fid_av
  if band eq 'WFC3F105W' then $
     band_to_av = 0.332/fid_av
  if band eq 'WFC3F110W' then $
     band_to_av = 0.301/fid_av
  if band eq 'WFC3F125W' then $
     band_to_av = 0.248/fid_av
  if band eq 'WFC3F140W' then $
     band_to_av = 0.210/fid_av
  if band eq 'WFC3F160W' then $
     band_to_av = 0.175/fid_av
  if band eq 'WFC3F200LP' then $
     band_to_av = 1.012/fid_av
  if band eq 'WFC3F218W' then $
     band_to_av = 2.656/fid_av
  if band eq 'WFC3F225W' then $
     band_to_av = 2.392/fid_av
  if band eq 'WFC3F275W' then $
     band_to_av = 1.878/fid_av
  if band eq 'WFC3F300X' then $
     band_to_av = 1.789/fid_av
  if band eq 'WFC3F336W' then $
     band_to_av = 1.524/fid_av
  if band eq 'WFC3F350LP' then $
     band_to_av = 0.898/fid_av
  if band eq 'WFC3F390W' then $
     band_to_av = 1.333/fid_av
  if band eq 'WFC3F438W' then $
     band_to_av = 1.240/fid_av
  if band eq 'WFC3F475W' then $
     band_to_av = 1.112/fid_av
  if band eq 'WFC3F475X' then $
     band_to_av = 1.066/fid_av
  if band eq 'WFC3F555W' then $
     band_to_av = 0.977/fid_av
  if band eq 'WFC3F600LP' then $
     band_to_av = 0.609/fid_av
  if band eq 'WFC3F606W' then $
     band_to_av = 0.851/fid_av
  if band eq 'WFC3F625W' then $
     band_to_av = 0.773/fid_av
  if band eq 'WFC3F775W' then $
     band_to_av = 0.562/fid_av
  if band eq 'WFC3F814W' then $
     band_to_av = 0.526/fid_av
  if band eq 'WFC3F850LP' then $
     band_to_av = 0.413/fid_av

  if band eq 'ACSCLEAR' then $
     band_to_av = 0.834/fid_av
  if band eq 'ACSF435W' then $
     band_to_av = 1.235/fid_av
  if band eq 'ACSF475W' then $
     band_to_av = 1.118/fid_av
  if band eq 'ACSF550W' then $
     band_to_av = 0.897/fid_av
  if band eq 'ACSF555W' then $
     band_to_av = 0.955/fid_av
  if band eq 'ACSF606W' then $
     band_to_av = 0.846/fid_av
  if band eq 'ACSF625W' then $
     band_to_av = 0.759/fid_av
  if band eq 'ACSF775W' then $
     band_to_av = 0.557/fid_av
  if band eq 'ACSF814W' then $
     band_to_av = 0.522/fid_av
  if band eq 'ACSF850LPW' then $
     band_to_av = 0.425/fid_av

  if band eq 'DESG' then $
     band_to_av = 1.108/fid_av
  if band eq 'DESR' then $
     band_to_av = 0.745/fid_av
  if band eq 'DESI' then $
     band_to_av = 0.546/fid_av
  if band eq 'DESZ' then $
     band_to_av = 0.416/fid_av
  if band eq 'DESY' then $
     band_to_av = 0.362/fid_av

; GALEX

; ... FOLLOW THE PEEK & SCHIMINOVICH PRESCRIPTION BUT CAP E(B-V) AT
; 0.2, WHICH SEEMS TO BE THE UPPER END OF THEIR FIT

  if band eq 'GALEXFUV' then begin
     ebv = (av/3.1) < 0.2
     peek_afuv = 10.47*ebv+8.59*ebv^2-82.8*ebv^3.
     afuv = peek_afuv
     band_to_av = afuv/av
  endif

  if band eq 'GALEXNUV' then begin
     ebv = (av/3.1) < 0.2
     peek_anuv = 8.36*ebv+14.3*ebv^2-82.8*ebv^3.
     anuv = peek_anuv
     band_to_av = anuv/av     
  endif

; ... YUAN ET AL EMPIRICAL VALUES

  if band eq 'GALEXFUVYUAN' then $
     band_to_av = 4.89 / (3.1)
  if band eq 'GALEXNUVYUAN' then $
     band_to_av = 7.24 / (3.1)

; ... PREVIOUS THINGS WORK USED SEIBERT

  if band eq 'GALEXFUVSEIBERT' then $
     band_to_av = 8.29 / (3.1)
  if band eq 'GALEXNUVSEIBERT' then $
     band_to_av = 8.18 / (3.1)

; ... WISE AND 2MASS USE YUAN ET AL. 2013

  if band eq '2MASSJ' then $
     band_to_av = 0.72/3.1

  if band eq '2MASSH' then $
     band_to_av = 0.46/3.1

  if band eq '2MASSKS' then $
     band_to_av = 0.306/3.1

  if band eq 'WISE1' then $
     band_to_av = 0.18/3.1

  if band eq 'WISE2' then $
     band_to_av = 0.16/3.1

; CALCULATE

  return, av*band_to_av

end
