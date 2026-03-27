parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntCDE'
endif
do case
	case tnOpcion = 1
		lcSql = "SELECT ID , ACE_admision , ACE_codmed , ACE_idautprevia , ACE_ideqp , ACE_otroeqp , ACE_pasivado "+;
		" FROM TabAutCDE "+ tcWhere
	otherwise
		return .f.
endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
ENDIF



