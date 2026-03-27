*!*	------------------------------------------------------------------------------
*!*	Codigo
*!*	Fechatomado -> Fecha del Turno
*!*	Afiliado    -> Codigo de medico
*!*	Observa
*!*	Turnoid     -> Cantidad de Turnos
*!*	Usuario     -> Tipo
*!*	Abreviatura
*!*	Nombre
*!*	Id
*!*	------------------------------------------------------------------------------
lparameters tdfecdes, tdfechas

mncod = 22
if mxambito >1
	mccpoamb = " and Turnosaudit.codambito = ?mxambito "
else
	mccpoamb = ''
endif

mret = Sqlexec(mcon1, "SELECT Turnosaudit.codigo, Turnosaudit.fechatomado, " + ;
	"Turnosaudit.afiliado, Turnosaudit.observa, Turnosaudit.turnoid, " + ;
	"Turnosaudit.usuario, Tabtipoturno.Abreviatura, Prestadores.nombre, " + ;
	"Turnosaudit.ID " + ;
	"FROM TurnosAudit, PRESTADORES, TabTipoturno " + ;
	"WHERE Prestadores.ID = Turnosaudit.afiliado " + ;
	"AND Turnosaudit.turnoid = Tabtipoturno.tipoturno " + ;
	"AND Turnosaudit.fechatomado  >= ?tdfecdes and Turnosaudit.fechatomado < ?tdfechas " + ;
	"AND Turnosaudit.codigo = ?mncod " + ;
	"Order by Nombre, fechatomado","mwkAudit")

if mret < 0
	messagebox("ERROR DE LECTURA", 48, "VALIDACION")
	return .f.
endif
