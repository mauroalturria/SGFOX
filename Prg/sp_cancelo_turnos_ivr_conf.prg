***
***   Cancelo todos los turnos del archivo que me envian
***
miarchi = 0
if vartype(miarchivo)="N"
	miarchi = miarchivo
endif
mnarch = miarchi
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif

select mwkturnoconfirma

scan
	mid = mwkturnoconfirma.id
	mret = sqlexec(mcon1, "select * from turnos " + ;
		"where id = ?mid", "mwktodos")
	select mwktodos
	scatter to regi
	mafili 		= round(mwktodos.afiliado, 0)
	if !used('mwknoanula')
		select * from mwktodos where 1 = 2 into cursor noanula
		use dbf('noanula') alias mwknoanula again in 0
	endif
	mccad = transf(mid)
	mccad = mccad + chr(9) + transf(mwkturnoconfirma.NOMBRE )
	mccad = mccad + chr(9) + transf(mwktodos.codmed)
	mccad = mccad + chr(9) + transf(mwktodos.horatur)
	if mwktodos.afiliado = 0
		select mwkturnoconfirma
		regi(1) = N_REF
		regi(2) = HCLIN
		regi(3) ="NO EXISTE"

		select mwknoanula
		append from array regi
		mccad = mccad + chr(9) + "Anulado"
		if mnarch > 0
			fputs(mnarch, mccad)
		endif

	endif
endscan
