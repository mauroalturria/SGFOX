Lparameters lcForm, lcTabla
*-------------------------------------------------------
mRet = Sqlexec(mcon1,"Select * from TabLogFT Where " + ;
	"LTF_form = ?lcForm and LTF_tabla = ?lcTabla","mwkqlog")
If mret <= 0
	=Aerror(EROS)
*!*		?EROS(3)
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif 	
