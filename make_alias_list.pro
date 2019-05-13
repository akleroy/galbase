pro make_alias_list $
   , data_dir = data_dir

  @constants.bat

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; INITIALIZE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  digit = ['0','1','2','3','4','5','6','7','8','9']

  data_dir = "gal_data/"

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; READ LEDA FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  tab = mrdfits(data_dir+'leda_database.fits', 1, hdr)
  n_entry = n_elements(tab)
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PARSE THE LEDA FILE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "Exploding LEDAs known aliases."
  print, ""
  
  alias_list = strarr(n_entry)

; START WITH THE ENTRIES THAT LEDA KNOWS

  for ii = 0L, n_entry-1 do begin

     counter, ii, n_entry, "LEDA master table entry "
     
     this_alias_list = ''
     this_name_list = strsplit(strcompress(tab[ii].hl_names,/rem), ',', /extract)
     for jj = 0, n_elements(this_name_list)-1 do begin
        this_alias_list += ';'+this_name_list[jj]
     endfor
     alias_list[ii] = this_alias_list
  endfor

  for ii = 0L, n_entry-1 do begin

     this_alias_list = alias_list[ii]
     this_name_list = strsplit(this_alias_list, ';', /extract)
     n_names = n_elements(this_name_list)
     
;    STRIP LEADING ZEROS FROM NGC, UGC, PGC, AND IC ENTRIES AND ADD THIS AS AN ALIAS

     for kk = 0, n_names-1 do begin

        this_name = this_name_list[kk]
        if (strpos(this_name, "NGC") eq 0) or $
           (strpos(this_name, "UGCA") eq 0) or $
           (strpos(this_name, "UGC") eq 0) or $         
           (strpos(this_name, "IC") eq 0) or $
           (strpos(this_name, "PGC") eq 0) or $
           (strpos(this_name, "MESSIER") eq 0) $
        then begin
           this_alias = ""
           leading_digit = 1B
           was_zero = 0B
           
           for zz = 0, strlen(this_name)-1 do begin
              token = strmid(this_name,zz,1)
              if total(token eq digit) eq 1 then begin
                 if leading_digit and token eq '0' then begin
                    was_zero = 1B
                    continue
                 endif
                 leading_digit = 0B
                 this_alias += token
              endif else begin
                 this_alias += token
              endelse
           endfor
           
           if was_zero and $
              (total(this_name_list eq this_alias) eq 0) then begin
              this_alias_list += ';'+this_alias
           endif
           
        endif
        
     endfor

;    HANDLE THE MESSIER <-> M    

     this_name_list = strsplit(this_alias_list, ';', /extract)
     n_names = n_elements(this_name_list)
     
     for kk = 0, n_names-1 do begin

        this_name = this_name_list[kk]        
        if (strpos(strupcase(this_name), "MESSIER") eq 0) $
        then begin
           this_alias = str_replace(this_name,'MESSIER','M')
           if total(this_name_list eq this_alias) eq 0 then begin
              this_alias_list += ';'+this_alias
           endif
        endif
        
     endfor
     
     alias_list[ii] = this_alias_list
     
  endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; MAKE THE PAIRED ALIAS/NAME VECTOR
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "Making the paired PGC<->ALIAS vector."
  print, ""

  n_names = 0L
  for ii = 0L, n_entry-1 do begin
     aliases = strsplit(alias_list[ii], ';', /extract)     
     n_names += n_elements(aliases)
  endfor

  pgc_vec = lonarr(n_names)
  alias_vec = strarr(n_names)

  index = 0L
  for ii = 0L, n_entry-1 do begin
     counter, ii, n_entry, "Master list construction "

     this_pgc_num = tab[ii].pgc

     this_alias_list = strsplit(alias_list[ii], ';', /extract)     
     n_this_alias = n_elements(this_alias_list)

     alias_vec[index:(index+n_this_alias-1)] = this_alias_list
     pgc_vec[index:(index+n_this_alias-1)] = replicate(this_pgc_num, n_this_alias)
     index += n_this_alias
  endfor
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FILL IN USER SUPPLIED ALIASES
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "Adding user supplied aliases."
  print, ""

  readcol, data_dir+"alias.txt", format="A,A" $
           , comment="#", user_name, user_alias, /silent
  user_name = strupcase(strcompress(user_name,/rem))
  user_alias = strupcase(strcompress(user_alias, /rem))

  n_user_alias = n_elements(user_alias)

  user_pgc = lonarr(n_user_alias)*0L - 1L

  for ii = 0L, n_user_alias-1 do begin

;    SKIP IF IT'S ALREADY DEFINED

     if total(user_alias[ii] eq alias_vec) ge 1 then $
        continue

;    ELSE CHAIN IT BASED ON OTHER NAMES

     match_ind = where(user_name[ii] eq alias_vec, match_ct)

     if match_ct eq 0 then begin
        print, "USER SUPPLIED ALIAS: No match for "+user_name[ii]
        continue
     endif
     
     user_pgc[ii] = pgc_vec[match_ind]

  endfor
     
  keep_ind = where(user_pgc ne -1L, keep_ct)
  if keep_ct gt 0 then begin
     pgc_vec = [pgc_vec, user_pgc[keep_ind]]
     alias_vec = [alias_vec, user_alias[keep_ind]]
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; SORT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  sort_ind = sort(alias_vec)
  pgc_vec = pgc_vec[sort_ind]
  alias_vec = alias_vec[sort_ind]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; WRITE TO DISK
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  print, ""
  print, "Printing to a text file."
  print, ""
  
  openw, unit, "gal_data/superset_alias.txt", /get_lun
  printf, unit, '# Column 1: alias'
  printf, unit, '# Column 2: pgc number'
  for ii = 0, n_elements(pgc_vec)-1 do begin
     alias_vec[ii] =  strupcase(strcompress(alias_vec[ii],/rem))
     printf, unit, alias_vec[ii]+" "+str(pgc_vec[ii])
  endfor
  close, unit

  save, file='gal_data/superset_alias.idl', pgc_vec, alias_vec

end
