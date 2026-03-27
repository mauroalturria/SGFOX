Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ' '
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkanamkine'
Endif 

Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntAnamKine.*,prestadores.nombre,prestadores.matriculas  FROM TabIntAnamKine "+;
			" left join prestadores on prestadores.id = TabIntAnamKine.IAK_codmed "+;
			" "+ tcWhere
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
