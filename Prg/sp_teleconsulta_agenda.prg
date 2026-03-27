Lparameters nOpcion, mRegistracio,mcbusca,mid,mEstado,mcursor,mobserva

If Vartype(mcursor)<>"C"
	mcursor= "mwkCtgAgenda"
Endif
If Used('mwkusuarios')
	mcidusu = mwkusuarios.idusuario
Else
	mcidusu = mwkusuario.idusuario
Endif
If Vartype(mobserva)<>"C"
	mobserva= ""
Endif
If Vartype(mcbusca)<>"C"
	mcbusca = ''
Endif
If Vartype(mEstado )<>"N"
	mEstado = 1
Endif
If Vartype(mid)<>"N"
	mid= 0
Endif
mFecModif = sp_busco_fecha_serv("DT")
mfecdia = TTOD(mFecModif )
Do Case
	Case nOpcion = 1  &&consulta datos
		mret = SQLExec(mcon1,"select * from ZabRegCtgAgenda " +;
			"where ZCA_REGISTRACION = ?mRegistracio and ZCA_ESTADO in (1,11,21) "+mcbusca,mcursor)

		If mret < 0

		Endif
		Select Distinct ZCA_REGISTRACION From &mcursor Into Cursor mwkcontrol
		If Reccount('mwkcontrol')>1
			Messagebox('error de lectura comuniquese con sistemas')
			Select * From  &mcursor Where 1=2 Into Cursor  &mcursor
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario

			Do sp_insert_tabCtrlErr With Transform(Reccount('mwkcontrol')), Transform(mRegistracio) , midusua,'TELECONSULTA'
		Endif
	Case nOpcion = 2  &&Agrega o borra Datos
		Select Distinct ZCA_REGISTRACION FROM mwkCtgAgenda Into Cursor mwkcontrol
		If Reccount('mwkcontrol')>1 AND mRegistracio<>666
			Messagebox('error de lectura comuniquese con sistemas')
			Select * From mwkCtgAgenda Where 1=2 Into Cursor mwkCtgAgenda
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario
			Do sp_insert_tabCtrlErr With Transform(Reccount('mwkcontrol')), Transform(mRegistracio) , midusua,'TELECONSULTA'
		Endif
		Select mwkCtgAgenda
		Go Top

		Scan All
			Do Case
				Case Inlist(mwkCtgAgenda.ZCA_estado , 1,11,21) And mwkCtgAgenda.Id = 0
					mFecha = mwkCtgAgenda.ZCA_Fecha
					mEstado = mwkCtgAgenda.ZCA_estado
					mFecModif = mwkCtgAgenda.ZCA_FECMODIF
**ZCA_REGISTRACION
					mObserv = Alltrim(mwkCtgAgenda.ZCA_OBSERV)

					mret = SQLExec(mcon1,"insert into ZabRegCtgAgenda (ZCA_Fecha,ZCA_FECMODIF,ZCA_REGISTRACION,ZCA_estado,ZCA_OBSERV) values (" +;
						"?mFecha,?mFecModif,?mRegistracio,?mEstado,?mObserv)")

				Case  mwkCtgAgenda.Id > 0

					mEstado = mwkCtgAgenda.ZCA_estado
					mFecModif = mwkCtgAgenda.ZCA_FECMODIF
					mid = mwkCtgAgenda.Id

					mret = SQLExec(mcon1,"update ZabRegCtgAgenda set userdbupd = ?mcidusu,FecHorDbUpd = CURRENT_TIMESTAMP, " +;
						"ZCA_FECMODIF=?mFecModif,ZCA_estado=?mEstado " +;
						"Where ID = ?mId")
			Endcase

			If mret<=0
				Messagebox("ERROR EN LA ACTUALIZACION DE AGENDA"+Chr(10)+"PACIENTE : " + Transform(mRegistracio),26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif

			Select mwkCtgAgenda
		Endscan

	Case nOpcion =3 &&consulta con busqueda
		mret = SQLExec(mcon1,"select * from ZabRegCtgAgenda " +;
			"where "+mcbusca,mcursor)

		If mret < 0

		Endif
	Case nOpcion = 4  &&cambia estado
		mret = SQLExec(mcon1,"update ZabRegCtgAgenda set userdbupd = ?mcidusu,FecHorDbUpd = CURRENT_TIMESTAMP," +;
			" ZCA_FECMODIF=?mFecModif,ZCA_estado=?mEstado " +Iif(Empty(mobserva),''," ,ZCA_OBSERV = ?mobserva ")+;
			" Where ID = ?mId")
		If mret<=0
			Messagebox("ERROR EN LA ACTUALIZACION DE AGENDA"+Chr(10)+"PACIENTE : " + Transform(mRegistracio),26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Case nOpcion = 5 &&consulta con busqueda y datos
		mret = SQLExec(mcon1,"SELECT Zabregctgagenda.id as idagen,ZCA_ESTADO, ZCA_FECHA, ZCA_OBSERV, ZCA_REGISTRACION, REG_nombrepac, REG_nroregistrac"+;
			", REG_nrohclinica, REG_fecnacimiento,REG_telefonos, REG_numdocumento,REG_email "+;
			" FROM Zabregctgagenda INNER JOIN Registracio  ON  ZCA_REGISTRACION = REG_nroregistrac "+;
			"where "+mcbusca,mcursor)

		If mret < 0

		ENDIF
	Case nOpcion = 6  &&consulta datos para agenda
		mret = SQLExec(mcon1,"select * from ZabRegCtgAgenda " +;
			"where ZCA_REGISTRACION = ?mRegistracio and ZCA_FECHA>= ?mfecdia  "+mcbusca,mcursor)

		If mret < 0

		Endif
		Select Distinct ZCA_REGISTRACION From &mcursor Into Cursor mwkcontrol
		If Reccount('mwkcontrol')>1
			Messagebox('error de lectura comuniquese con sistemas')
			Select * From  &mcursor Where 1=2 Into Cursor  &mcursor
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario

			Do sp_insert_tabCtrlErr With Transform(Reccount('mwkcontrol')), Transform(mRegistracio) , midusua,'TELECONSULTA'
		Endif		
Endcase



