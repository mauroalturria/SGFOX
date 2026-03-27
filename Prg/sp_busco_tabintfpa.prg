parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntFPA'
endif
do case
	case tnOpcion = 1
		lcSql = "SELECT  ID , IFA_admision , IFA_codmed , IFA_fechaPA , IFA_observa , IFA_pasivado FROM TabIntFPA "+ tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
