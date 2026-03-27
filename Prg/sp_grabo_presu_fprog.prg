*
* Actualizacion de Fecha de Programacion
*
Do sp_grabo_presu_fprog with mfec,.pIdPre,.lfecpro
lparameters mlfec, mlidpre, mlfecpro

mret = sqlexec(mcon1,"update Tabpresupuestos set valorfechaprog = ?mlfec"+;
	" where id = ?mlidpre")

if mret < 0
	messagebox("EN LA ACTUALIZACION DE LA FECHA DE PROGRAMACION"+chr(10)+;
		"avise a sistemas",16,"ERROR")
else

	select mwkestadopres

	mpaciente      = mwkestadopres.paciente
	mnroafiliado   = mwkestadopres.nroafiliado
	mobservaciones = "ACTUALIZACION FEC.PROG., ANTERIOR : "+dtoc(mlfecpro)+", ACTUAL : "+dtoc(mlfec)
	mfechasolic    = mwkestadopres.fechasolic
	mfechaautopres = sp_busco_fecha_serv("DT")
	mestadoactual  = mwkestadopres.estadoactual
	musuario       = mwkusuario.id

	mret = sqlexec(mcon1, "insert into TabpAuditoria (paciente,NroAfiliado,observaciones,fechasolic,"+;
		"fechaautopres,estadoactual,usuario,idpres)"+;
		" values(?mpaciente,?mnroafiliado,?mobservaciones,?mfechasolic,?mfechaautopres,?mestadoactual,"+;
		"?musuario,?mlidpre )")

	if mret < 0
		messagebox("EN ACTUALIZACION DE ARCHIVO DE LOG PRESUPUESTOS"+chr(10)+;
			"avise a sistemas",16,"ERROR")
	endif

endif



