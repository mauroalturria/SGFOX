Lparameters tnCodEnt, tcTabla

If Vartype(tcTabla) # "C"
	tcTabla = "mwkEntWS"
Endif 

mRet = SQLExec(mcon1,"Select Ent_WS from Entidades Where Ent_CodEnt = ?tnCodEnt",tcTabla)

If mRet <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif
