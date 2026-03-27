*sp_grabo_beepers2

Parameters mOpcion, mDescrip, mID, mPIN, mNombre

If !Empty(mDescrip)
	mDescrip = Upper(mDescrip)
Endif

Do sp_conexion

mFecha = sp_busco_fecha_serv('DT') && Busco Fecha Servidor

Do Case

Case mOpcion = 1 && Inserto un Nuevo Sector

	lcSQL = "select * from tabestados where propietario = 84 and tipo = 1 order by estado"

* Valido que no esté repetido el sector
	Select mwkestados
	Go Top
	Locate For Upper(mwkestados.Descrip) = Upper(mDescrip)
	If Found()
		Messagebox("El nombre del sector ya se encuentra ingresado.",0,"Nuevo Sector...")
		Return .F.
	Endif

	If !Messagebox("Desea agregar el nuevo sector ?",4,"Nuevo Sector...") = 6
		Return .F.
	Endif


	Select * From mwkestados Where propietario = 84 And tipo = 1 Order By estado Into Cursor mwkestados_temp Readwrite

	Select mwkestados_temp
	Go Bottom
	mEstado = mwkestados_temp.estado + 1

	lcSQL = "insert into tabestados (descrip,estado,propietario,subestado,tipo) "+;
		"values (?mDescrip,?mEstado,84,?mEstado,1)"

	SQLExec(mcon1,lcSQL)

	Use In mwkestados_temp

Case mOpcion = 2 && Pasivo el Sector (Baja = -84 al propietario)

	If !Messagebox("Desea eliminar el sector seleccionado ?",4,"Eliminar Sector...") = 6
		Return .F.
	Endif

	lcSQL = "Update tabestados Set propietario = -84 Where id = ?mID"

	SQLExec(mcon1,lcSQL)

Case mOpcion = 3 && Edito el Sector

* Valido que no esté repetido el sector
	Select mwkestados
	Go Top
	Locate For Upper(mwkestados.Descrip) = Upper(mDescrip)
	If Found()
		Messagebox("El nombre del sector ya se encuentra ingresado.",0,"Modificar Sector...")
		Return .F.
	Endif

	If !Messagebox("Desea modificar el nombre del sector existente ?",4,"Modificar Sector...") = 6
		Return .F.
	Endif

	lcSQL = "Update tabestados Set Descrip = ?mDescrip Where id = ?mID"

	SQLExec(mcon1,lcSQL)

Case mOpcion = 4 && Agrego Descripción Nueva al Sector

	If Empty(mDescrip)
		Messagebox("Debe completar la descripción del sector",0,"Nueva Descripción")
		Return .F.
	Else
		mDescrip = Upper(mDescrip)
	Endif


* Valido que no esté repetida la descripción
	Select mwkareas
	Go Top
	Locate For Upper(mwkareas.Descrip) = Upper(mDescrip)
	If Found()
		Messagebox("La descripción ya se encuentra ingresada.",0,"Nueva Descripción...")
		Return .F.
	Endif

* Valido que no esté repetido el pin y que no esté vacío

	If Empty(mPIN)
		Messagebox("Debe completar el número de PIN para esta descripción",0,"Nueva Descripción...")
		Return .F.
	Endif

	If Vartype(mPIN)="C"
		mPINlen = Len(Alltrim(mPIN))
	Else
		mPINlen = Len(Alltrim(Str(mPIN)))
	Endif

	If !mPINlen=7
		Messagebox("El número de PIN debe ser de 7 dígitos",0,"Nueva Descripción...")
		Return .F.
	Endif

	If Vartype(mPIN)="C"
		mPIN = Val(Alltrim(mPIN))
	Endif


*	Select mwkareas
*	Go Top
*	Locate For mwkareas.bee_pin = mPIN
*	If Found()
*		Messagebox("El PIN ya está siendo utilizado. Cambie el número.",0,"Nueva Descripción...")
*		Return .F.
*	Endif

	Select * From mwkbeepers Where bee_fechpasiva = Ctod('01-01-1900') And bee_pin = mPIN Into Cursor mwkbeepers_temp
	If Reccount("mwkbeepers_temp")>0
		Messagebox("El PIN ya está siendo utilizado. Cambie el número.",0,"Nueva Descripción...")
		Use In Select("mwkbeepers_temp")
		Return .F.
	Else
		Use In Select("mwkbeepers_temp")
	Endif


	If !Messagebox("Desea ingresar una nueva descripción para éste sector ?",4,"Nueva Descripción...") = 6
		Return .F.
	Endif

	Select * From mwkareas Order By subestado Into Cursor mwkareas_temp Readwrite
	Go Bottom
*	mEstado = mwkareas.estado
	mEstado = mwkSectores1.estado
	If Empty(mwkareas.subestado) Or Isnull(mwkareas.subestado)
		mSubEstado = 0
	Endif
	mSubEstado = mwkareas_temp.subestado + 1
	Use In mwkareas_temp


	lcSQL = "insert into tabestados (descrip,estado,propietario,subestado,tipo) values " +;
		"(?mDescrip,?mEstado,84,?mSubEstado,2)"

	SQLExec(mcon1,lcSQL)

* Busco ID de TabEstados para guardarlo en Bee_Sector

	lcSQL = "select * from tabestados where propietario = 84 and tipo = 2 and estado = ?mEstado and subestado = ?mSubEstado"
	SQLExec(mcon1,lcSQL,"mwkEstados_temp")

	Select mwkestados_temp

	If Reccount("mwkEstados_temp")>0
		mEstadoID = mwkestados_temp.Id
	Else
* No trajo nada
	Endif

	mUsuario = mwkusuario.codigovax

	lcSQL = "insert into tabbeepers (bee_sector,bee_pin,bee_fechpasiva,bee_fechalta,bee_codvaxalta) values (?mEstadoID,?mPIN,'1900-01-01',?mFecha,?mUsuario)"
	SQLExec(mcon1,lcSQL)

Case mOpcion = 5 && Elimino (Pasivo)

	If !Messagebox("Desea dar de baja ésta descripción para éste sector ?",4,"Eliminar Descripción...") = 6
		Return .F.
	Endif

	lcSQL = "Update tabestados Set propietario = -84 Where id = ?mID"

	SQLExec(mcon1,lcSQL)

	mUsuario = mwkusuario.codigovax
	lcSQL = "Update tabbeepers Set bee_fechpasiva = ?mFecha, bee_codvaxbaja = ?mUsuario where bee_sector = ?mID"

	SQLExec(mcon1,lcSQL)

Case mOpcion = 6 && Modifico Descripción / PIN

	If Empty(mDescrip)
		Messagebox("Debe completar la descripción del sector",0,"Modificar Descripción...")
		Return .F.
	Else
		mDescrip = Upper(mDescrip)
	Endif


* Valido que no esté repetida la descripción
	Select mwkareas
	Go Top
	Locate For Upper(mwkareas.Descrip) = Upper(mDescrip)
	If Found()
		If !Messagebox("La descripción ya se encuentra ingresada. Desea Modificarla ?",4,"Modificar Descripción...") = 6
			Return .F.
		Endif
	Endif

* Valido que no esté repetido el pin y que no esté vacío

	If Empty(mPIN)
		Messagebox("Debe completar el número de PIN para esta descripción",0,"Modificar Descripción...")
		Return .F.
	Endif

	If Vartype(mPIN)="C"
		mPINlen = Len(Alltrim(mPIN))
	Else
		mPINlen = Len(Alltrim(Str(mPIN)))
	Endif

	If !mPINlen=7
		Messagebox("El número de PIN debe ser de 7 dígitos",0,"Modificar Descripción...")
		Return .F.
	Endif

	If Vartype(mPIN)="C"
		mPIN = Val(Alltrim(mPIN))
	Endif

*!*		Select mwkareas
*!*		Go Top
*!*		Locate For mwkareas.bee_pin = mPIN
*!*		If Found()
*!*			If !Messagebox("El PIN ya está siendo utilizado. Lo Modifica ?",4,"Modificar Descripción...") = 6
*!*				Return .F.
*!*			Endif
*!*		Endif

	Select * From mwkbeepers Where bee_fechpasiva = Ctod('01-01-1900') And bee_pin = mPIN Into Cursor mwkbeepers_temp
	If Reccount("mwkbeepers_temp")>0
		If !Messagebox("El PIN ya está siendo utilizado. Lo Modifica ?",4,"Modificar Descripción...") = 6
		Use In Select("mwkbeepers_temp")
		Return .F.
		endif
	Else
		Use In Select("mwkbeepers_temp")
	Endif

	If !Messagebox("Desea Modificar ésta descripción/PIN para éste sector ?",4,"Modificar Descripción...") = 6
		Return .F.
	Endif

	lcSQL = "Update tabestados Set descrip=?mDescrip Where id = ?mID"

	SQLExec(mcon1,lcSQL)

	mUsuario = mwkusuario.codigovax
	lcSQL = "Update tabbeepers Set bee_fechalta = ?mFecha, bee_codvaxalta = ?mUsuario, bee_pin = ?mPIN where bee_sector = ?mID"

	SQLExec(mcon1,lcSQL)

Endcase

Do sp_desconexion With mNombre
