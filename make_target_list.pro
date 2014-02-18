pro make_target_list $
   , data_dir=data_dir

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DIRECTION AND DEFAULTS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

if n_elements(data_dir) eq 0 then begin
    data_dir = '$MY_IDL/nearby_galaxies/gal_data/'
endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; POSITION AND ORIENTATION
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
 
; READ DATA
dist_file = data_dir+'table_dist.txt'
readcol, dist_file $
         , dist_name $
         , format='A,F', comment='#', /silent

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; SORT AND WRTIE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

name = dist_name[sort(dist_name)]
name = name[uniq(name)]
n_name = n_elements(name)

openw, 1, data_dir+"target_list.txt"

printf, 1, "# Column 1: name"
printf, 1, "# "

for i = 0, n_name-1 do begin
   printf, 1, name[i]
endfor

close, 1

end
