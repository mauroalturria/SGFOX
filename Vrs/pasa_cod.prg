select codigos
scan
	mleg = legajo
	mfec = fecha
	mcod = codigo
	mapel = apellido
	mnom = nombre
	select * from ttleg where legajo = mleg into cursor lega
		mid = lega.id
	if mid>0
		mfecp = ctod("01/01/1900")
		insert into ttcod(Codigo, FechaAlta, FechaBaja,IdLegajo) ;
			values ( mcod,mfec,mfecp,mid)
	else
		set step on 
		insert into ttleg (Apellido, FechaEgreso,FechaIngreso, Legajo, Nombre) ;
			values ( mapel,mfecp,mfec,mleg,mnom)
	endif
endscan 


