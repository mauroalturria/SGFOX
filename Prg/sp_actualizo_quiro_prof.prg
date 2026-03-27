*!* ======================================================================
*!*	081128 solo esta en frmquirof03
*!*	081128 FechaInternac Campo Agregado
*!*	======================================================================
parameters mid,mcodmed,mCodEsp,mServicio
mret = sqlexec(mcon1," UPDATE TabQuirofano SET codmed=?mcodmed,Servicio = ?mServicio"+;
	",CodEsp = ?mCodEsp where id = ?mid")

if mret < 0
	messagebox("EN ACTUALIZACION QUIROFANO",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

