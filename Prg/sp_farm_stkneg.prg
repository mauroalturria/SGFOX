*
* Inicialización insumos con Stk Negativo
*
Use in select("mwkinsumo")
mlcid = mwkfaraudit.lcid
mret  = sqlexec(mcon1, "select * from TabFarmCitosI where id = ?mlcid and TCI_fechapasiva is null","mwkinsumo" )
If mret < 0
	Messagebox("EN CONSULTA AUDITORIA DE MEDICAMENTOS CITOSTATICOS,"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Else
	mltot = mwkinsumo.TCI_total
	mret  = sqlexec(mcon1,"update TabFarmCitosI"+;
		" set TCI_resto = 0, TCI_devolucion = 0, TCI_utilizado = ?mltot where id = ?mlcid")
	If mret < 0
		Messagebox("EN ACTUALIZACION AUDITORIA DE MEDICAMENTOS CITOSTATICOS,"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Else
		mparti   = mwkfaraudit.TCI_partida
		mcodigo  = mwkfaraudit.TCI_codinsumo
		mtotals  = mwkfaraudit.TCI_resto * -1
		mvenc    = mwkfaraudit.TCI_fvence
		mlote    = mwkfaraudit.TCI_lote
		mmotivo2 = 'INICIALIZA STOCK NEGATIVO '+left(alltrim(mwkfaraudit.TCI_nombre),17)
		mtipo    = 'ITEM'
		Do sp_grabo_farmacia_log with mparti,mcodigo,mtotals,mmotivo2,mtipo,,,mvenc,mlote
	Endif
Endif
Use in select("mwkinsumo")
Return .T.
