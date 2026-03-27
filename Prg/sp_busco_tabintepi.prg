Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ' '
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntEpi'
Endif 

tcWhere = tcWhere + " and Tabintepi.IE_fechaHBaja = '2100-01-01' "
Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntEpi.*,codcie10 ,descrip, tabcie10.id as idcie10 FROM TabIntEpi "+;
			" left join tabcie10 on tabcie10.id = TabIntEpi.IE_codcie "+ tcWhere
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
**codcie10 ,descrip,idcie10,IE_codcie ,IE_codmed ,IE_patologia,IE_fechaHora,IE_fechaHBaja, IE_idevol ,IE_tipo