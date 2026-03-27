*
* Desbloqueo de HCE, busqueda en ambulatorio x nro.vale
*
Lparameters mbus

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

Use in select("mwkctrlhce")

mret = sqlexec(mcon1,"select id,codmed, codprest from tabambulatorio where nrovale=?mbus" + mccpoamb ,"mwkctrlhce")

If mret < 0
	Messagebox('EN CONSULTA DE VALE, MAESTRO AMBULATORIO'+chr(10)+;
		"AVISE A SISTEMAS", 16, 'ERROR')
Endif
IF RECCOUNT("mwkctrlhce")=0

mret = sqlexec(mcon1,"select id,codmed, codprest from tabambulatorioHIS tabambulatorio  where nrovale=?mbus" + mccpoamb ,"mwkctrlhce")
ENDIF
If mret < 0
	Messagebox('EN CONSULTA DE VALE, MAESTRO AMBULATORIO'+chr(10)+;
		"AVISE A SISTEMAS", 16, 'ERROR')
Endif