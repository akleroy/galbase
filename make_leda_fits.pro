pro make_leda_fits $
   , print_query = print_query $
   , parse_query = parse_query $
   , for_sample = sample_file
  
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; DEFAULTS & DEFINITIONS
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if keyword_set(print_query) then begin

;    If requested for a specific sample, then build for that. Else
;    find all galaxies with recessional velocities less than 5000
;    km/s.

     if n_elements(sample_file) eq 0 then begin

        print, "Printing query for all galaxies with v < 5000 km/s"
        print, ""

        leda_string = "select objname, hl_names(pgc), pgc"+ $
                      ", modz, mod0, al2000, de2000"+ $
                      ", v, e_v, vrad, e_vrad, vvir"+ $
                      ", pa, incl, logr25, e_logr25"+$
                      ", type, bar, ring, multiple, compactness, t, e_t"+$ 
                      ", logd25, e_logd25, vmaxg, e_vmaxg, vrot, e_vrot"+$
                      ", m21, e_m21, mfir"+$
                      ", ag, btc, ubtc, bvtc, itc"+$
                      " where v < 5000 and objtype='G'"
        
        print, "HyperLEDA SQL string was: ", leda_string

     endif else begin

        readcol $
           , sample_file $
           , format='A' $
           , obj_names $
           , comment='#'
        n_obj = n_elements(obj_names)

        objname_string = ""
        for ii = 0, n_obj-1 do begin
           if ii eq 0 then $
              objname_string += "objname=objname('"+obj_names[ii]+"')" $
           else $
              objname_string += " or objname=objname('"+obj_names[ii]+"')"
        endfor

        leda_string = "select objname, hl_names(pgc), pgc"+ $
                      ", modz, mod0, al2000, de2000"+ $
                      ", v, e_v, vrad, e_vrad, vvir"+ $
                      ", pa, incl, logr25, e_logr25"+$
                      ", type, bar, ring, multiple, compactness, t, e_t"+$ 
                      ", logd25, e_logd25, vmaxg, e_vmaxg, vrot, e_vrot"+$
                      ", m21, e_m21, mfir"+$
                      ", ag, btc, ubtc, bvtc, itc"+$
                      " where "+objname_string

        print, "HyperLEDA SQL string was: ", leda_string

     endelse
     
     return
  endif

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; QUERY LEDA
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
  
; This part goes by hand. Take the SQL query and go to LEDA, then pull
; down the results into a text file.

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; BUILD THE STRUCTURE
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

  if keyword_set(parse_query) then begin

     if n_elements(sample_file) eq 0 then begin
; WAS: infile = "gal_data/leda_vlsr3500.txt"
        infile = "gal_data/leda_vlsr5000.txt"
        outfile = "gal_data/leda_vlsr5000.fits"
     endif else begin
        infile = sample_file
        outfile = strmid(sample_file,0,strlen(sample_file)-4)+'.fits'
     endelse

     readcol, infile, comment="#", delim="|" $
              , objname, hl_names, pgc $
              , modz, mod0, al2000, de2000 $
              , v, e_v, vrad, e_vrad, vvir $
              , pa, incl, logr25, e_logr25 $
              , format = $
              "A,A,L"+ $
              ",F,F,F,F"+ $
              ",F,F,F,F,F" + $
              ",F,F,F,F"+ $
              ",X,X,X,X,X,X,X"+ $
              ",X,X,X,X,X,X"+ $
              ",X,X,X"+ $           
              ",X,X,X,X,X"

     readcol, infile, comment="#", delim="|" $
              , type, bar, ring, multiple, compactness, t, e_t $           
              , logd25, e_logd25, vmaxg, e_vmaxg, vrot, e_vrot $
              , m21, e_m21, mfir $
              , ag, btc, ubtc, bvtc, itc $
              , format = $
              "X,X,X"+ $
              ",X,X,X,X"+ $
              ",X,X,X,X,X" + $
              ",X,X,X,X"+ $
              ",A,A,A,A,A,F,F"+ $
              ",F,F,F,F,F,F"+ $
              ",F,F,F"+ $
              ",F,F,F,F,F"

     nan = !values.f_nan
     empty = { $
             objname: "", $
             hl_names: "", $
             pgc: 0L, $          
             modz: nan, $
             mod0: nan, $
             al2000: nan, $
             de2000: nan, $
             v: nan, $
             e_v: nan, $
             vrad: nan, $
             e_vrad: nan, $
             vvir: nan, $
             pa: nan, $
             incl: nan, $
             logr25: nan, $
             e_logr25: nan, $
             type: "", $
             bar: "", $
             ring: "", $
             multiple: "", $  
             compactness: "", $
             t: nan, $
             e_t: nan, $
             logd25: nan, $
             e_logd25: nan, $
             vmaxg: nan, $
             e_vmaxg: nan, $
             vrot: nan, $
             e_vrot: nan, $
             m21: nan, $
             e_m21: nan, $
             mfir: nan, $
             ag: nan, $
             btc: nan, $
             ubtc: nan, $
             bvtc: nan, $
             itc: nan $
             }

     n_leda = n_elements(objname)
     data = replicate(empty,n_leda)
     for i = 0L, n_leda-1 do begin
        counter, i, n_leda, " out of "
        data[i].objname = strcompress(objname[i], /rem)
        data[i].hl_names = strcompress(hl_names[i], /rem)
        data[i].pgc = strcompress(pgc[i], /rem)
        data[i].modz = modz[i]
        data[i].mod0 = mod0[i]
        data[i].al2000 = al2000[i]
        data[i].de2000 = de2000[i]
        data[i].v = v[i]
        data[i].e_v = e_v[i]
        data[i].vrad = vrad[i]
        data[i].e_vrad = e_vrad[i]
        data[i].vvir = vvir[i]
        data[i].pa = pa[i]
        data[i].incl = incl[i]
        data[i].logr25 = logr25[i]
        data[i].e_logr25 = e_logr25[i]
        data[i].type = strcompress(type[i], /rem)
        data[i].bar = strcompress(bar[i], /rem)
        data[i].ring = strcompress(ring[i], /rem)
        data[i].multiple = strcompress(multiple[i], /rem)
        data[i].compactness = strcompress(compactness[i], /rem)
        data[i].t = t[i]
        data[i].e_t = e_t[i]
        data[i].logd25 = logd25[i]
        data[i].e_logd25 = e_logd25[i]
        data[i].vmaxg = vmaxg[i]
        data[i].e_vmaxg = e_vmaxg[i]
        data[i].vrot = vrot[i]
        data[i].e_vrot = e_vrot[i]
        data[i].m21 = m21[i]
        data[i].e_m21 = e_m21[i]
        data[i].mfir = mfir[i]
        data[i].ag = ag[i]
        data[i].btc = btc[i]
        data[i].ubtc = ubtc[i]
        data[i].bvtc = bvtc[i]
        data[i].itc = itc[i]
     endfor

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; PARE DOWN TO A SUBSAMPLE THAT WE CARE ABOUT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

;    Require some apparent magnitude if we want to keep this.

     keep = where(finite(data.btc) or $
                  finite(data.itc), keep_ct)

     message, "Keeping "+str(keep_ct)+" of "+str(n_elements(data))+" because they have optical magnitudes.", /info

     data = data[keep]

; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
; OUTPUT
; &%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%

     mwrfits, data, outfile, hdr, /create

  endif

end
