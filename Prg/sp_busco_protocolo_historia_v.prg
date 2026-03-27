*****
** Busco Protocolo - Historia de Vales - Consumos
****

parameter mprotocolo


mret = sqlexec(mcon1, "select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
	"nombre, diagnostico, codestado, pre_descriprest, codcie9, guardia.codmed, codmedcie9 " + ;
	"from guardia, prestacions, registracio, prestadores " + ;
	"where guardia.protocolo = ?mprotocolo and " + ;
	"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
	"guardia.codmed			= prestadores.id and " + ;
	"guardia.codprest		= prestacions.pre_codprest and " + ;
	"guardia.codestado 		<> 0" , "mwkveoproto")
if reccount("mwkveoproto") = 0
	mret = sqlexec(mcon1, "select guardia.id, protocolo, REG_nombrepac, fechahoraing, fechahoraate, " + ;
		"nombre, diagnostico, codestado, pre_descriprest, codcie9, guardia.codmed, codmedcie9 " + ;
		"from guardia, prestacions, registracio, TabMedExterno " + ;
		"where guardia.protocolo = ?mprotocolo and " + ;
		"guardia.nroregistrac	= registracio.REG_nroregistrac and " + ;
		"guardia.codmed			= TabMedExterno.id and " + ;
		"guardia.codprest		= prestacions.pre_codprest and " + ;
		"guardia.codestado 		<> 0" , "mwkveoproto")
endif	
	


mret = sqlexec(mcon1, "select nrovale, ser_descripserv from guardiavale, servicios " + ;
	"where codserv  = ser_codserv and " + ;
	"codserv		<> 5410 and " + ;
	"protocolo 		= ?mprotocolo order by nrosec", "mwkvales")


mret = sqlexec(mcon1, "select nrovale, ser_descripserv from guardiavale, servicios " + ;
	"where codserv  = ser_codserv and " + ;
	"codserv		= 5410 and " + ;
	"protocolo 		= ?mprotocolo order by nrosec", "mwkvalins")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
	DO sp_desconexion WITH "Err sp_busco_protocolo_historia"
	cancel
endif
