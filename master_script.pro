pro master_script

;+
;
; This script steps through the construction of the galaxy database.
;
;-

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PRE CALCULATION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Compile the text files that will hold survey names
  compile_surveys

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; QUERY LEDA AND CONSTRUCT FITS FILES HOLDING HYPERLEDA DATA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; Build leda queries, feed them into leda, and then process these into
; FITS files. The output of this stage is a FITS file.

; ... the general query
  make_leda_fits, /print_query
  make_leda_fits, /print_query, for_sample='gal_data/survey_atlas3d.txt'
  make_leda_fits, /print_query, for_sample='gal_data/survey_califa.txt'
  make_leda_fits, /print_query, for_sample='gal_data/survey_lga2mass.txt'
  make_leda_fits, /print_query, for_sample='gal_data/survey_sings.txt'
  make_leda_fits, /print_query, for_sample='gal_data/survey_s4g.txt'
;  make_leda_fits, /print_query, for_sample='gal_data/survey_atlas3dcarma.txt'
;  make_leda_fits, /print_query, for_sample='gal_data/survey_bimasong.txt'
;  make_leda_fits, /print_query, for_sample='gal_data/survey_heracles.txt'
;  make_leda_fits, /print_query, for_sample='gal_data/survey_jcmtngls.txt'
;  make_leda_fits, /print_query, for_sample='gal_data/survey_nroatlas.txt'
  
; Now feed these into LEDA by hand, sorry. Set the not-found string to
; NaN and the delimeter to '|'

; ... now process those data into FITS
  make_leda_fits, /parse_query
  make_leda_fits, /parse_query, for_sample='gal_data/leda_atlas3d.txt'
  make_leda_fits, /parse_query, for_sample='gal_data/leda_califa.txt'
  make_leda_fits, /parse_query, for_sample='gal_data/leda_lga2mass.txt'
  make_leda_fits, /parse_query, for_sample='gal_data/leda_sings.txt'
  make_leda_fits, /parse_query, for_sample='gal_data/leda_s4g.txt'
;  make_leda_fits, /parse_query, for_sample='gal_data/leda_atlas3dcarma.txt'
;  make_leda_fits, /parse_query, for_sample='gal_data/leda_bimasong.txt'
;  make_leda_fits, /parse_query, for_sample='gal_data/leda_heracles.txt'
;  make_leda_fits, /parse_query, for_sample='gal_data/leda_jcmtngls.txt'
;  make_leda_fits, /parse_query, for_sample='gal_data/leda_nroatlas.txt'
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; GET DISTANCES FROM NED
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; Query NED to build up a database of distances and uncertainties for
; our supersample.
  

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; BUILD THE GALAXY DATABASE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  make_gal_base

; You are done, enjoy!

end
