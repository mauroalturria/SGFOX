Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntEvolped'
Endif 
* IPA_EFDiasVida , IPA_EFPerimCef , IPA_EFPesoReal , IPA_EFTalla ,IPA_fechaH , IPA_idevol , IPA_usuario 

Do Case
	Case tnOpcion = 1
		lcSql = "SELECT ZabIntPedEvolm.*,idusuario,nomape FROM ZabIntPedEvolm"+;
				" inner join tabusuario on ZabIntPedEvolm.IPA_usuario = tabusuario.id "+ tcWhere

	Case tnOpcion = 2
		lcSql = "SELECT top 10 ZabIntPedEvolm.*,idusuario,nomape FROM ZabIntPedEvolm"+;
				" inner join tabusuario on ZabIntPedEvolm.IPA_usuario = tabusuario.id "+ tcWhere+"  order by ZabIntPedEvolm.id desc "
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
