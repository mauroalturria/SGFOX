*!*	--------------------------------------------------------------------------
*!*	Actualizacion TabAmbulatorio
*!*		CodEstado 
*!*		fechahoraate 
*!*	--------------------------------------------------------------------------
Lparameters lnId, lcProtocolo, ltHora, lnEstado, lcWhere

If Vartype(lcWhere) # "C"
	lcWhere = ""
Endif 	

mret = SQLExec(mcon1, "update TabAmbulatorio set " + ;
	"codestado = ?lnEstado, " + ;
	"fechahoraate = ?ltHora " + ;
	"where protocolo = ?lcProtocolo and id = ?lnId " + lcWhere)

If mret <= 0
	Messagebox("ERROR DE ACTUALIZACION DE ESTADO - AMB ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif