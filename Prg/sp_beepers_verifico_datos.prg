Lparameters mcSector, mcDescrip, mcPin, mnIdSector, mnIdDescrip, mnOpcion

Do case

Case mnOpcion = 1 && Verifico Sector


If Empty(mcSector)

	Messagebox("Por favor, ingrese un texto",48,"Beepers - Alta de Sector")
	Return .F.

Else

	Select mwkcbosector
	Go Top

	Scan All
		If Upper(mwkcbosector.Descrip) = Upper(mcSector)
			Messagebox("El nombre ya existe.",16,"Beepers - Alta de Sector")
			Return .F.
		Endif
	Endscan

*Busco Nº estado

	Select mwkcbosector
	Go Bottom

	nIDultimo = mwkcbosector.estado
	mpaso = .T.

	Do While .T.
		If Used("mwkestadoId")
			Use In Select("mwkestadoId")
		Endif

		nIDultimo = nIDultimo + 1
		consql_estado = "SELECT estado FROM tabestados WHERE propietario = 84 AND tipo = 1 and estado = ?nIDultimo"

		If !prg_ejecutosql(consql_estado, "mwkestadoId")
			mpaso = .F.
			Exit
		Endif

		If Used("mwkestadoId")
			If Reccount("mwkestadoId") = 0
				Exit
			Endif
		Endif
	Enddo
	Use In Select("mwkestadoId")

	If !mpaso
		Messagebox("EN BUSQUEDA DE IDENTIFICADOR DEL SECTOR",48,"ERROR")
		Return
	Endif

Endif
Return nIDUltimo

Endcase
