pro queryned $
   , list $
   , MU=mu $
   , ERRMU=errmu $
   , DIST=D $
   , ERRDIST=errD $
   , MINDIST=minD $
   , MAXDIST=maxD $
   , DISTMOD=distmod $
   , VHEL=vhel $
   , ERRVHEL=errvhel $
   , RADEG=ra_deg $
   , DECDEG=dec_deg $
   , AV=av $
   , STRUCT=outstruct $
   , OUTLINES=outlines $
   , HEADER=header $
   , OUTFILE=outfile $
   , quiet=quiet

;+
;
; Script to query NED for distances from Brent Groves. Also now grabs
; the Schlafly+ A_V value. Other minor modifications (NaN default
; values and traps the case of no error on the heliocentric velocity).
;
;-

; Check inputs

  On_Error,2

  n_list = n_elements(list)
  IF n_list EQ 0 then begin
     print, "distned, list, [mu, errmu, D, errD, minD, maxD]"
     return 
  ENDIF

; Initialize strings strings

  if not keyword_set(distmod) then $
     distmod = "D (Virgo + GA only)"
  strvhel  = "V (Heliocentric)"
  strradec = "Equatorial (J2000.0)"

; initialize outputs to be extracted from NED

  nan = !values.f_nan

  mu      = dblarr(n_list)*nan
  errmu   = dblarr(n_list)*nan
  vhel    = dblarr(n_list)*nan
  errvhel = dblarr(n_list)*nan
  D       = dblarr(n_list)*nan
  errD    = dblarr(n_list)*nan
  minD    = dblarr(n_list)*nan
  maxD    = dblarr(n_list)*nan
  ra_deg   = dblarr(n_list)*nan
  dec_deg  = dblarr(n_list)*nan
  av      = dblarr(n_list)*nan

; Loop over list entries

  for i=0, n_list-1 do begin

     if keyword_set(quiet) eq 0 then $
        print,"----- "+list[i]+"-----"

     spawn,"wget --quiet -O tmp_ned.out http://nedwww.ipac.caltech.edu/cgi-bin/nph-objsearch\?objname="+strtrim(list[i])+$
           "\&extend=no\&hconst=73\&omegam=0.27\&omegav=0.73\&corr_z=3"+$
           "\&out_csys=Equatorial\&out_equinox=J2000.0\&obj_sort=RA+or+Longitude"+$
           "\&of=pre_text\&zv_breaker=30000.0\&list_limit=5\&img_stamp=NO"

                                ; ...redshift distance
   ;;;
     spawn,"awk '/Mean/ {print $3, $7}; /Min./ && /Max./ {print $3, $6}' tmp_ned.out", distances

;   print,distances
     IF n_elements(distances) EQ 2 THEN BEGIN
        D[i]   =double(strmid(distances[0],4,6))
        IF NOT STRMATCH(distances[0],'*N/A*') THEN BEGIN
           this_dist_err = double(strmid(distances[0],25,4))
           if this_dist_err ne 0.0 then $
              errD[i]=this_dist_err $
           else $
              message, 'No distance error.', /info
        ENDIF
        temp=strsplit(distances[1],'><',/extract)
        minD[i]=double(temp[1])
        maxD[i]=double(temp[6])
     ENDIF

     spawn,"awk '/Mean/ {print $2, $6};' tmp_ned.out", NEDdistmod
     mu[i]   = double(strmid(NEDdistmod[0],4,5))
     IF NOT STRMATCH(NEDdistmod[0],'*N/A*') THEN errmu[i]=double(strmid(NEDdistmod[0],19,4))

   ;;; grep "D (Virgo + GA only)" tmp_ned.out | cut -b 65-70,75-79
;   spawn,"grep '"+distmod+"'  tmp_ned.out | cut -b 65-70,75-79",strdum
;   mu[i]    = double(strmid(strdum[0],0,5))
;   errmu[i] = double(strmid(strdum[0],7,4))

                                ; ...Heliocentric velocity [in km/s]
   ;;; grep "V (Heliocentric)" tmp_ned.out | cut -b 30-36,41-47
     spawn,"grep '"+strvhel+"'  tmp_ned.out | cut -b 30-36,41-47",strdum
     vhel[i]    = double(strmid(strdum[0],0,8))
     this_errvhel = double(strmid(strdum[0],8,8))
     if this_errvhel ne 0.0 then $
        errvhel[i] = this_errvhel $
     else $
        message, 'No heliocentric velocity error.', /info

                                ; ...position RA,DEC [in degrees]
   ;;; grep "Equatorial (J2000.0)" tmp_ned.out | cut -b 22-32,34-44
     spawn,"grep '"+strradec+"'  tmp_ned.out | cut -b 22-32,34-44",strdum
     ra_deg[i]   = double(strmid(strdum[0],0,11))
     dec_deg[i]  = double(strmid(strdum[0],11,11))

;    &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
;    FIND FOREGROUND EXTINCTION AT V BAND
;    &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

     spawn,"grep '<td>Filter' tmp_ned.out -m 1", strext
     for kk = 0, 11 do begin
        next_pos = strpos(strext, '<td>')
        strext = strmid(strext, next_pos+4)
        stop_pos = strpos(strext, '</td>')
        band_string = strmid(strext, 0, stop_pos)
        if (strcompress(band_string, /rem)) eq 'V(0.54)' then begin
           vnum = kk
           break
        endif
     endfor

     spawn,"grep '<tr><td>A<sub>&lambda;</sub>' tmp_ned.out -m 1", strext
     for kk = 0, vnum do begin
        next_pos = strpos(strext, '<td>')
        strext = strmid(strext, next_pos+4)
     endfor
     stop_pos = strpos(strext, '</td>')
     av_string = strmid(strext, 0, stop_pos)
     av[i] = float(av_string)
     
  endfor

; remove temporary files
  spawn,"rm -rf tmp_ned.out"

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; FORMAT OUTPUT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BUILD A STRUCTURE
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  empty_struct = $
     { $
     name: "", $
     ra:nan, $
     dec:nan, $
     mu:nan, $
     errmu:nan, $
     d:nan, $
     errd:nan, $
     mind:nan, $
     maxd:nan, $
     vhel:nan, $
     errvhel:nan, $
     av:nan $
     }
  out_struct = replicate(empty_struct, n_list)
  for ii = 0, n_list-1 do begin
     out_struct.name = list
     out_struct.ra = ra_deg
     out_struct.dec = dec_deg
     out_struct.mu = mu
     out_struct.errmu = errmu
     out_struct.d = d
     out_struct.errd = errd
     out_struct.mind = mind
     out_struct.maxd = maxd
     out_struct.vhel = vhel
     out_struct.errvhel = errvhel
     out_struct.av = av     
  endfor

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FORMAT OUTPUT LINES
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  if n_elements(header) eq 0 then begin
     header = "# NED distances "
     header = [header, "#"]
     header = [header,"# name   = galaxy name"]
     header = [header,"# RA,DEC = RA, DEC (J2000) [in degrees]"]
     header = [header,"# mu     = distance modulus (+error) derived from z [in mag]"]
     header = [header,"# D      = mean distance (+error) [in Mpc]"]
     header = [header,"# minD   = min distance in NED [in Mpc]"]
     header = [header,"# maxD   = max distance in NED [in Mpc]"]
     header = [header,"# Vhel   = Heliocentric velocity [in kms]"]
     header = [header,"# A_V    = foreground extinction [in mag] from Schlafly+ '11"]
     header = [header,"#"]
     header = [header,"# Total number of galaxies: "+strcompress(string(n_list),/REMOVE_ALL)]
     header = [header,"#"]
     header = [header,"###########################################################################################################################"]
     header = [header,"#name           |     RA[deg]  |    DEC[deg]  |     mu[mag]  |      mu_err |       D[Mpc]  |       D_err  |    minD[Mpc] |    maxD[Mpc] |    Vhel[kms] |     Vhel_err |    A_V[mag] "]
  endif

  first = 1B
  for i=0,n_list-1 do begin
     line = ''
     line += string(list[i], format='(a15)')+' | '
     line += string(ra_deg[i], format='(d12.6)')+' | '
     line += string(dec_deg[i], format='(d12.6)')+' | '
     line += string(mu[i], format='(d12.6)')+' | '
     line += string(errmu[i], format='(d12.6)')+' | '
     line += string(d[i], format='(d12.6)')+' | '
     line += string(errd[i], format='(d12.6)')+' | '
     line += string(mind[i], format='(d12.6)')+' | '
     line += string(maxd[i], format='(d12.6)')+' | '
     line += string(vhel[i], format='(d12.6)')+' | '
     line += string(errvhel[i], format='(d12.6)')+' | '
     line += string(av[i], format='(d12.6)')
     if first then $
        outlines = line $
     else $
        outlines = [outlines, line]
     first = 0B
  endfor

; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRINT TO A FILE
; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  if n_elements(outfile) gt 0 then begin
     openw,unit,outfile, /get_lun
     for ii = 0, n_elements(header)-1 do $
        printf, unit, header[ii]
     for ii = 0, n_elements(outlines)-1 do $
        printf, unit, outlines[ii]
     close,unit
     free_lun, unit
  endif

end
