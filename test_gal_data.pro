pro test_gal_data
  
;+
;
; Test the galaxy data program by calling it for each galaxy.
;
;-

  readcol, "gal_data/survey_list.txt", comment="#", format="A,A" $
           , name, survey
  ind = where(survey eq 'THINGS', ct)
  test = gal_data(name[ind])

  STOP

end
