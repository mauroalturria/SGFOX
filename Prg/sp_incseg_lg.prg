*
* Incidente de Seguridad - Registro / Actualziación de datos de cabecera
*
Parameters mform

muser = IIF(USED("mwkusuarios"),mwkusuarios.idusuario,mwkusuario.idusuario)
mfech = sp_busco_fecha_serv("DT")
mretr = .T.

*!*	Paciente Involucrado
*!*	Paciente Involucrado carga inicial
*!*	Fecha informe
*!*	Persona que completo este formulario
*!*	Area mwksectores.sec_codsector
*!*	Puesto
*!*	Interno
*!*	Telefono contacto
*!*	Fecha incidente
*!*	Hora incidente
*!*	Edificio
*!*	Piso
*!*	Sector
*!*	Descripcion
*!*	Log Movimientos
*!*	Fecha Movimiento
*!*	Usuario

Dimension vd[15]

vd[01] = mform.opttipo.Value
vd[02] = mform.opttipo.Value
vd[03] = mform.txtfinf.Value
vd[04] = Alltrim(mform.txtperso.Value)
vd[05] = mwksectores.SEC_codsector
vd[06] = mwkpuesto2.lid
vd[07] = mform.txtinterno.Value
vd[08] = mform.txttelef.Value
vd[09] = mform.txtfinc.Value
vd[10] = mform.txthorad.Value
vd[11] = mwkedificio._id
vd[12] = mwkplantas._id
vd[13] = mwkareas._id
vd[14] = Alltrim(mform.txtdes.Value)

If mform.idincidente = 0 && Nuevo registro

	vd[15] = Ttoc(mfech) + ' : ' + 'REGISTRO DE INCIDENTE, ' + Iif(mform.opttipo.Value = 1, 'CON PACIENTE INVOLUCRADO', 'CON PACIENTE INVOLUCRADO')

	mret = SQLExec(mcon1,"insert into ZabISeg " +;
		"(ZIS_pacinv, ZIS_pacinvorg, ZIS_fecinf, ZIS_percompleto, ZIS_area, ZIS_puesto, ZIS_interno, ZIS_telcontac, ZIS_fecincidente, "+;
		"ZIS_horincidente, ZIS_edificio, ZIS_piso, ZIS_sector, ZIS_descripcion, ZIS_logmov, ZIS_fecmov, ZIS_idusuario)"+;
		" values "+;
		"(?vd[01], ?vd[02], ?vd[03], ?vd[04], ?vd[05], ?vd[06], ?vd[07], ?vd[08], ?vd[09], ?vd[10], ?vd[11], ?vd[12], ?vd[13], ?vd[14], ?vd[15], ?mfech, ?muser)")

	If mret < 0

		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "REGISTRO DE INCIDENTE DE SEGURIDAD"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
		Messagebox("Registro Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
		mretr = .F.

	Else

		Use In Select("mwkisdat")

		mret = SQLExec(mcon1,"select id as lid from ZabISeg where ZIS_idusuario = ?muser and ZIS_fecmov = ?mfech","mwkisdat")

		If mret < 0
			=Aerr(eros)
			mmsgerr = eros(3)
			mdetalle= "BUSQUEDA DE REGISTRO INCIDENTE DE SEGURIDAD"
			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
			Messagebox("Busqueda Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
			mretr = .F.
		Endif

		If Used("mwkisdat")
			SELECT mwkisdat
			Go Top
			mform.idincidente = mwkisdat.lid
		Endif

		Use In Select("mwkisdat")

	Endif

Else

	mlid = mform.idincidente

	vd[15] = Chr(13) + Ttoc(mfech) + ' : ' + 'REGISTRO DE INCIDENTE, ' + Iif(mform.opttipo.Value = 1, 'CON PACIENTE INVOLUCRADO', 'CON PACIENTE INVOLUCRADO')

	mret = SQLExec(mcon1,"update ZabISeg set " +;
		"ZIS_pacinv = ?vd[01]," +;
		"ZIS_pacinvorg = ?vd[02]," +;
		"ZIS_fecinf = ?vd[03]," +;
		"ZIS_percompleto = ?vd[04]," +;
		"ZIS_area = ?vd[05]," +;
		"ZIS_puesto = ?vd[06]," +;
		"ZIS_interno = ?vd[07]," +;
		"ZIS_telcontac = ?vd[08]," +;
		"ZIS_fecincidente = ?vd[09], "+;
		"ZIS_horincidente = ?vd[10]," +;
		"ZIS_edificio = ?vd[11]," +;
		"ZIS_piso = ?vd[12]," +;
		"ZIS_sector = ?vd[13]," +;
		"ZIS_descripcion = ?vd[14]," +;
		"ZIS_logmov = ZIS_logmov + ?vd[15]," +;
		"ZIS_fecmov = ?mfech," +;
		"ZIS_idusuario = ?muser"+;
		"where id = ?mlid")

	If mret < 0

		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "ACTUALIZACION DE INCIDENTE DE SEGURIDAD"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mUser, "Log Incidente Seguridad"
		Messagebox("Actualización Incidente de Seguridad", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")
		mretr = .F.

	Endif

Endif

Release vd

Return mretr
