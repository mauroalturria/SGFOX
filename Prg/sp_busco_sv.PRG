Parameters tcProto

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mRet = SQLExec(mcon1,"SELECT Top 1 TabAmbEvolNurse.* " + ;
	"FROM TabAmbEvolNurse " + ;
	"Left join TabAmbulatorio on TabAmbulatorio.Protocolo = TabAmbEvolNurse.EAN_proto " + ;
	"Where EAN_Proto = ?tcProto " + mccpoamb + ;
	"Order by Ean_fechaH desc", "mwkENur")

If mRet <= 0
	Messagebox("ERROR DE LECTURA DE SIGNOS VITALES",48,"VALIDACION")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif