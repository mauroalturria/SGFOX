*
* Desbloqueo de HCE, busqueda en ambulatorio x nro.vale
*
Lparameters mopc,mbus,nroregis
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif

Use In Select("mwkctrlhce")
If Vartype(mbus)="C" &&& protocolo
	mret = SQLExec(mcon1,"select * from tabambulatorio where nroregistrac = ?nroregis and  protocolo=?mbus" + mccpoamb ,"mwkctrlhce")
Else
	mret = SQLExec(mcon1,"select * from tabambulatorio where nroregistrac = ?nroregis and nrovale=?mbus" + mccpoamb ,"mwkctrlhce")
Endif
If mret < 0
	Messagebox('EN CONSULTA DE VALE, MAESTRO AMBULATORIO'+Chr(10)+;
		"AVISE A SISTEMAS", 16, 'ERROR')
Endif

Do Case
Case mopc= 1
	Return NVL(mwkctrlhce.diagnostico,SPACE(20))
Case mopc= 2
	Return NVL(mwkctrlhce.estado,0)
Case mopc= 3
	Return NVL(mwkctrlhce.fechahoraate,CTOT("01/01/1900"))
Endcase
