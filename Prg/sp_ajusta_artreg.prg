*
* Ajusta fecha finalizacion ART REGISTRO
*
Lparameters mlid, mlfecha

mret = SQLExec(mcon1,"update TabArtReg set TAR_finpro = ?mlfecha where id = ?mlid")

If mret < 0
	mltabla = "ART REGISTRO FINALIZA"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
