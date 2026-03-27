*!*	sp_grabo_TabAutEst  WITH id,estado
parameters  mid,mest

lcSql = "Insert into TabAutEst " + ;
	" (IdAutPrevias, SubEstado)  Values (?mid,  ?mest) "

if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif
