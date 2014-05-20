function empty_gal_struct
  
; INITIALIZE NOT-A-NUMBER
  nan = !values.f_nan

  s = { $
      name:'' $
      , dist_mpc: nan $
      , e_dist: nan $
      , ra_deg: nan $
      , dec_deg: nan $
      , d25_am: nan $
      , e_logd25: nan $
      , r25_deg: nan $
      , e_logr25: nan $
      , t: nan $     
      , e_t: nan $     
      , posang_deg: nan $
      , e_posang: nan $
      , incl_deg: nan $
      , e_incl: nan $
      , bar: 0B $
      , ring: 0B $
      , lstar_kpc: nan $
      , l3p6_as: nan $
      , vhel_kms: nan $
      , vrot_kms: nan $
      , vrot_r25: nan $
      , vflat_kms: nan $
      , lflat_kpc: nan $
      , hi_vhel_kms: nan $
      , hi_vrot_kms: nan $
      , e_bmv: nan $
      , b_mag: nan $
      , bmv_eff: nan $
      , vdisp_kms: nan $
      , logoh: nan $
      }

return, s
  
end
