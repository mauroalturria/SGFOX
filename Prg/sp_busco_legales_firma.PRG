*
* Busqueda de firmantes
*
Lparameters mlid, mtipo

If vartype(mtipo) <> "N"
	mtipo = 1
Endif

mfecha = sp_busco_fecha_serv("DD")

Use in select("mwklegfirma")

mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,TLL_fecmov,matriculas"+;
	" from TabUsuarioFirma"+;
	" join TabUsuario on codigovax = TUF_codigovax"+;
	" join TabLGHceLog on TLL_idhce=?mlid and TabLGHceLog.TLL_idusuario=TabUsuario.idusuario and TLL_estado=3"+;
	" join TabEstados on propietario=37 and estado=8 and subestado=TLL_estado"+;
	" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed "+;
	" where TUF_fecpasiva >= ?mfecha and TUF_tipo = ?mtipo"+;
	" order by TLL_fecmov","mwklegfirma")

If mret < 0
	Messagebox("CONSULTA DE HCE LEGALES FIRMANTES"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

If used("mwklegfirma")

	If reccount("mwklegfirma") = 0

		mlccvax = 52156 && Dr. Morgulis

		mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,matriculas"+;
			" from TabUsuarioFirma"+;
			" join TabUsuario on codigovax = ?mlccvax"+;
			" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed"+;
			" where TUF_fecpasiva >= ?mfecha and TUF_tipo = ?mtipo","mwklegfirma")

		If mret < 0
			Messagebox("CONSULTA DE HCE LEGALES FIRMANTES"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores with error(), message(), message(1), program(), lineno()
			Return .F.
		Endif

	Endif
Endif

Return .T.
