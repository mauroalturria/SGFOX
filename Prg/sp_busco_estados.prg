****
** Busco TabEstados
****

Parameters mpropietario, mbusco, mcursor

If vartype(mbusco) # "C"
	mbusco = ''
Endif

If vartype(mcursor) # "C"
	mcursor = "mwkEstado"
Endif
if used(mcursor)
	use in &mcursor
endif
mret = sqlexec(mcon1,"select * from tabestados "+;
	" where propietario = ?mpropietario " + mbusco , mcursor)
	
If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE TABESTADOS. CURSOR : " + mCursor,26,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	RETURN .f.
ENDIF
