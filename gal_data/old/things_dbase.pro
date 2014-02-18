pro things_dbase, name=name, has24=has24, hasco=hasco, hasrc=hasrc $
                  , isdwarf=isdwarf, things_name=things_name $
                  , rc_name=rc_name, himap_name=himap_name $
                  , common_res=common_res, struct_dir=struct_dir $
                  , nice_name=nicename, aklflag=aklflag
;+
; NAME:
;
; things_dbase
;
; PURPOSE:
;
; reads and parses the things database table I made
;
; CATEGORY:
;
; Science helper?
;
; CALLING SEQUENCE:
;
; things_dbase, name=name, has24=has24, hasco=hasco $
;                  , isdwarf=isdwarf, things_name=things_name $
;                  , rc_name=rc_name, himap_name=himap_name $
;                  , common_res=common_res, struct_dir=struct_dir
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; struct_dir : the location of the THINGS structure files
;
; KEYWORD PARAMETERS:
;
; none
;
; OUTPUTS:
;
;
;
; MODIFICATION HISTORY:
;
; drafted - 05 July 2007 leroy@mpia.de
;
;-

; DIRECTORY FOR FILES
if n_elements(struct_dir) eq 0 then begin
    struct_dir = '/data6/leroy/THINGS/struct_tables/'
endif

readcol, struct_dir+'things.dbase',name,has24,hasco,isdwarf,hasrc $
         , things_name, rc_name, himap_name, common_res, aklflag, nicename $
  , format='A,A,A,A,A,A,A,A,F,A,A',skip=1, delim='|'

for kk = 0, n_elements(name)-1 do begin
    name[kk] = strcompress(name[kk],/remove_all)
    has24[kk] = strcompress(has24[kk],/remove_all)
    hasco[kk] = strcompress(hasco[kk],/remove_all)
    isdwarf[kk] = strcompress(isdwarf[kk],/remove_all)
    hasrc[kk] = strcompress(hasrc[kk],/remove_all)
    things_name[kk] = strcompress(things_name[kk],/remove_all)
    rc_name[kk] = strcompress(rc_name[kk],/remove_all)
    himap_name[kk] = strcompress(himap_name[kk],/remove_all)
    aklflag[kk] = strcompress(aklflag[kk],/remove_all)
    temp = strcompress(nicename[kk],/remove_all)
    strput,temp,' ',strpos(temp,'_')
    nicename[kk] = temp
endfor

return

end                             ; of things_dbase
