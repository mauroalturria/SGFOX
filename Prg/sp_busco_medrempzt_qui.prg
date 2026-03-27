****
** Busco medicos todos + medico externo de quirofano/pisos
****
lparameters mfecturno,micursor

if vartype(mfecturno) # "D"
	mfecturno = ttod(MWKFecServ.fechaHora)
endif

if vartype(micursor) # "C"
	micursor= 'mwkMedrpzt'
endif

mfecnul   = ctod("01/01/1900")

if used(micursor)
	use in &micursor
endif
mwheres = ''

mret = sqlexec(mcon1, "SELECT prestadores.id, nombre, codesp, codespe, cast(matriculas as integer) as matricula " + ;
	" FROM prestadores " + ;
	" WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) " + ;
	" union  " + ;
	"SELECT Tabpreregmed.ID , nombre,codesp, codesp as codespe, cast(matriculas as integer) as matricula " + ;
	" FROM Tabpreregmed " + ;
	" WHERE Tabpreregmed.estado = 2 "+;
	" ORDER BY nombre ", micursor )

if mret <= 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR DE LECTURA",48,"VALIDACION")
	return .f.
endif

