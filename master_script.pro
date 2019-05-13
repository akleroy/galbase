pro master_script

;+
;
; This script steps through the construction of the entire galaxy
; database. Don't run it unless you intend to query across the
; web and rebuild things. Otherwise, just rerun the part you are
; interested in up through the make_gal_base.
;
; If you only want to RUN the programs, you can fetch from the web
; using fetch_gal_base.
;
;-

; Send a broad query to LEDA and save this to a text file.
  make_leda_core, /send

; Parse this into a FITS table
  make_leda_core, /parse

; Make a list of known aliases and save various helper files.
  make_alias_list

; Make a database of distances
  make_distance_base

; Compile survey membership helper files
  compile_surveys
  
; Make the galaxy database
  make_gal_base

; You are done, enjoy!

end
