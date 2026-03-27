Lparameters mcomenta, mfechora, midestado, midusuario, midTipo

mret = Sqlexec(mcon1,"Insert into TabPases " + ;
	"( Ps_comenta, Ps_fechora, Ps_idestado, Ps_idusuario, ps_ipadress, ps_idtipo  ) " + ;
	"Values " + ;
	"( ?mcomenta, ?mfechora, ?midestado, ?midusuario, ?myIp, ?midTipo )" ) 
	
If mret <= 0	
	Messagebox("ERROR DE ACTUALIZACION DE PASE",48,"VALIDACION")
	Return .f.
Endif 