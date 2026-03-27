parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkregRCV'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT * "+;
			" FROM TabRegRCV "+ tcWhere 
endcase

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
