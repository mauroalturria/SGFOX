*
* Modificacion de O.S. para turnos del dia confirmados
*
lparameters mafiliado, mentidad

mfecha = sp_busco_fecha_serv('DD')

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret = sqlexec(mcon1,"update turnos set codent=?mentidad"+;
	" where &mccpoamb afiliado=?mafiliado and fechatur=?mfecha and fechaconfirma is not null")

if mret < 0
	messagebox("Error al actualizar turnos. AVISE A SISTEMAS",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

mret = sqlexec(mcon1,"update tabambulatorio set codent = ?mentidad "+;
	" where &mccpoamb nroregistrac = ?mafiliado and fechaate = ?mfecha ")

if mret < 0
	messagebox("Error al actualizar HCE... AVISE A SISTEMAS",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
