*
* Busqueda de Prestaciones por ID de solicitud
*
Lparameters mbusid

mfnull = Ctod("01/01/1900")
Use In Select("mwkpressol")

mret = SQLExec(mcon1,"select TabEstados.descrip as lprestacion, TCP_otrapre as lotrapres, subestado"+;
	" From TabCuiDomPres"+;
	" Join TabEstados on propietario=5 and estado=1 and tipo=0 and subestado=TabCuiDomPres.TCP_idprest"+;
	" Where TabCuiDomPres.TCP_idsolic=?mbusid and TabCuiDomPres.TCP_pasivado=?mfnull","mwkpressol")

If mret < 0
	MTABLA = "C.D. PRESTACIONES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
