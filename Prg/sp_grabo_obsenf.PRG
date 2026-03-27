*
* Observaciones Enfermeria - Varios
* Marcelo Torres, 28/11/2017
* Por compatibilidad, si viene en blanco mObs, verificamos que exista registro para el nro. de sector y blanqueamos.
* Desde ahora va con sector = 0 -> Todos los sectores agrupados.
*
Lparameters midevo, msector, mobs

Use In Select("mwkobsctrl")
 
muser  = mwkusuarios.idusuario
mfech  = sp_busco_fecha_serv("DT")
mfnull = Ctod("01/01/1900")
mcontrola = IIF(msector = 4," and OBS_sector = 4 ","and OBS_sector <> 4 ")
mret = SQLExec(mcon1,"select * from TabIntObsEnf"+;
	" where OBS_idevol = ?midevo and OBS_sector = ?msector and OBS_fecpasiva = ?mfnull " +mcontrola ,"mwkobsctrl")

If mret < 0
	mltabla = "OBSERVACIONES ENFERMERIA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkobsctrl")
	If Reccount("mwkobsctrl") > 0 AND msector#4

		mlid = mwkobsctrl.Id
		mret = SQLExec(mcon1,"update TabIntObsEnf set OBS_obser = ?mobs,"+;
			"OBS_fechor = ?mfech, OBS_usuario = ?muser where id = ?mlid and OBS_sector = ?msector and OBS_fecpasiva = ?mfnull")

	Else

		If !Empty(mobs)
			mret = SQLExec(mcon1,"insert into TabIntObsEnf"+;
				"(OBS_idevol, OBS_sector, OBS_obser, OBS_usuario, OBS_fechor, OBS_fecpasiva)"+;
				" values "+;
				"(?midevo, ?msector, ?mobs, ?muser, ?mfech, ?mfnull)")
		Endif

	Endif
Endif

Use In Select("mwkobsctrl")

If mret < 0
	mltabla = "ACTUALIZACION MAESTRO OBSERVACIONES ENFERMERIA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.

