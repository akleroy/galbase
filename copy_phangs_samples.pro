pro copy_phangs_samples

; these are kept elsewhere

  in_dir = '~/projects/phangs_survey_2019/code/data_files/'
  out_dir = '~/idl/galbase/gal_data/'
  
  list_to_copy = $
     ['survey_phangsalma.txt' $
      , 'survey_phangsastrosat.txt' $
      , 'survey_phangsext.txt' $
      , 'survey_phangshalpha.txt' $
      , 'survey_phangsherschel.txt' $
      , 'survey_phangshi.txt' $
      , 'survey_phangshst.txt' $
      , 'survey_phangsirac.txt' $
      , 'survey_phangsmuse.txt' $
      , 'survey_phangsnext.txt' $
      , 'survey_phangs.txt']

  for ii = 0, n_elements(list_to_copy)-1 do begin

     this_file = list_to_copy[ii]
     command = 'cp '+in_dir+this_file+' '+out_dir+this_file
     spawn, command
     
  endfor

end
