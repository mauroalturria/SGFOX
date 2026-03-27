*
* CD Indicaciones Insumos
*
Lparameters mlidcd

mfnull = Ctod("01/01/1900")

Use In Select("mwkcuidomInd")
mret = SQLExec(mcon1,"select * "+;
	" from TabCuiDomIndi "+;
	" Where TCI_idsolic = ?mlidcd And TCI_pasivado = ?mfnull","mwkcuidomInd")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS INDICACIONES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
