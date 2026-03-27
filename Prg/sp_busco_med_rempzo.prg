****
** Busco medico reemplazante
****
lparameters mtmat, mmat

mret = sqlexec(mcon1, "SELECT horas_medre FROM TabDatos ", "mwkhorasmedre")
if mret<0 or !used("mwkhorasmedre")
	msegundos = 12 * 3600 && 12 horas por default
else
	msegundos = mwkhorasmedre.horas_medre * 3600
endif

mfeclim = MWKFecServ.fechaHora - msegundos

mret = SQLExec(mcon1," SELECT ID , nombre FROM TabMedExterno " + ;
	" where fechaIngreso >= ?mfeclim and tipoMat= ?mtmat"+;
	" and matricula = ?mmat", "mwkMedicoRpz" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif
if reccount("mwkMedicoRpz")=0
	mret = SQLExec(mcon1," SELECT ID , nombre FROM TabMedExterno " + ;
		" where tipoMat= ?mtmat"+;
		" and matricula = ?mmat order by fechaIngreso desc ", "mwkMedRpz" )
endif
