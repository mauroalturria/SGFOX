*
* Busqueda de POF Etiqueta Citostaticos ya dispensada
*
Lparameters mnropof

Use In Select("mwkctrlpof")
mret = SQLExec(mcon1,"select * from TabTraLogDis where TLD_nropof = ?mnropof","mwkctrlpof")

If mret < 0
	MTABLA = "LOG DISPENSA/TRAZABILIDAD HDO"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
