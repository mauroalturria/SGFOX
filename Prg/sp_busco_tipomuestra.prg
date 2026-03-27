LPARAMETERS cWhere,cTabla

IF VARTYPE(cWhere) <> "C"
   cWhere = ""
ELSE
   IF !EMPTY(cWhere)
      cWhere = " where " + ALLTRIM(cWhere)
   ENDIF 
ENDIF 

IF VARTYPE(cTabla) <> "C" OR EMPTY(cTabla)
   cTabla = "mwktipomuestra"
ENDIF 

use in SELECT(cTabla)

mret = SQLEXEC(mcon1,"select * from tabbacteriotipomuestra " + cWhere,cTabla)

If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE TIPOS DE MUESTRA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
Endif