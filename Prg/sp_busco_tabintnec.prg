Lparameters tnidevol,  tcCursor

If Vartype(tcWhere) # "C" 
	tcWhere = ""
Endif 	

If Vartype(tcCursor) # "C" 
	tcCursor = "mwkNecesPac"
Endif 	

mfecNull = Ctod("01/01/1900")

mRet = Sqlexec(mcon1,"Select " + ;
	"tabusuario.nomape AS NOMBRE, " + ;
	"TabIntNeces.*  " + ;
	"from TabIntNeces " + ;
	"Left Join tabusuario on TabIntNeces.EINN_usuario= tabusuario.Id " + ;
	"Inner join TabIntNecCui on TabIntNecCui.Id = TabIntNeces.EINN_idnecesidad " + ;
	"where EINN_idevol = ?tnidevol " + tcWhere , tcCursor)

If mRet <= 0

	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 