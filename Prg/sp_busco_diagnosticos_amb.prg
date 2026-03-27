*!*	busca los diagnosticos de TabAmbulatorio

Parameter mnivel, mfecha1, mfecha2, mbusca

*!*	mnivel = 2
*!*	mfecha1 = Ctod("01/01/2011")
*!*	mfecha2 = Ctod("01/02/2011")
*!*	mbusca = " 1=1 " && 1
*!*	mbusca = " " && 2

mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

If mnivel = 1

	mret = SQLExec(mcon1, "Select TabCiap2E.descripcion, TabAmbulatorio.FechaHoraIng,  " + ;
		"TabAmbulatorio.FechaHoraAte, TabAmbulatorio.Protocolo, TabAmbulatorio.codCIE9,PRE_especialidad " + ;
		",TabCiap2E.fecanula "+;
		",TabCiap2E.codigo, capitulo,letra "+;
		"from TabCiap2E " + ;
		"Inner Join TabAmbulatorio On TabAmbulatorio.codcie9 = TabCiap2E.Id " + ;
		"Left join Prestacions on  Prestacions.Pre_CodPrest = TabAmbulatorio.CodPrest " + ;
		"left join TabCiapCap on TabCiapCap.id = TabCiap2E.componente " + ;
		"Where " + mbusca +;
		"And TabAmbulatorio.FechaHoraIng >= ?mf1 and TabAmbulatorio.codmed > 1 " + ;
		"And TabAmbulatorio.FechaHoraIng < ?mf2 " + mccpoamb + ;
		"group by protocolo" , "mwkDiagAmb")

Else

	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and TabMedExterno.codambito = ?mxambito "
	Endif 

	mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores  " + ;
		" union  SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora = 0 " + mccpoamb +;
		"ORDER BY nombre", "mwkMedAmb" )


	If mret <= 0
		Messagebox("ERROR EN LA CONSULTA DE PRESTADORES", 48, "VALIDACION")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Cancel
	Endif

	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
	Endif 

*!*	TabAmbulatorio.codmedcie9

	mret = SQLExec(mcon1, "Select TabCiap2E.descripcion, TabAmbulatorio.FechaHoraIng, TabAmbulatorio.codprest, " + ;
		"TabAmbulatorio.FechaHoraAte, TabAmbulatorio.Protocolo, TabAmbulatorio.codCIE9, " + ;
		"Registracio.Reg_NroHClinica, Registracio.Reg_NombrePac, Registracio.Reg_FecNacimiento, reg_sexo," + ;
		"Entidades.Ent_DescriEnt, tabtipoaltas.descrip, TabAmbMsg.TAM_Mensaje, " + ;
		"PRE_especialidad, pre_descriprest, TabAmbulatorio.codmed " + ;
		",TabCiap2E.codigo, capitulo,letra "+;
		"from TabAmbulatorio "+;
		"inner join TabCiap2E on TabAmbulatorio.codcie9 = TabCiap2E.Id " + ;
		"inner join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
		"left join TabAmbMsg on TabAmbMsg.TAM_Protocolo = TabAmbulatorio.protocolo " + ;
		"Inner Join Registracio on TabAmbulatorio.NroRegistrac = Registracio.REG_NroRegistrac " + ;
		"Inner join Entidades on  Entidades.Ent_CodEnt = TabAmbulatorio.CodEnt " + ;
		"Left join Prestacions on  Prestacions.Pre_CodPrest = TabAmbulatorio.CodPrest " + ;
		"left join TabCiapCap on TabCiapCap.id = TabCiap2E.componente " + ;
		"Where " + ;
		"TabAmbulatorio.Fechaate >= ?mf1 " + ;
		"And TabAmbulatorio.Fechaate < ?mf2 and " + mbusca +;
		" and TabAmbulatorio.codmed>1 and TabAmbulatorio.codestado >1 " + mccpoamb, "mwkDiagAmb")

Endif

If mret <= 0
	Messagebox("ERROR EN LA CONSULTA DE LOS DATOS", 48, "VALIDACION")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Cancel
Endif
