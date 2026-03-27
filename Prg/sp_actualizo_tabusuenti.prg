parameters tncodent , tnusuid, tnfecha
mfecnul = ctod("01/01/1900")

miusumod = mwkusuario.id
lcSql = "select id from ZabUserEnti  " + ;
	" where UE_codent = ?tncodent and UE_usuarioId = ?tnusuid and UE_fecpasiva = ?mfecnul " 

if !Prg_EjecutoSql(lcSql,"mwkuectrl",.f.)
	return .f.
else
	if reccount("mwkuectrl")=0
		lcSql = "Insert into ZabUserEnti  " + ;
			" (UE_codambito , UE_codent , UE_fecpasiva , UE_usuarioId , UE_usuarioMod  ) " + ;
			" Values " + ;
			" (?mxambito, ?tncodent , ?tnfecha, ?tnusuid, ?miusumod ) "
	else
		tnId  = mwkuectrl.id
		lcSql = "Update ZabUserEnti  " + ;
			" Set UE_fecpasiva = ?tnfecha " + ;
			"Where id = ?tnId "

	endif
	if !Prg_EjecutoSql(lcSql,'',.f.)
		return .f.
	endif
ENDIF
