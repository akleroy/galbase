pro make_distance_base $
   , data_dir = data_dir
  
  @constants.bat

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE THE STRUCTURE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; INITIALIZE NOT-A-NUMBER
  nan = !values.d_nan

; EMPTY DISTANCE STRUCTURE
  empty_struct = $
     { $
     pgc:0L $
;    RECESSIONAL VELOCITY
     , vhel_kms: nan $
     , ref_vhel: 'LEDA' $
     , vvir_kms: nan $
     , ref_vvir: 'LEDA' $
;    VARIOUS DISTANCE ESTIMATES
     , leda_bestdist_mpc: nan $
     , e_leda_bestdist: nan $
     , leda_dist0_mpc: nan $
     , e_leda_dist0: nan $
     , leda_vdist_mpc: nan $
     , e_leda_vdist: nan $
     , edd_dist_mpc: nan $
     , e_edd_dist: nan $
     , edd_code: -1L $
     , cf_dist_mpc: nan $
     , e_cf_dist: nan $
     , cf_grp_dist: nan $
     }
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ THE COMPARISON DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  readcol, 'gal_data/EDD_CF3_2017Sep28.txt', delim='|', comment='#' $
           , cf3_pgc, cf3_dist, cf3_ndist, cf3_dm, cf3_edm, cf3_dmgrp, cf3_edgmgrp $
           , format='L,F,L,F,F,F,F', /nan
  cf3_group_dist = 10.^(cf3_dmgrp/5.+1.)/1d6

  readcol, 'gal_data/EDD_EDD_2017Sep27.txt', comment='#', delim='|' $
           , edd_pgc, edd_dist, edd_edist, edd_source $
           , format='L,X,F,F,X,X,X,X,X,X,X,X,X,X,L', /nan

  pgc_to_keep = [edd_pgc, cf3_pgc]
  pgc_to_keep = pgc_to_keep[uniq(pgc_to_keep, sort(pgc_to_keep))]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PRUNE THE LEDA FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  data_dir = 'gal_data/'
  infile = data_dir + 'leda_database.fits'
  leda = mrdfits(infile, 1, hdr)
  n_leda = n_elements(leda)

  keep = bytarr(n_leda)
  for ii = 0, n_leda-1 do begin
     keep[ii] = total(leda[ii].pgc eq pgc_to_keep) ge 1     
  endfor
  keep_ind = where(keep, keep_ct)
  leda = leda[keep_ind]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; BUILD THE DISTANCE DATABASE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  n_gal = n_elements(leda)
  data = replicate(empty_struct, n_gal)

  for ii = 0, n_gal-1 do begin

     data[ii].pgc = leda[ii].pgc

     data[ii].vhel_kms = leda[ii].v
     data[ii].vvir_kms = leda[ii].vvir

     data[ii].leda_bestdist_mpc = $
        10.^(leda[ii].modbest/5.+1.)/1d6

     data[ii].e_leda_bestdist = $
        leda[ii].e_modbest/2.5

     data[ii].leda_dist0_mpc = $
        10.^(leda[ii].mod0/5.+1.)/1d6

     data[ii].e_leda_dist0 = $
        leda[ii].e_mod0/2.5

     data[ii].leda_vdist_mpc = $
        10.^(leda[ii].modz/5.+1.)/1d6

     data[ii].e_leda_vdist = $
        leda[ii].e_modz/2.5

     edd_ind = where(edd_pgc eq data[ii].pgc, edd_ct)
     if edd_ct eq 1 then begin
        data[ii].edd_dist_mpc = (edd_dist[edd_ind])[0]
        err = (edd_edist[edd_ind])[0]
        data[ii].e_edd_dist = err
        data[ii].edd_code = (edd_source[edd_ind])[0]
     endif

     cf3_ind = where(cf3_pgc eq data[ii].pgc, cf3_ct)
     if cf3_ct eq 1 then begin
        data[ii].cf_dist_mpc = (cf3_dist[cf3_ind])[0]
        data[ii].cf_grp_dist = (cf3_group_dist[cf3_ind])[0]
        err = (cf3_dist[cf3_ind]*(10.^(cf3_edm[cf3_ind]/5.)-1.d))[0]
        data[ii].e_cf_dist = err
     endif

  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
  outfile = "gal_data/dist_base.fits"
  mwrfits, data, outfile, hdr, /create

  stop
  
end
