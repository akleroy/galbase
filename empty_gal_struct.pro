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
          , distmod: nan $
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
;         STAR FORMATION RATE INDICATORS
;         ... IRAS BASED FIR
          , leda_mfir: nan $    
          , leda_lfir: nan $
          , rgbs_lir_40_400: nan $
          , rgbs_lir_8_1000: nan $
;         ... HALPHA
;         IN ERG/S/CM^2
          , logha: nan $
          , elogha: nan $
          , hasource: 'NONE' $
          , b15_logha: nan $
          , b15_elogha: nan $
          , e08_logha: nan $
          , e08_elogha: nan $
          , k04_logha: nan $
          , k04_elogha: nan $
          , k08_logha: nan $
          , k08_elogha: nan $
          , k09_logha: nan $
          , k09_elogha: nan $
          , lvg_logha: nan $
          , lvg_elogha: nan $
          , meu06_logha: nan $
          , meu06_elogha: nan $
          , mk06_logha: nan $
          , mk06_elogha: nan $
          , sg12_logha: nan $
          , sg12_elogha: nan $
;         ... UNWISE AND GALEX PHOTOMETRY
;         IN JANSKIES
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
;         ... STAR FORMATION RELATED LUMINOSITIES
          , lum_ha: nan $
          , lum_fuv: nan $
          , lum_nuv: nan $
          , lum_w1: nan $
          , lum_w2: nan $
          , lum_w3: nan $
          , lum_w4: nan $
          , lum_tir: nan $
          , tirsource: '' $
;         ... STAR FORMATION RATE ESTIMATES
          , sfr_ha_ke12: nan $
          , sfr_fuv_ke12: nan $
          , sfr_nuv_ke12: nan $
          , sfr_tir_ke12: nan $
          , sfr_w3_j13: nan $
          , sfr_w4_j13: nan $
          , sfr_xcg: nan $
          , sfr_fuvw4_ke12: nan $
          , sfr_fuvtir_ke12: nan $
          , sfr_nuvtir_ke12: nan $
          , sfr_haw4_ke12: nan $
          , sfr_hatir_ke12: nan $
;         STARLIGHT
;         ... LEDA MAGNITUDES
          , babs_mag: nan $
          , btc_mag: nan $
          , ref_btc: 'LEDA' $
          , uabs_mag: nan $
          , ubtc_mag: nan $
          , ref_ubtc: 'LEDA' $
          , iabs_mag: nan $
          , itc_mag: nan $
          , ref_itc: 'LEDA' $
          , bvtc_mag: nan $
          , ref_bvtc: 'LEDA' $
;         ... S4G CATALOG VALUES
          , s4g_i3p6_mag: nan $
          , s4g_i4p5_mag: nan $
;         ... STELLAR MASS
          , s4g_mstar: nan $         
          , s4g_mass_code: -1 $
          , z0mgs_mstar: nan $
          , e_z0mgs_mstar: nan $
;         GAS MASS
          , leda_m21cm: nan $       
          , leda_mhi: nan $
          }

  return, empty


end
