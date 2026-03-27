Lparameters mGrabDescrip,mGrabEstado,mGrabSubestado,mGrabTipo,mGrabModo,mGrabTab

**********
* Rutina *
* Grabar *
**********

* GrabDescrip = Graba descripción (Caracteres)
* GrabEstado = Graba estado (Numerico)
* Propietario = 84 (fijo)
* GrabTipo = Graba 1 = Sector - 2 = Detalle (Numerico)
* GrabModo = 1. INSERT - 2. DELETE (NO BORRAR) - 3. UPDATE (Numerico)
* GrabTab = 1. Tabla tabestados - 2. Tabla tabbeepers (Numerico)

mHoraServ = SP_BUSCO_FECHA_SERV("DT")
mHoraAlta = "1900-01-01"

mUsuario = mwkusuario.codigovax

sqlgraba = ""

Do Case

Case mGrabModo = 1 && INSERT nuevo registro

	If mGrabTab = 1

		sqlgraba = "INSERT INTO tabestados(descrip, estado, propietario, subestado, tipo) VALUES (?mGrabDescrip, ?mGrabEstado, 84, ?mGrabSubestado, ?mGrabTipo)"

	Endif

	If mGrabTab = 2


		sqlgraba = "UPDATE tabbeepers set BEE_PIN = ?mGrabDescrip, BEE_FecHPasiva = ?mHoraAlta, BEE_FecHAlta = ?mHoraServ, BEE_CodVaxAlta = ?mUsuario where BEE_Sector = ?mGrabSubestado"

	Endif

Case mGrabModo = 2 && DELETE


	If mGrabTab = 1

		sqlgraba = "UPDATE tabestados SET propietario = -84 WHERE ID = " + Alltrim(Str(mGrabEstado))

	Endif

	If mGrabTab = 2
	
		Messagebox(mUsuario)
		Messagebox(mHoraServ)
		Messagebox(mGrabEstado)
		
		sqlgraba = "UPDATE tabbeepers SET BEE_CodVaxPasiva = ?mUsuario, BEE_FecHPasiva = ?mHoraServ WHERE BEE_sector = ?mGrabEstado"

	Endif


Case mGrabModo = 3 && UPDATE modifico registro

	If mGrabTab = 1

		sqlgraba = "UPDATE tabestados SET descrip = ?mGrabDescrip WHERE ID = " + Alltrim(Str(mGrabEstado))

	Endif

	If mGrabTab = 2

		sqlgraba = "UPDATE tabbeepers SET BEE_Pin = ?mGrabDescrip WHERE bee_sector = ?mGrabEstado"

	Endif


Endcase


If mcon1=0
	Messagebox("Error de conexion, no graba datos",16,"Error")
	Return .F.
Else
	SQLExec(mcon1,sqlgraba)
Endif

Use In mwkfecserv

sqlgraba = ""


