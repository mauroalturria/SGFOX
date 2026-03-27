*
* Busqueda de vias de Administracion x ID de Principio Activo Base de Conocimiento
*

Lparameters mbusid, mtipo

If vartype(mtipo)#"N"
	mtipo = 1
Endif

If used('mwkvias')
	Use in mwkvias
Endif

If mtipo = 1
	mret = sqlexec(mcon1,"select TFV_viades,TFV_viacod from TabFarmViaAdm"+;
		" join TabFarmViaAdm2 on TVA_idbasecos=?mbusid"+;
		" and TVA_idviadmin=TabFarmViaAdm.id","mwkvias")
Else
	mret = sqlexec(mcon1,"select TabFarmViaAdm.id as lid from TabFarmViaAdm"+;
		" where TFV_viacod = ?mbusid","mwkvias")
Endif

If mret < 0
	Messagebox("EN BUSQUEDA DE VIAS DE ADMINISTRACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
