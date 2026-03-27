****
** Busco TabEstados
****

Parameters mpropietario, mbusco, mvalor

If vartype(mbusco) # "C"
	mbusco = ''
Endif

If vartype(mcursor) # "C"
	mcursor = "mwkEstado"
Endif
if used(mcursor)
	use in &mcursor
endif
mret = sqlexec(mcon1,"update tabestados set "+mvalor+;
	" where propietario = ?mpropietario " + mbusco )
	
If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE TABESTADOS. CURSOR : " + mCursor,26,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	RETURN .f.
ENDIF
