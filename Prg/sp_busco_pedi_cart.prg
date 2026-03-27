parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntFPA'
endif
do case
	case tnOpcion = 1
		lcSql = " SELECT ID , PC_accion , PC_descripcion , PC_grupo , PC_orden , PC_tipo , PC_valor FROM ZabIntPedCart "+ tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
