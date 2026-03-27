*
* Ambulatorio Registro de Egreso
*
Lparameters mfcheg, mcodmed, mSala, midfranja

mfecha = ttod(mfcheg)
mhora  = val(strtran(left(ttoc(mfcheg,2),5),":",""))

Use in select("mwkiemedregis")

mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
	" where TAI_fecha = ?mfcheg"+;
	" and TAI_codmed = ?mcodmed"+;
	" and TAI_consultorio = ?mSala"+;
	" and TAI_hhmmegr = 9999"+;
	" and TAI_idfranja = ?midfranja","mwkiemedregis")

If mret < 0
	Messagebox("EN ACTUALIZACION DEL EGRESO DEL PROFESIONAL"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

If Used("mwkiemedregis")
	If Reccount("mwkiemedregis") = 0

		mret = sqlexec(mcon1,"insert into TabAmbIEMed (TAI_codmed,TAI_consultorio,TAI_fecha,TAI_hhmmIng,TAI_hhmmEgr,TAI_idfranja)"+;
			" values "+;
			"(?mcodmed,?mSala,?mfcheg,?mhora,?mhora,?midfranja)")

	Else

		mlid = mwkiemedregis.id
		mret = sqlexec(mcon1,"update TabAmbIEMed set TAI_hhmmegr = ?mhora where id = ?mlid")

	Endif

	If mret < 0
		Messagebox("EN ACTUALIZACION DEL EGRESO DEL PROFESIONAL"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Endif

Use in select("mwkiemedregis")
