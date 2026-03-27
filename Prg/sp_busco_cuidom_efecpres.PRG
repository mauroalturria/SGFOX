*
* Estadistico Efectores / Prestaciones
*
Lparameters mfec1, mfec2

If Vartype(mfec1) <> "D"
	mfec1 = sp_busco_fecha_serv('DD')
Endif

If Vartype(mfec2) <> "D"
	mfec2 = sp_busco_fecha_serv('DD')
Endif

mfnl = Ctod("01/01/1900")

Use In Select("mwkefector")

mret = SQLExec(mcon1,"select TDP_prestador,TDP_tipo"+;
	" From TabCuiDomPasig"+;
	" Join TabCuiDomSoli on TabCuiDomSoli.id = TabCuiDomPasig.TCA_idsolic"+;
	" and TCS_fecarga >= ?mfec1 and TCS_fecarga <= ?mfec2"+;
	" Join TabCuiDomProf on TabCuiDomProf.id = TabCuiDomPasig.TCA_idprofe"+;
	" Where TCA_pasivado = ?mfnl", "mwkefector")

If mret < 0
	MTABLA = "DETALLE DE EFECTORES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Use In Select("mwkprestac")

mret = SQLExec(mcon1,"select TabCuiDomPres.TCP_idsolic, TabEstados.descrip, TabEstados.subestado, TabCuiDomPres.TCP_cantidad"+;
	" from TabCuiDomPres"+;
	" join TabCuiDomSoli on TabCuiDomSoli.id = TabCuiDomPres.TCP_idsolic"+;
	" join TabEstados on TabEstados.Propietario = 5 and TabEstados.Estado = 1 and TabEstados.Tipo = 0"+;
	" and TabEstados.subestado = TabCuiDomPres.TCP_idprest"+;
	" Where TCP_pasivado = ?mfnl and"+;
	" (?mfec1 between TCP_desde and TCP_hasta) or"+;
	" (?mfec2 between TCP_desde and TCP_hasta) or"+;
	" (TCP_desde > ?mfec1 and TCP_hasta < ?mfec2)","mwkprestac")
	
*	and TCP_hasta >= ?mfec1","mwkprestac")
*   " Where TCP_pasivado = ?mfnl and TCP_desde >= ?mfec1 and TCP_hasta <= ?mfec2","mwkprestac")	

If mret < 0
	MTABLA = "PRESTACIONES REALIZADAS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
