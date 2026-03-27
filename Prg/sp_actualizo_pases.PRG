Lparameters mIdPase, mcomenta, midestado, midUsuario, midTipo

mret = Sqlexec(mcon1,"Update TabPases Set " + ;
	"Ps_comenta = ?mcomenta, Ps_idestado = ?midestado, " + ;
	"Ps_idusuario = ?midusuario, ps_ipadress = ?myIp, ps_idtipo = ?midTipo " + ;
	"Where Id = ?mIdPase ")

If mret <= 0	
	Messagebox("ERROR DE ACTUALIZACION DE PASE",48,"VALIDACION")
	Return .f.
Endif 