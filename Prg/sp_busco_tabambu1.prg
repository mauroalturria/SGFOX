Lparameters lcProtocolo, lcCursor

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = SQLExec(mcon1, "select protocolo, fechahoraing,demanda, REG_nombrepac, nombre, codprest, ENT_descrient,ENT_nroprestadorexterno, " + ;
		"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, TabAmbulatorio.id, prestacions.Pre_codservicio, " + ;
		"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
		" TabAmbulatorio.codent, nroregistrac,TabAmbulatorio.codmed,TabAmbulatorio.ID, tipoest,descrip,codcie9  " + ;
		"from prestacions, entidades, especialid, registracio, afiliacion," + ;
		"tabtipoaltas,TabAmbulatorio left outer join prestadores on TabAmbulatorio.codmed = prestadores.id " + ;
		"where TabAmbulatorio.nroregistrac = registracio.REG_nroregistrac and " + ;
		"TabAmbulatorio.nroregistrac = afiliacion.registracio and " + ;
		"TabAmbulatorio.codent = afiliacion.AFI_codentidad and " + ;
		"TabAmbulatorio.codprest = prestacions.PRE_codprest and " + ;
		"TabAmbulatorio.codestado = tabtipoaltas.id and " + ;
		"prestacions.PRE_especialidad = ESP_codesp and " + ;
		"TabAmbulatorio.codent	= entidades.ENT_codent and " + ;
		"TabAmbulatorio.protocolo = ?lcProtocolo " + mccpoamb  , lcCursor)

	
If mRet <= 0
	Messagebox("ERROR DE LECTURA DE AUTORIZACIONES ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	