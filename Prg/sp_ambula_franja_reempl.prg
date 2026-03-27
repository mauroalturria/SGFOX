*
* Busqueda de Franjas medicos reemplazantes
*
Lparameters mcodmed, mlhor

If used('mwkcfranja')
	Use in mwkcfranja
Endif

mret = sqlexec(mcon1,"select * from TabPreregMed "+;
	"where codmedreem=?mcodmed and fecalta=?mlhor"+;
	" and dambula = 1 ","mwkcfranja")

If mret < 1
	=aerror(merror)
	Messagebox("EN CONSULTA DE FRANJAS, MEDICOS REEMPLAZANTES"+chr(10)+;
		alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
