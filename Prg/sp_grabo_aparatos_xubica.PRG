*
* Actualización de aparatos - ubicación
*
Lparameters moper, mvdat

muser = mwkusuario.idusuario
mfech = sp_busco_fecha_serv('DT')

If moper = 1

	mret = sqlexec(mcon1,"insert into TabApaUbica "+;
		"(TAU_idubica,TAU_codesp,TAU_idapa,"+;
		"TAU_averiado,TAU_cantidad,TAU_obser,"+;
		"TAU_FPasiva,TAU_idusuario,TAU_fechamov)"+;
		" values "+;
		"(?mvdat[1],?mvdat[2],?mvdat[3],"+;
		"?mvdat[4],?mvdat[5],?mvdat[6],"+;
		"?mvdat[7],?muser,?mfech)")

Else

	mret = sqlexec(mcon1,"update TabApaUbica set "+;
		"TAU_averiado=?mvdat[3],"+;
		"TAU_cantidad=?mvdat[2],"+;
		"TAU_obser=?mvdat[4],"+;
		"TAU_idusuario=?muser,"+;
		"TAU_fechamov=?mfech"+;
		" where id = ?mvdat[1]")

Endif

If mret < 0
	Messagebox("EN ACTUALIZACION DE UBICACION DE APARATOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
