Lparameters minsumo

Local mval

mval = "N"

mbusca = Alltrim(minsumo)

Use In Select("mwkEtkardex")
mves = 0
Do While .T.
	mves = mves + 1
	If mves = 3
		Exit
	Endif
	mret = SQLExec(mcon1,"SELECT * FROM Grifols.MERCURIO_STOCKS WHERE CODART = ?mbusca and EXTERNO = 'S' ", "mwkEtkardex")
	If mret < 0
		=Aerr(eros)
		mmsgerr = eros(3)
		mdetalle= "Error en consulta, maestro Grifols.MERCURIO_STOCKS - externo_kardex"
		Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "externo_kardex"

		Messagebox("EN LA CONSULTA GRIFOLS MAESTRO DE INSUMOS - EXTERNOS", 48, "ERROR - FAVOR DE AVISAR A SISTEMAS")

	Else
		If Used("mwkEtkardex")
			If Reccount("mwkEtkardex")>0
				mval = "S"
			Endif
		Endif
		Exit
	Endif
Enddo
Use In Select("mwkEtkardex")

Return mval
