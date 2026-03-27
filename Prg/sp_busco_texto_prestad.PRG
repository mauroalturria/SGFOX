Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcCursor) # "C"
	tcCursor = "mwktextoPrestad"
Endif 

Do Case
	Case tnOpcion = 1 
		lcSql = "Select * from Prestadores where FecPasivap = '1900-01-01' " + tcWhere + " Order by Nombre "

	Otherwise

Endcase 

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 