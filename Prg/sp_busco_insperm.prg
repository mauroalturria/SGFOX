Lparameters tdFecha, tnPerfil

mret = sqlexec(mcon1,"SELECT * " + ;
	"FROM INSUMOSPERMISOS " + ;
	"WHERE INP_fechadesde <= ?tdFecha and INP_perfil = ?tnPerfil " + ;
	"Order By ins_codpuntero, inp_fechadesde","mwkinsperm")
	
If mret <= 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR EN LA GENERACION DEL CURSOR",16, "VALIDACION")
Endif 

