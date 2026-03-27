****
** Actualizo nro de registracio en turnos
***

parameter nroregistra, newregistra, mcodent

mret = SQLExec(mcon1,"update turnos set afiliado = ?newregistra, codent = ?mcodent " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=aerror(merror)
	Messagebox("Actualizacion de turnos - 1 "+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

mret = SQLExec(mcon1,"update turnoshis set afiliado = ?newregistra, codent = ?mcodent " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=aerror(merror)
	Messagebox("Actualizacion de turnosHis "+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

mret = SQLExec(mcon1,"update turnoscancel set afiliado = ?newregistra, codent = ?mcodent " + ;
	"where afiliado = ?nroregistra")
If mret < 0
	=aerror(merror)
	Messagebox("Actualizacion de turnosCancel"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

mret = SQLExec(mcon1,"update preregistra set nroregistracio = ?newregistra " + ;
	"where id = ?nroregistra")
If mret < 0
	=aerror(merror)
	Messagebox("Actualizacion de Preregistrados "+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif


