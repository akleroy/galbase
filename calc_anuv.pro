function calc_anuv $
   , ebv
;+
;
; Calculate the extinction at the NUV band given E(B-V) from
; SFD98. Uses Peek & Schiminovich '13 and then CCM at high E(B-V). 
;
;-

  thresh = 0.251

  anuv = $
     (8.36*(ebv < thresh) $
      + 14.3*(ebv < thresh)^2 $
      - 82.8*(ebv < thresh)^3)

  return, anuv

end
