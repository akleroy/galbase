function empty_gal_struct

; INITIALIZE NOT-A-NUMBER
  nan = !values.d_nan

; EMPTY MEASUREMENT STRUCTURE
  empty = { $
          pgc: 0L $
          , objname: '' $
          , pgcname: '' $
          , tags: '' $
;         DISTANCES
          , dist_mpc: nan $
          , e_dist_dex: nan $
          , dist_code: -1 $
          , distmod: nan $
          , e_distmod: nan $
          , ref_dist: 'LEDA' $
;         RECESSIONAL VELOCITY
          , vhel_kms: nan $
          , e_vhel: nan $
          , ref_vhel: 'LEDA' $
          , vvir_kms: nan $
          , e_vvir: nan $
          , ref_vvir: 'LEDA' $
;         POSITION ON SKY
          , ra_deg: nan $
          , dec_deg: nan $
          , gl_deg: nan $
          , gb_deg: nan $
          , ref_pos: 'LEDA' $            
;         ORIENTATION AND SIZE
          , posang_deg: nan $
          , e_posang: nan $
          , ref_posang: 'LEDA' $
          , incl_deg: nan $
          , e_incl: nan $
          , ref_incl: 'LEDA' $
          , logaxisratio: nan $
          , e_logaxisratio: nan $
          , ref_logaxisratio: 'LEDA' $
          , r25_deg: nan $
          , e_r25: nan $
          , ref_r25: 'LEDA' $
          , reff_deg: nan $
          , e_reff: nan $ 
          , ref_reff: 'NONE' $ 
;         APPARENT MAGNITUDES FROM LEDA
          , ut: nan $
          , e_ut: nan $
          , bt: nan $
          , e_bt: nan $
          , btc: nan $
          , vt: nan $
          , e_vt: nan $
          , it: nan $
          , e_it: nan $
          , kt: nan $
          , e_kt: nan $
;         MORPHOLOGY
          , t: nan $     
          , e_t: nan $     
          , ref_t: 'LEDA' $
          , morph: '' $
          , bar: '' $
          , ref_morph: 'LEDA' $
;         ROTATION AND LINE WIDTH
          , vrot_kms: nan $
          , e_vrot: nan $
          , ref_vrot: 'LEDA' $
          , vmaxg_kms: nan $
          , e_vmaxg: nan $
          , ref_vmaxg: 'LEDA' $            
;         EXTINCTION
          , av_sfd98: nan $
;         INTEGRATED PROPERTIES
          , logsfr: nan $
          , e_logsfr: nan $
          , ref_logsfr: 'NONE' $
          , logmstar: nan $
          , e_logmstar: nan $
          , ref_logmstar: 'NONE' $
          , logmhi: nan $
          , e_logmhi: nan $
          , ref_logmhi: 'LEDA' $
          , logmmol: nan $
          , e_logmmol: nan $
          , ref_logmmol: 'NONE' $
          , metals: nan $
          , e_metals: nan $
          , ref_metals: 'NONE' $
          }

  return, empty

end
