*
* Busca prestaciones realizadas - cantidades + valor - por Profesional
*
Lparameters mlid, mfec, mpasivo

mwhere = ""

If mpasivo = 0 && Ver solo Activos
	mfecnu = Ctod("01/01/1900")
	mwhere = " and TPR_pasivado = ?mfecnu "
Endif

Use In Select("mwkpreval")

mret = SQLExec(mcon1,"select TPR_feccar as fecha,"+;
	" TPR_tipopre as prestac, TPR_cantidad as cantidad,"+;
	" TPR_valor as valor, id as lid, TPR_pasivado"+;
	" from TabCuiDomPreRea"+;
	" where TPR_idprestad = ?mlid and TPR_feccar >= ?mfec" + mwhere +;
	" order by TPR_feccar", "mwkpreval")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS, PRESTACIONES REALIZADAS VALORES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif


Select fecha, prestac, cantidad, valor, lid,;
	IIF(TPR_pasivado <> Ctod("01/01/1900"), TPR_pasivado, {//}) As TPR_pasivado;
	FROM mwkpreval;
	INTO Cursor mwkpreval

Return .T.

