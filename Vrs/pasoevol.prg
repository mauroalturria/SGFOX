create cursor mwkevolprin ( EIP_fechaH t,EIP_tipoEvol c,EIP_tipoUsuario n(1),EIP_usuario n (8),orden n (4),linea c(250))

select tabintevolnurse
scan
	mid = id
	nlin = alines(mimat,eip_evol,.t.)
	select evoluc
	for i = 1 to nlin
		if !empty(mimat(i))
			limpre = .t.
			j=1
			npos32 = rat(" ",left(mimat(i),250))
			npos32 = iif(npos32>0 and len(alltrim(left(mimat(i),250))) = 250 ,npos32,250)
			insert into mwkevolprin (EIP_fechaH ,EIP_tipoEvol,EIP_tipoUsuario,EIP_usuario,orden,linea) ;
				values (tabintevolnurse->EIP_fechaH ,tabintevolnurse->EIP_tipoEvol,tabintevolnurse->EIP_tipoUsuario,;
					tabintevolnurse->EIP_usuario,j,left(mimat(i),npos32))
			if len(alltrim(mimat(i)))>250
				mimati = substr(alltrim(mimat(i)),npos32 +1 )
				do while len(mimati)>1
					j= j +1
					npos32 = rat(" ",left(mimati,250))
					npos32 = iif(npos32>0 and len(alltrim(left(mimati,250))) = 250 ,npos32,250)
					insert into mwkevolprin (EIP_fechaH ,EIP_tipoEvol,EIP_tipoUsuario,EIP_usuario,orden,linea) ;
						values (tabintevolnurse->EIP_fechaH ,tabintevolnurse->EIP_tipoEvol,;
						tabintevolnurse->EIP_tipoUsuario,tabintevolnurse->EIP_usuario,j,left(mimati,npos32 ))
					mimati = substr(alltrim(mimati),npos32 +1)
				enddo
			endif
		endif
	next
endscan
