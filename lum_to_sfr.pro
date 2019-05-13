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
     ['FUV','NUV','HA','TIR','MIPS24','MIPS70','PACS70','WISE3','WISE4','1.4GHz','XRAY' $
      ,'WISE4+FUV','WISE4+NUV','WISE3+FUV','WISE3+NUV']

  if total(strupcase(band) eq valid_bands) eq 0 then begin
     message, 'Not a valid band choice.', /info
     return, !values.f_nan
  endif
  
  if n_elements(cal) eq 0 then cal = 'KE12'

  coef = !values.f_nan

  if band eq 'FUV' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*43.35d)
     if cal eq 'S07' then coef = 10.^(-1.*28.165d)*1.d/(1.9341449d+15) ; -43.45
     if cal eq 'Z19' then coef = 10.^(-43.42d)
  endif

  if band eq 'NUV' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*43.17d)
     if cal eq 'S07' then coef = 10.^(-1.*28.165d)*1.d/(1.3034455d+15) ; -43.28
     if cal eq 'Z19' then coef = 10.^(-43.24)
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
     if cal eq 'Z19' then coef = 10.d^(-42.67)
  endif

  if band eq 'WISE3+NUV' then begin
     if cal eq 'Z19' then coef = 10.d^(-42.86)
  endif

  if band eq 'WISE3+FUV' then begin
     if cal eq 'Z19' then coef = 10.d^(-42.79)
  endif

  if band eq 'WISE4' then begin
     if cal eq 'KE12' then coef = 10.^(-1.*42.69d)*22./24.
     if cal eq 'J13' then coef = 7.50d-10*1./3.839d33 ; -42.7
     if cal eq 'Z19' then coef = 10.d^(-42.55)
  endif

  if band eq 'WISE4+NUV' then begin
     if cal eq 'KE12' then coef = 10.d^(-42.81)*22./25.
     if cal eq 'Z19' then coef = 10.d^(-42.75)
  endif

  if band eq 'WISE4+FUV' then begin
     if cal eq 'KE12' then coef = 10.d^(-42.76)*22./25.
     if cal eq 'Z19' then coef = 10.d^(-42.68)
  endif

  if finite(coef) eq 0 then begin
     message, 'Calibration not recognized.', /info
  endif

  return, double(lum_ergs)*double(coef)
     
end


   
