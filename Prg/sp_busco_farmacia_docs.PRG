*
* Documentos emitidos x Farmacia Citostáticos
* mtipo (documentos de..) = 1 Etiquetas, = 2 Auditorias
*
Lparameters mdes, mhas, mpof, mtipo

mbusca = ""
If mtipo = 1 && Busca por POF
	If mpof > 0
		mlnrop = "POF"+transform(mpof,"@L 999999")
		mbusca = " where TFD_nropof = ?mlnrop"
	Endif
Else         && Busca por Partida
	If !empty(mpof)
		mbusca = " where TFD_partida = ?mpof"
	Endif
Endif

mf1 = ""
mf2 = ""
If mdes <> {//}
	mf1 = dtot(mdes)
	mf2 = dtot(mhas+1)
	If len(alltrim(mbusca))>0
		mbusca = mbusca + " and "
	Else
		mbusca = mbusca + " where "
	Endif
	mbusca = mbusca + "TFD_fecha >= ?mf1 and TFD_fecha < ?mf2"
Endif

Use in select("mwkdocs")

If mtipo = 1
	mret = sqlexec(mcon1,"select TFD_nropof,TEC_nombrepac,TFD_fecha,"+;
		"tabestados.descrip as ltipo, TabFarmDocs.id as lid, TFD_tipo "+;
		" from TabFarmDocs" +;
		" join TabFarmEtqCitos on TEC_nropof = TFD_nropof "+;
		" join TabEstados on estado = 3 and propietario = 31 and subestado = TFD_salida "+mbusca+;
		" order by TFD_nropof","mwkdocs")
Else
	mret = sqlexec(mcon1,"select TFD_partida,REGISTRACIO.REG_nombrepac,TFD_fecha,"+;
		"tabestados.descrip as ltipo, TabFarmDocs.id as lid, TFD_tipo "+;
		" from TabFarmDocs" +;
		" join TabFarmCitosP on TCP_partida = TabFarmDocs.TFD_partida "+;
 		" join REGISTRACIO on REG_nroregistrac = TabFarmCitosP.TCP_registracio "+;
		" join TabEstados on estado = 3 and propietario = 31 and subestado = TFD_salida "+mbusca+;
		" order by TFD_partida","mwkdocs")
Endif

If mret < 0
	Messagebox("EN BUSQUEDA DE DOCUMENTOS CITOSTATICOS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
