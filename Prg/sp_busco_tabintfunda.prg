parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntFunda'
endif
do case
	case tnOpcion = 1
		lcSql = "SELECT ID , IF_admision , IF_ccrp , IF_chk1 , IF_chk10 , IF_chk11 , IF_chk12 , IF_chk2 , IF_chk3 , IF_chk4 ,"+;
			" IF_chk5 , IF_chk6 , IF_chk7 , IF_chk8 , IF_chk9 , IF_codmed , IF_destino , IF_fechah , IF_observa , IF_pasivado , IF_chk13 "+;
			" FROM TabIntFundamenta "+ tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
