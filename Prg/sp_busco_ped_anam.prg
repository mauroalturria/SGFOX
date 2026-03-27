Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkPedAnam'
Endif 


Do Case
	Case tnOpcion = 1
		lcSql = "SELECT ZabIntPedAnam.*,nomape FROM ZabIntPedAnam "+;
				" inner join tabusuario on ZabIntPedAnam.IPA_usuario = tabusuario.id "+ tcWhere

	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
