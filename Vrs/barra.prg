*!*	select faltabarra
*!*	scan
*!*		mmed = codmed
*!*		mfec = fechab
*!*		mdia = diab
*!*		mhora = hora
*!*		
*!*		select * from presta where codmed = mmed and diasem = mdia and hora = mhora;
*!*			and mfec<fecvigenh and mfec>fecvigend into cursor control
*!*		select faltabarra 
*!*		if reccount('control')>0
*!*			mid = control.id
*!*			replace id with mid,dia with " "
*!*		endif
*!*	endscan 
*!*	sdelete  from faltabarra where empty(id) 

select barras
scan
	mmed = nombre
	mfec = fechab
	mdia = diab
	mcodmed = codmed
	mhorad = ctot(dtoc(fechab)+" "+transf(hhmmdes,"99:99"))
	mhorah = ctot(dtoc(fechab)+" "+transf(hhmmhas,"99:99"))	
	mcodb = val(codbarra)
	mid = id
	select * from barramedico where codbarra = mcodb  and fecha = mfec into cursor control
	if reccount('control')=0
		insert into barramedico (codbarra, fecha,horadesde, horahasta,nombre, codmed,sala) ;
		values ( mcodb,mfec,mhorad,mhorah,mmed,mcodmed,'')
	endif
endscan 


