function empty_gal_struct
  
; INITIALIZE NOT-A-NUMBER
  nan = !values.d_nan

; EMPTY MEASUREMENT STRUCTURE
  empty = { $
;         NAMES
          name:'' $
          , pgc: 0L $
          , alias:'' $
;         DISTANCE AND RECESSIONAL VELOCITY
          , dist_mpc: nan $
          , e_dist: nan $
          , ref_dist: 'LEDA' $
          , vhel_kms: nan $
          , e_vhel_kms: nan $
          , ref_vhel: 'LEDA' $
          , vrad_kms: nan $
          , e_vrad_kms: nan $
          , ref_vrad: 'LEDA' $
          , vvir_kms: nan $
          , e_vvir_kms: nan $
          , ref_vvir: 'LEDA' $
;         POSITION
          , ra_deg: nan $
          , dec_deg: nan $
          , ref_pos: 'LEDA' $
;         ORIENTATION
          , posang_deg: nan $
          , e_posang: nan $
          , ref_posang: 'LEDA' $
          , incl_deg: nan $
          , e_incl: nan $
          , ref_incl: 'LEDA' $
          , log_raxis: nan $
          , e_log_raxis: nan $
          , ref_log_raxis: 'LEDA' $
;         MORPHOLOGY
          , t: nan $     
          , e_t: nan $     
          , ref_t: 'LEDA' $
          , morph: '' $
          , bar: 0B $
          , ring: 0B $
          , multiple: 0B $
          , ref_morph: 'LEDA' $
;         EXTINCTION
          , ext_b: nan $
          , ext_bmv_sfd98: nan $
          , ext_bmv_sf11: nan $
;         SIZES AND ROTATION CURVE
          , r25_deg: nan $
          , e_r25_deg: nan $
          , ref_r25: 'LEDA' $
          , vmaxg_kms: nan $
          , e_vmaxg_kms: nan $
          , ref_vmaxg: 'LEDA' $
          , vrot_kms: nan $
          , e_vrot_kms: nan $
          , ref_vrot: 'LEDA' $
;         PHOTOMETRY
          , hi_msun: nan $
          , ref_hi: 'LEDA' $
          , lfir_lsun: nan $
          , ref_ir: 'LEDA' $
          , btc_mag: nan $
          , ref_btc: 'LEDA' $
          , ubtc_mag: nan $
          , ref_ubtc: 'LEDA' $
          , bvtc_mag: nan $
          , ref_bvtc: 'LEDA' $
          , itc_mag: nan $
          , ref_itc: 'LEDA' $
          }

; ADD LATER
;          , lstar_kpc: nan $
;          , l3p6_as: nan $
;          , vrot_kms: nan $
;          , vrot_r25: nan $
;          , vflat_kms: nan $
;          , lflat_kpc: nan $  
  return, empty


end
