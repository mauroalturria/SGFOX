Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkEvolAKR'
Endif 

Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntEvolKine.*,idusuario FROM TabIntAVN "+;
				" inner join tabusuario on TabIntAVN.AVN_usuario = tabusuario.id "+ tcWhere

	Case tnOpcion = 2
		lcSql = "SELECT top 10 TabIntEvolKine.*,idusuario FROM TabIntAVN "+;
				" inner join tabusuario on TabIntAVN.AVN_usuario = tabusuario.id "+ tcWhere+"  order by TabIntAVN.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
