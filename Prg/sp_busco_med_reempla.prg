Lparameters mfeclim, mfecreemp

mret = SQLExec(mcon1," SELECT ID , nombre, " + ;
	"gerenciadora , matricula,ambcentror,hhmmDesr,hhmmHasr " + ;
	"FROM TabMedExterno " + ;
	"where fechaIngreso >= ?mfeclim and " + ;
	"fechaIngreso <= ?mfecreemp and (ambcentror= ?mxcentromedico or ambcentror is null) " + ;
	" and not gerenciadora in ( 0,222,373) " ,"mwkmed02a")


If mret <= 0
	Messagebox("ERROR DE LECTURA DE MEDICO ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Else
	Select Id , nombre, gerenciadora , matricula,ambcentror,Nvl(hhmmDesr,0) As hhmmDesr,IIF(Nvl(hhmmHasr ,0)=0,2400,hhmmHasr ) As hhmmHasr ;
		FROM mwkmed02a Into Cursor mwkmed02
Endif
