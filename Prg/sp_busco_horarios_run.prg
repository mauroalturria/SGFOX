lParameters tcWhere, tcCursor

mRet = Sqlexec(mcon1,"Select * " + ;
	"from TabHorarios " + ;
	"" + tcWhere + " " + ;
	"" , tcCursor )

if mRet <= 0
	Messagebox("ERROR DE LECTURA" ,16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
