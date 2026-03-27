****
** Pedido de insumos todos o por descripcion
****

parameters mtipo,mcodpun

mret = sqlexec(mcon1,"select  id "+;
	"from TabInsRestriccion where TIR_codpuntero = ?mcodpun " + ;
	" and TIR_fecpasiva = '1900-01-01' and TIR_tipo = ?mtipo ",'mwkctrlins')
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "Err buscotextoinsumo"
endif
if reccount('mwkctrlins')>0
	if messagebox("ESTE INSUMO ESTA RESTRINGIDO, DESEA LIBERARLO?",4+48+256, "Validacion") = 6
		mfecha = sp_busco_fecha_serv("DD")
		mid = mwkctrlins.id
		mret = sqlexec(mcon1,"update TabInsRestriccion set TIR_fecpasiva = ?mfecha  where id = ?mid ")
	endif
else
	mret = sqlexec(mcon1,"insert into TabInsRestriccion "+;
		"(TIR_codpuntero,TIR_fecpasiva,TIR_tipo) values (?mcodpun,'1900-01-01' ,?mtipo ) ")
endif
if mret < 0
	messagebox("ERROR AL GUARDAR LA RESTRICCION",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
