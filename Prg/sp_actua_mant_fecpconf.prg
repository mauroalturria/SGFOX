*
* Actualiza Estado de FechaPrevTecConf TabMantenimiento
*
Lparameters mestado,midot

mret = sqlexec(mcon1,"update tabmantenimiento set FechaPrevTecConf=?mestado"+;
	" where id=?midot")

If mret < 0
	Messagebox("EN ACTUALIZACION DE ESTADO FEC.PREV.TECNICO"+chr(10);
		+"AVISE A SISTEMAS",16,"ERROR")
Endif
