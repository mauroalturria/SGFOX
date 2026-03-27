Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcCursor)  # "C"
	tcCursor = 'mwkMedQuir'
Endif  


Do Case
	Case tnOpcion  =1
		lcSql = "Select * from TIPOMEDQUIR " + tcWhere 

	Otherwise

Endcase 

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 