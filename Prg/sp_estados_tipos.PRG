*
* Descripciones segun Tabestados por propietario y tipo // Para protocolos Quirurgicos Reporte
*
Lparameters mpropietario, mtipoin

mwhere2 = ""

If Vartype(mtipoin) = "C"
	mwhere2 = " and tipo in ("+ mtipoin + ")"
Endif

Use In Select("mwktipest")
mret = SQLExec(mcon1,"select * from tabestados where propietario = ?mpropietario" + mwhere2 ,"mwktipest")

If mret < 0
	mltabla = "TABESTADOS BUSQUEDA DE TIPOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
