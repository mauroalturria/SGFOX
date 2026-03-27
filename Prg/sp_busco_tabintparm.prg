Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntPKARM'
Endif 

Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntParamArm.*,idusuario FROM TabIntParamArm "+;
				" inner join tabusuario on TabIntParamArm.ARM_codmed = tabusuario.idcodmed "+ tcWhere

	Case tnOpcion = 2
		lcSql = "SELECT top 10 TabIntParamArm.*,idusuario FROM TabIntParamArm "+;
				" inner join tabusuario on TabIntParamArm.ARM_codmed = tabusuario.idcodmed "+ tcWhere+"  order by TabIntParamArm.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
