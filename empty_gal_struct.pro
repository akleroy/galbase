function empty_gal_struct
  
; INITIALIZE NOT-A-NUMBER
  nan = !values.d_nan

; EMPTY MEASUREMENT STRUCTURE
  empty = { $
;         NAMES
          name:'' $
          , pgc: 0L $
          , pgcname:'' $
          , alias:'' $
;         SURVEY MEMBERSHIP
          , tags:'' $
;         DISTANCES
          , dist_mpc: nan $
          , e_dist: nan $
          , ref_dist: 'LEDA' $
          , leda_vdist_mpc: nan $
          , e_leda_vdist: nan $
          , leda_dist_mpc: nan $
          , e_leda_dist: nan $
          , edd_dist_mpc: nan $
          , e_edd_dist: nan $
          , edd_code: -1L $
          , cf_dist_mpc: nan $
          , e_cf_dist: nan $
          , cf_grp_dist: nan $
          , ned_dist_mpc: nan $
          , e_ned_dist: nan $
          , s4g_dist_mpc: nan $
;         RECESSIONAL VELOCITY
          , vhel_kms: nan $
          , e_vhel_kms: nan $
          , ref_vhel: 'LEDA' $
          , vrad_kms: nan $
          , e_vrad_kms: nan $
          , ref_vrad: 'LEDA' $
          , vvir_kms: nan $
          , e_vvir_kms: nan $
          , ref_vvir: 'LEDA' $
;         CENTER ON SKY
          , ra_deg: nan $
          , dec_deg: nan $
          , ref_pos: 'LEDA' $
;         POSITION ANGLE
          , posang_deg: nan $
          , e_posang: nan $
          , ref_posang: 'LEDA' $
          , s4g_pa: nan $
;         INCLINATION AND AXIS RATIO
          , incl_deg: nan $
          , e_incl: nan $
          , ref_incl: 'LEDA' $
          , s4g_incl: nan $
          , s4g_ellip: nan $
          , leda_incl: nan $
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
          , av_sf11: nan $
;         SIZES
          , reff_deg: nan $
          , e_reff_deg: nan $
          , r25_deg: nan $
          , e_r25_deg: nan $
          , ref_r25: 'LEDA' $
          , s4g_semimaj: nan $                   
;         ROTATION AND LINE WIDTH
          , vmaxg_kms: nan $
          , e_vmaxg_kms: nan $
          , ref_vmaxg: 'LEDA' $
          , vrot_kms: nan $
          , e_vrot_kms: nan $
          , ref_vrot: 'LEDA' $
;         STELLAR MASS
          , s4g_mstar: nan $         
          , s4g_mass_code: -1 $
          , z0mgs_mstar: nan $
          , e_z0mgs_mstar: nan $
;         STAR FORMATION RATE INDICATORS
          , leda_mfir: nan $    
          , leda_lfir: nan $
          , rgbs_lir_40_400: nan $
          , rgbs_lir_8_1000: nan $
;         GAS MASS
          , leda_m21cm: nan $       
          , leda_mhi: nan $
;         PHOTOMETRY
          , z0mgs_w1: nan $
          , z0mgs_ew1: nan $
          , z0mgs_w2: nan $
          , z0mgs_ew2: nan $
          , z0mgs_w3: nan $
          , z0mgs_ew3: nan $
          , z0mgs_w4: nan $
          , z0mgs_ew4: nan $
          , z0mgs_fuv: nan $
          , z0mgs_efuv: nan $
          , z0mgs_nuv: nan $
          , z0mgs_enuv: nan $
          , btc_mag: nan $
          , ref_btc: 'LEDA' $
          , ubtc_mag: nan $
          , ref_ubtc: 'LEDA' $
          , bvtc_mag: nan $
          , ref_bvtc: 'LEDA' $
          , itc_mag: nan $
          , ref_itc: 'LEDA' $
          , s4g_i3p6_mag: nan $
          , s4g_i4p5_mag: nan $
          }

  return, empty


end
