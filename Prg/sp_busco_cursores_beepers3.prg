* Beepers (Conexiones - Cursores)
Lparameters mOpcion,mNombre

If !Vartype(mOpcion) = "N"
	Messagebox("Error al buscar datos",0,"Error Nº1")
	Return .F.
Endif

If !Vartype(mNombre) = "C"
	Messagebox("Error al buscar datos",0,"Error Nº2")
	Return .F.
Endif

Do Case

Case mOpcion = 1 && Busco Cursores mwkCboSector - mwkTabEstadosMain - mwkTabBeepersMain

	Do sp_conexion
	Do sp_busco_estados With 84,"and tipo = 1 order by descrip","mwkcbosector"
	Do sp_busco_estados With 84,"","mwktabestadosMain"

	misqlb = "select * from tabbeepers"
	If !prg_ejecutosql(misqlb,"mwkTabBeepersMain")
		Return .F.
	Endif

	Do sp_desconexion With mNombre

Case mOpcion = 2 && Busco mwkSectores1 - mwkEstados - mwkBeepers
	Do sp_conexion
	lcSQL = "Select * From tabestados Where propietario = 84 And tipo = 1"
	If !prg_ejecutosql(lcSQL,"mwkSectores1")
		Return .F.
	Endif

	lcSQL = "Select * From tabestados Where propietario = 84"
	If !prg_ejecutosql(lcSQL,"mwkEstados")
		Return .F.
	Endif

	lcSQL = "Select * From tabBeepers Where Bee_fechpasiva = '1900-01-01 00:00:0'"
	If !prg_ejecutosql(lcSQL,"mwkBeepers")
		Return .F.
	Endif
	Do sp_desconexion With mNombre

Endcase

