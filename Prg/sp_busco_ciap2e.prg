***********
*	Leo tabla CIAP2E con y sin sinonimos	
* Sp_Busco_ciap2e
**********
lparameters lsinsino
mdato = ""
if vartype(lsinsino)#"N"
	mdato = ",Sinonimos "
endif
mfecnul = CTOD("01/01/1900")
mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
	"DescrAbrev , Descripcion , Excluye , Incluye,fecanula "+mdato+;
	" from  TabCiap2E where fecanula = ?mfecnul ", "mwkTCiapCom2")  


If mret < 0
	=Aerror(eros)
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
Endif
