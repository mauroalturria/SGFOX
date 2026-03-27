*
* Busco Vales para las prescripciones
* Parametros : nro. de idevol, codigo de insumo, tipo, y fecha-hora de la ultima inicializacion.
*
Parameters midevol, midinsumo, mtipo, dTUltimaPres

mWhere = ""

If Vartype(dTUltimaPres) = "T"
	If Ttod(dTUltimaPres) <> {//}
*!*	    dTUltimaPres = DTOC((TTOD(dUltimaPres)) + " " + PADL(STR(HOUR(dUltimaPres)),2,"0")+"00:00"
*!*	    dTUltimaPres = CTOT(dTUltimaPres)
		mWhere = ' and IPV_fechormodif >= ?dTUltimaPres '
	Endif
Endif

Use In Select("mwkpresvale")
mret = SQLExec(mcon1,"select Top 1 * from TabIntPmVales"+;
	" where IPV_idevol = ?midevol and IPV_idreginsumo = ?midinsumo and IPV_instipo = ?mtipo " + mWhere + "Order by Id desc","mwkpresvale")

If mret < 0
	mltabla = "CONTROL DE VALES, PRESCRIPCION MEDICA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
