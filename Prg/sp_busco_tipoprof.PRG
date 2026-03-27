*
* Cuidados Domiciliarios, selección del tipo de profesional
*
Lparameters mtipo

mfnull = Ctod("01/01/1900")

Use In Select("MWKTipoProf")

mret = SQLExec(mcon1,"select TDP_tipo, TDP_prestador, id as lprofid, TDP_idmaestro, TDP_email"+;
	" from TabCuiDomProf"+;
	" where TDP_pasivado = ?mfnull"+;
	" and TDP_tipo = ?mtipo","MWKTipoProf")

If mret < 0
	MTABLA = "C.D. PROFESIONALES DISPONIBLES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select Iif(TDP_tipo=1,"MEDICO",Iif(TDP_tipo=2,"ENFERMERO","EXTERNO")) As ltipo,;
	TDP_prestador, lprofid, Iif(TDP_tipo=1,_busespe(TDP_idmaestro),Space(30)) As lespe,;
	 TDP_email as lmail;
	FROM MWKTipoProf;
	INTO Cursor MWKTipoProf Readwrite

Return .T.

Function _busespe(mbusid)
	Use In Select("mwklespe")
	mretorna = Space(5)
	mret = SQLExec(mcon1,"select codesp from prestadores where id = ?mbusid","mwklespe")
	If mret < 0
		MTABLA = "C.D. CONSULTA DE ESPECIALIDADES PROFESIONAL"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
	If Used("mwklespe")
		If Reccount("mwklespe")>0
			mretorna = mwklespe.codesp
		Endif
	Endif
	Use In Select("mwklespe")
Return mretorna
