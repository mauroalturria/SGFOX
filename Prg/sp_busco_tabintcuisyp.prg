Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntAVN'
Endif 


Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntCuiCom.*,descrip FROM TabIntCuiCom"+;
				" inner join tabestados ON "+;
				"(TabIntCuiCom.ICC_cuidado = tabestados.estado and "+;
				"tabestados.propietario = 25 and tabestados.tipo = 19) "+ tcWhere
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
