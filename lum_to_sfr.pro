function lum_to_sfr $   
   , band=band $
   , cal=cal $
   , lum_ergs = lum_ergs
  
;+
;
; Single band SFR tracers.
;
;-

  valid_bands = $
     ['FUV','NUV','HA','TIR','MIPS24','MIPS70','PACS70','WISE3','WISE4','1.4GHz','XRAY']

  if total(strupcase(band) eq valid_bands) eq 0 then begin
     message, 'Not a valid band choice.', /info
     return, !values.f_nan
  endif
  
  if n_elements(cal) eq 0 then cal = 'KE12'

  coef = !values.f_nan

  if band eq 'FUV' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*43.35d)
     if cal eq 'S07' then coef = 10.^(-1.*28.165d)*1.d/(1.9341449d+15) ; -43.45
  endif

  if band eq 'NUV' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*43.17d)
     if cal eq 'S07' then coef = 10.^(-1.*28.165d)*1.d/(1.3034455d+15) ; -43.28
  endif

  if band eq 'HA' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*41.27d)
  endif

  if band eq 'TIR' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*43.41d)
  endif

  if band eq 'MIPS24' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*42.69d)
  endif


  if band eq 'WISE3' then begin     
     if cal eq 'J13'then coef = 4.91d-10*1./3.839d33 ; -42.9
  endif

  if band eq 'WISE4' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*42.69d)
     if cal eq 'J13' then coef = 7.50d-10*1./3.839d33 ; -42.7
  endif

  if finite(coef) eq 0 then begin
     message, 'Calibration not recognized.', /info
  endif

  return, double(lum_ergs)*double(coef)
     
end


   
