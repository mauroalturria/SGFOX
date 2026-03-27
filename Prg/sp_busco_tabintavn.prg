
parameters tnOpcion, tcWhere, tcCursor,tcjoin

if vartype(tcWhere) # "C"
	tcWhere = ''
endif
if vartype(tcjoin) # "C"
	tcjoin = ''
endif

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntAVN'
Endif 


Do Case
	Case tnOpcion = 1
		lcSql = "SELECT TabIntAVN.*,idusuario FROM TabIntAVN "+;
				" inner join tabusuario on TabIntAVN.AVN_usuario = tabusuario.id "+tcjoin+ tcWhere

	Case tnOpcion = 2
		lcSql = "SELECT top 10 TabIntAVN.*,idusuario FROM TabIntAVN "+;
				" inner join tabusuario on TabIntAVN.AVN_usuario = tabusuario.id "+tcjoin+ tcWhere+"  order by TabIntAVN.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
