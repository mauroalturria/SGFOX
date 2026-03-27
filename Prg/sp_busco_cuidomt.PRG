*
* Tablas anexas cuidados domiciliarios
*

Use In Select("mwkestpre")
mret = SQLExec(mcon1,"select descrip,subestado"+;
	" from tabestados where propietario=5 and estado=1 and tipo IN (0,1) order by subestado","mwkestpre")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Use In Select("mwkesteqp")
mret = SQLExec(mcon1,"select descrip,subestado"+;
	" from tabestados where propietario=5 and estado=2 and  tipo IN (0,1) order by subestado","mwkesteqp")

If mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS EQUIPOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
