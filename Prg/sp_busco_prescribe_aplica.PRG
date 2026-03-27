*
* Consultar insumos de una solucion ya aplicada
*
Lparameters mguia, mbaxter, midevol

mfnull  = Ctod("01/01/1900")

Use In Select("mwkdetagre")

mret = SQLExec(mcon1,"select INS_descriinsumo, PA_cantpres from TabIntPmAgre "+;
	" join insumos on INS_codinsumo = TabIntPmAgre.PA_insumo"+;
	" where PA_idevol = ?midevol"+;
	" and PA_fecpasiva = ?mfnull"+;
	" and PA_guia = ?mguia"+;
	" and PA_baxter = ?mbaxter","mwkdetagre")

If mret < 0
	mltabla = "PRESCRIPCION AGREGADOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
