function calc_afuv $
   , ebv
;+
;
; Calculate the extinction at the FUV band given E(B-V) from
; SFD98. Uses Peek & Schiminovich '13 and then CCM at high E(B-V). 
;
;-

  thresh = 0.266

  afuv = $
     (10.47*(ebv < thresh) $
      + 8.59*(ebv < thresh)^2 $
      - 82.8*(ebv < thresh)^3)

  return, afuv

end
