*
* Consulta de Caja p/H.C.
*

Parameters mdigito

mret = sqlexec(mcon1, "select id,caja,digito from TabHcicajas"+;
	" where caja=(select max(caja) from TabHcicajas where digito=?mdigito)"+;
	" and digito=?mdigito","mwkCajaMax")

If mret < 0
*	=aerror(merror)
*	messagebox(merror(3))	
	Messagebox("EN CONSULTA DE CAJA PARA LA H.C."+chr(10)+;
	"AVISE A SISTEMAS", 16, "ERROR")
Endif
