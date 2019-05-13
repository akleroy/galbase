function calc_afuv $
   , ebv
;+
;
; Calculate the extinction at the FUV band given E(B-V) from
; SFD98. Uses Peek & Schiminovich '13 and then CCM at high E(B-V). 
;
;-

  thresh = 0.2

  rfuv = $
     (10.47 $
      + 8.59*(ebv < thresh) $
      - 82.8*(ebv < thresh)^2)

  afuv = rfuv*ebv

  return, afuv

end
