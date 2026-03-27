****
** Grabo un registro de llamada
****
Parameter mabm, mcodmed, mconsult, midfranja

If vartype(midfranja)#'N'
	midfranja = 0
Endif

mfechahora = sp_busco_fecha_serv("DT")
mfecha 	   = ttod(mfechahora)
mhora	   = val(strtran(left(ttoc(mfechahora,2),5),":",""))
mccpoamb = ''	
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif


Do case

Case mabm = 1

	mpaso = .T.

*!*		mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
*!*			" where TAI_codmed = ?mcodmed" +;
*!*			" and TAI_consultorio = ?mconsult" +;
*!*			" and TAI_fecha = ?mfecha" +;
*!*			" and TAI_idfranja = ?midfranja","mwkregistro")

	mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
		" where &mccpoamb TAI_consultorio = ?mconsult" +;
		" and TAI_fecha = ?mfecha" +;
		" and TAI_idfranja = ?midfranja","mwkregistro")

	If mret > 0
		If used('mwkregistro')
			If reccount('mwkregistro')>0
				mpaso = .f.
			Endif
		Endif
	Else
		mpaso = .f.
		Messagebox('EN BUSQUEDA DE REGISTRO DE INGRESO/EGRESO.'+chr(13);
			+'INTENTE NUEVAMENTE', 16, 'ERROR')
		Do prg_cancelo
	Endif

	If mpaso

		mret = sqlexec(mcon1, "insert into TabAmbIEMed " +;
			"(TAI_codmed,TAI_consultorio,TAI_fecha,TAI_hhmmEgr,TAI_hhmmIng,TAI_idfranja &mcicpoamb)" +;
			" values " +;
			"(?mcodmed,?mconsult,?mfecha,9999,?mhora,?midfranja &mvicpoamb)")

*!*			mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
*!*				" where TAI_codmed = ?mcodmed" +;
*!*				" and TAI_consultorio = ?mconsult" +;
*!*				" and TAI_fecha = ?mfecha" +;
*!*				" and TAI_idfranja = ?midfranja","mwkregistro")

		mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
			" where &mccpoamb TAI_consultorio = ?mconsult" +;
			" and TAI_fecha = ?mfecha" +;
			" and TAI_idfranja = ?midfranja","mwkregistro")

	Endif

Endcase

If mret < 0
	Messagebox('NO SE ACTUALIZO EL REGISTRO DE INGRESO/EGRESO.'+chr(13);
		+'INTENTE NUEVAMENTE', 16, 'ERROR')
	Do prg_cancelo
Endif
