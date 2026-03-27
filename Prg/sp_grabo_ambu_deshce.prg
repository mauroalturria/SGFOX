*
* Desbloqueo HCE correccion de datos, (médico y cod. prestación)
*
Lparameters mid,mcodmed,mcodprest

mret = sqlexec(mcon1,"update tabambulatorio set codmed=?mcodmed, codprest=?mcodprest"+;
	" where id = ?mid")

If mret < 0
	Messagebox('EN ACTUALIZACION MAESTRO AMBULATORIO'+chr(10)+;
		"AVISE A SISTEMAS", 16, 'ERROR')
Endif

