*!*	 busco observaciones de pre QX
parameters tnId,  tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkpqxobs'
endif
USE IN SELECT(tcCursor)
lcSql = "select TabPQobs.*,nombre,nomape from TabPQobs " + ;
	" left join prestadores on PQO_codmed = prestadores.id "+;
	" left join tabusuario on PQO_usuario  = tabusuario.codigovax " +;
	" where PQO_referencia  = ?tnId  " 


if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif

