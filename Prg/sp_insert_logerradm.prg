****
** grabo un registro de log por error
****
Parameter mxAFIfechabaja,mxcodentMK, mxcoderr, mxcodmed,  mxdocumento, mxfecEgresoPad,mxfechahoraing,;
	mxmstrent, mxnrohclinica, mxnroregistrac,mxnroregistracMK



mret = SQLExec(mcon1, "insert into ZabLogErrAdm ( AFIfechabaja,codentMK, coderr, codmed,  documento, fecEgresoPad,fechahoraing, "+;
	"mstrent, nrohclinica, nroregistrac,nroregistracMK) " + ;
	"values(?mxAFIfechabaja,?mxcodentMK, ?mxcoderr, ?mxcodmed,  ?mxdocumento, ?mxfecEgresoPad,?mxfechahoraing,"+;
	" ?mxmstrent, ?mxnrohclinica, ?mxnroregistrac,?mxnroregistracMK)")

If mret < 0
*!*			messagebox('NO SE ACTUALIZO LA TABLA DE LOG DE ERRORES'+chr(13), 16, 'Validacion')
 	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
