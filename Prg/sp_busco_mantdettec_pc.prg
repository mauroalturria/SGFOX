*
* Estadísticos panel de control
*
Lparameters mdesde, mhasta, momite

mwhere = ""
If momite = 1 && No contempla anuladas
	mwhere = " and estado <> 3 "
Endif

Use in select("mwkMantdetTecnico")

mret = sqlexec(mcon1,"select tabmantenimiento.*,tabMantDetTecn.idTecnico as ltid from tabmantenimiento"+;
	" left join tabMantDetTecn on idOt = tabmantenimiento.id"+;
	" where fechasolicusu >= ?mdesde and fechasolicusu <= ?mhasta" + mwhere,"mwkMantdetTecnico")

If mret < 0
	Messagebox("EN BUSQUEDA DE ORDENES DE TRABAJO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.

