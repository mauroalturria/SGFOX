Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntMCN'
Endif 

Do Case
	Case tnOpcion = 1
		lcSql = "SELECT ZabIntPedNut.*,idusuario,nomape FROM ZabIntPedNut"+;
				" inner join tabusuario on ZabIntPedNut.IPN_usuario = tabusuario.id "+ tcWhere

	Case tnOpcion = 2
		lcSql = "SELECT top 10 ZabIntPedNut.*,idusuario,nomape FROM ZabIntPedNut"+;
				" inner join tabusuario on ZabIntPedNut.IPN_usuario = tabusuario.id "+ tcWhere+"  order by ZabIntPedNut.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
