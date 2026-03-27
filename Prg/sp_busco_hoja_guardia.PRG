*
* Busqueda de Hojas de Guardia - Archivo de Internados
*
Lparameters mhc, mfhj, mchk, mcursor

If vartype(mcursor) <> "C"
	mcursor = "mwkhgua"
Endif

Use in select(mcursor)

mfnull = ctod("01/01/1900")

mjoin  = ""
If !empty(mhc)
	mjoin = " REG_nrohclinica = ?mhc and "
Endif

mwhere = ""
If mfhj <> {//}
	mwhere = " where THG_fechoja = ?mfhj "
Endif

If !empty(mwhere)
	mwhere = mwhere + iif(mchk = 0,""," and THG_entrada = ?mfnull")
Else
	mwhere = mwhere + iif(mchk = 0,""," where THG_entrada = ?mfnull")
Endif

mret = sqlexec(mcon1,"select REG_nrohclinica,THG_fechoja,REG_nombrepac,THG_salida,"+;
	" sdep.Descripcion,THG_entrada,THG_observa,THG_destino,THG_registrac,"+;
	" TabHciHgua.id as lid "+;
	" from TabHciHgua"+;
	" join REGISTRACIO on " + mjoin + " REG_nroregistrac = TabHciHgua.THG_registrac"+;
	" join sdep on sdep.id = TabHciHgua.THG_destino " + mwhere ,mcursor)

If mret < 0
	Messagebox("EN CONSULTA TABLA HOJAS DE GUARDIA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
