select vista2
scan	
	mid = idinforme
	requery('informes')
	if reccount('informes')>0
		miproto = informes.nroprotocolo
		mifecha = informes.fechainforme
		mifechac = informes.fechaaprobacion
		requery('vista1')
		if reccount('vista1')>0
			midnuevo = vista1.id
			select vista2
			replace idinforme with midnuevo 
		else
			midoc = "***" + alltrim(documentobase)
			replace documentobase with midoc
		endif
	else
		midoc = "***" + alltrim(documentobase)
		replace documentobase with midoc
	endif
endscan