parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkmeCL'
endif
do case
	case tnOpcion = 1
		lcSql = "SELECT TabMEChklist.*,nomape FROM TabMEChklist "+;
			" inner join tabusuario on MEC_usuario = tabusuario.id "+ tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
