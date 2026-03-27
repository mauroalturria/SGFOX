*
* Busqueda de firmantes
*
Lparameters mlid, mtipo
** tipo 4 
If vartype(mtipo) <> "N"
	mtipo = 4
Endif

mfechaa = sp_busco_fecha_serv("DD")

Use in select("mwkUsufirma")

mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,matriculas"+;
	" from TabUsuarioFirma"+;
	" join TabUsuario on codigovax = TUF_codigovax "+;
	" join Tabautprevlog on APL_IdAutPrev = ?mlid "+;
	" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed "+;
	" where TUF_fecpasiva >= ?mfechaa and TUF_tipo = ?mtipo and Tabautprevlog.APL_Operador = TabUsuario.codigovax "+;
	" order by Tabautprevlog.id","mwkUsufirma")
If mret < 0
	Messagebox("CONSULTA DE FIRMANTES"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

If used("mwkUsufirma")

	If reccount("mwkUsufirma") = 0 and mtipo # 4

		mlccvax = 52156 && Dr. Morgulis

		mret = sqlexec(mcon1,"select TUF_firmante,TUF_puesto,TUF_codigovax,nombre,matriculas"+;
			" from TabUsuarioFirma"+;
			" join TabUsuario on codigovax = ?mlccvax"+;
			" join PRESTADORES on PRESTADORES.id = TabUsuario.IDCodMed"+;
			" where TUF_fecpasiva >= ?mfechaa and TUF_tipo = ?mtipo","mwkUsufirma")

		If mret < 0
			Messagebox("CONSULTA DE FIRMANTES"+chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores with error(), message(), message(1), program(), lineno()
			Return .F.
		Endif

	Endif
Endif

Return .T.
