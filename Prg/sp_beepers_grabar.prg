Parameters mcSector, mcDescrip, mcPin, mnIdSector, mnIdDescrip, mnOpcion, mGrabEstado, mGrabSubestado, mGrabTipo

mHoraServ = SP_BUSCO_FECHA_SERV("DT")
mHoraAlta = "1900-01-01"
mUsuario = mwkusuario.codigovax
sqlgraba = ""


Do Case

Case mnOpcion = 1 && Inserto registro en descrip y pin

	sqlgraba = "INSERT INTO tabestados(descrip, estado, propietario, subestado, tipo) VALUES (?mcDescrip, ?mGrabEstado, 84, ?mGrabSubestado, ?mGrabTipo)"

	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif

	sqlgraba = "Select id From tabestados Where propietario = 84 And tipo = 2 And estado = ?mGrabEstado And subestado = ?mGrabSubestado"

	If mcon1=0
		Messagebox("Error de conexion en consulta",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba,"mwkTempRec")
	Endif

	Select mwkTempRec


	sqlgraba = "insert into tabbeepers(BEE_PIN, BEE_Sector, BEE_FecHPasiva, BEE_FecHAlta, BEE_CodVaxAlta) values (?mcPin, ?mwkTempRec.id, ?mHoraAlta, ?mHoraServ, ?mUsuario)"

	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif

	Return (mret > 0)

Case mnOpcion = 2 && Borro Registros

	sqlgraba = "UPDATE tabestados SET propietario = -84 WHERE ID = ?mnIdDescrip"
	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif

	sqlgraba = "UPDATE tabbeepers SET BEE_CodVaxPasiva = ?mUsuario, BEE_FecHPasiva = ?mHoraServ WHERE BEE_sector = ?mnIdDescrip"
	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif

Case mnOpcion = 3 && Edito Nombres

	sqlgraba = "UPDATE tabestados SET descrip = ?mcDescrip WHERE ID = ?mnIdDescrip"
	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif



	sqlgraba = "UPDATE tabbeepers SET BEE_Pin = ?mcPin WHERE bee_sector = ?mnIdDescrip"
	If mcon1=0
		Messagebox("Error de conexion, no graba datos",16,"Error")
		Return .F.
	Else
		mret = SQLExec(mcon1,sqlgraba)
	Endif


Endcase


