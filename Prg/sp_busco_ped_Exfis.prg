Parameters tnOpcion, tcWhere, tcCursor

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif 

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkPedexfis'
Endif 


Do Case
	Case tnOpcion = 1
		lcSql = "SELECT IPEF_Observa , IPEF_Opcion , IPEF_codmed , IPEF_fechaH , IPEF_idevol IPEF_usuario, IPEF_idexamen,nomape FROM ZabIntPedExFis "+;
				" inner join tabusuario on IPEF_usuario = tabusuario.id "+ tcWhere
 
	Otherwise

Endcase
if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	Return .f.
Endif 
