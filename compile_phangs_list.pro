pro compile_phangs_list

  survey_dir = 'gal_data/'
  survey_list = $
     ['survey_phangsalma.txt' $
      , 'survey_phangshst.txt' $
      , 'survey_phangsmuse.txt' $
      , 'survey_phangsext.txt' $
      , 'survey_phangsnext.txt']
  n_list = n_elements(survey_list)

  outfile = 'gal_data/survey_phangs.txt'
  for ii = 0, n_list-1 do begin
     readcol, survey_dir+survey_list[ii], comment='#', format='A' $
              , these_gals
     if n_elements(gals) eq 0 then $
        gals = these_gals $
     else $
        gals = [gals, these_gals]
  endfor

  gals = gals[uniq(gals, sort(gals))]
  n_gals = n_elements(gals)
  openw, 1, outfile
  printf, 1, '# This is a procedurally generated list of all PHANGS targets of interest.'
  printf, 1, '# It is suggested not to edit.'
  for ii = 0, n_gals-1 do $
     printf, 1, strupcase(gals[ii])
  close, 1
  
  spawn, 'cat '+outfile
      
  

end
