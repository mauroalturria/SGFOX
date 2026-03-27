****
**  Busco Texto para retiro de Estudios
****

parameter mcodserv,lesguardia
lesguardia = iif(vartype(lesguardia)="U",.f.,lesguardia)
*!*	mbus = "and subserv in ('',"+ iif(mwkexe.nomexe="TURNOS","'A'",;
*!*		iif(inlist(mwkexe.nomexe,"GUARDIA",'ADMISION'),"'G'", "''") )+") "

mbus = "and subserv in ('',"+ iif(lesguardia,"'G'", "''") +") "
mccpoamb = ' codambito = ?mxambito and '
mret = sqlexec(mcon1, 'select descrip from tabubicaserv '+;
		'where  &mccpoamb codserv = ?mcodserv '+mbus , 'mwkubicaserv')

if mret < 0
	messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
	messagebox("ERROR DE LECTURA DE AUTORIZACIONES ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
