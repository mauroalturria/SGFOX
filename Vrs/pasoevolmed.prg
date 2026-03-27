create cursor mwkevolprin ( EIm_fechaH t,EIm_codmed n(4),nombre c(40),orden n (4),linea c(250))

	select tabintevolmed
scan
	mid = id
	nlin = alines(mimat,EIM_indicacion,.t.)
 
	j=1
	for i = 1 to nlin
		if !empty(mimat(i))
			limpre = .t.
			npos32 = rat(" ",left(mimat(i),250))
					j= j +1
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			insert into mwkevolprin ( EIm_fechaH ,EIm_codmed ,nombre ,orden,linea) ;
				values ( tabintevolmed->EIm_fechaH ,tabintevolmed->EIm_codmed ,tabintevolmed->nombre ,j,left(mimat(i),npos32))
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					j= j +1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					insert into mwkevolprin ( EIm_fechaH ,EIm_codmed ,nombre ,orden,linea) ;
						values ( tabintevolmed->EIm_fechaH ,tabintevolmed->EIm_codmed ,tabintevolmed->nombre ,j,left(mimati,npos32 ))
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next
endscan
