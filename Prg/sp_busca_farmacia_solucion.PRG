*
* Soluciones x Reconstitucio / Dilucion
*
Lparameters mcodigo,mtipo,mbusca

If used('mwksolucion')
	Use in mwksolucion
Endif

If vartype(mbusca)<>"C"
	mwhere = "TFC_idbasecos=?mcodigo and TFC_tipo=?mtipo"
Else
	mwhere = "TFS_inscod in (" + mbusca + ") and TFC_tipo=?mtipo"+;
		" group by TFS_inscod"
Endif

mret = sqlexec(mcon1,"select TFC_inscod,TFS_codabrev,TFS_desc1,TFS_desc2,TFS_codabrev"+;
	" from TabFarmSoluc2"+;
	" join TabFarmSoluc on TFC_inscod=TFS_inscod"+;
	" where "+mwhere,"mwksolucion")


If mret < 0
	Messagebox("EN BUSQUEDA DE SOLUCIONES DE"+chr(10)+;
		"RECONSTITUCION / DILUCION",16,"ERROR")
Endif

