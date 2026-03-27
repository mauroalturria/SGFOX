*
* Traemos sectores - Medicina Laboral
*

mret  = SQLEXEC(mcon1,"select * from Personal.sectores ","Mwksectores")

If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE TABLA SECTORES",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Return .T.
ENDIF