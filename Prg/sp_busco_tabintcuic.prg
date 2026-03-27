parameters tnOpcion, tcWhere, tcCursor,tcjoin

if vartype(tcWhere) # "C"
	tcWhere = ''
endif
if vartype(tcjoin) # "C"
	tcjoin = ''
ENDIF

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntAVN'
Endif 


Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntCuiCom.*,descrip FROM TabIntCuiCom"+;
				" inner join tabestados ON "+;
				"(TabIntCuiCom.ICC_cuidado = tabestados.estado and "+;
				"tabestados.propietario = 25 and tabestados.tipo = 19) "+tcjoin+ tcWhere
	Case tnOpcion = 2
		lcSql = "SELECT top 30 TabIntCuiCom.*,descrip FROM TabIntCuiCom"+;
				" inner join tabestados ON "+;
				"(TabIntCuiCom.ICC_cuidado = tabestados.estado and "+;
				"tabestados.propietario = 25 and tabestados.tipo = 19) "+tcjoin+ tcWhere+"  order by TabIntCuiCom.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
