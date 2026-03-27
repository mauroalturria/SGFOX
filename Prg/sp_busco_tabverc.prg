parameters tnOpcion, tcWhere, tcCursor,tcjoin

if vartype(tcWhere) # "C"
	tcWhere = ''
endif
if vartype(tcjoin) # "C"
	tcjoin = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwktabverc'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT Usuario, ID,codadmision, fecha, habcama,prg FROM Tabverc"+;
			" WHERE  codadmision = '"+ALLTRIM(tcWhere)+ "' "+;
			" ORDER BY ID "
endcase

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
