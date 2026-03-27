****
** busco ultima secuencia
****
parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ' '
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkhcepac'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT ID,IH_admision, IH_secuencia, IH_secagrup,PAC_sectorinternac  "+;
			" FROM TabintHCE inner join pacinternad on IH_admision = PIN_codadmision "+ ;
			" inner join Pacientes on PAC_codadmision = PIN_codadmision " +tcWhere

	otherwise

endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
