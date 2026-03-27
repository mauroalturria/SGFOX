*****
* grabo el cierre de guardia de aceurdo a parametros
****
lparameters mprotocolo,mcodestado,mcodmedcie9,mcodCIE9
mret = sqlexec(mcon1, "update guardia set codcie9 = ?mcodCIE9, " + ;
	"codestado = ?mcodestado, codmedcie9 = ?mcodmedcie9 " + ;
	" where protocolo = ?mprotocolo ")
if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif