Parameters nVale,nPresPend

lcSql = "delete FROM PRESTAPENDI " + ;
		"Where PREPEN_vale = ?nVale and PREPEN_codigo = ?nPresPend "

If !prg_ejecutosql(lcSql)
	Messagebox("No se realizó la Actualización de la tabla PRESTAPENDI",64,"VALIDACIÓN")
	Return .F.
ENDIF

RETURN .t.