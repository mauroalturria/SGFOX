parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkpedtto'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT Zabpedtto.* "+;
			" FROM Zabpedtto "+ tcWhere
	case tnOpcion = 2
*SELECT IPT_descripcion, IPT_destino, IPT_formato, IPT_tipo, IPT_valor, ID FROM ZabPedTto
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
