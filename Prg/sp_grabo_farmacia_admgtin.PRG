*
* Actualizacion Maestro GTIN
*
Lparameters mnlid, mcsg, mcpa, mncan, mctroquel

mfechamov = sp_busco_fecha_serv("DT")
midusua   = mwkusuario.idusuario

mret = sqlexec(mcon1,"update TabTraGtin set " +;
	" TGT_InsCod   = ?mcsg," +;
	" TGT_PrincAct = ?mcpa," +;
	" TGT_cantidad = ?mncan," +;
	" TGT_usuario  = ?midusua,"+;
	" TGT_fecmov   = ?mfechamov,"+;
	" TGT_troquel  = ?mctroquel"+;
	" where id = ?mnlid")

If mret < 0
	Messagebox("EN ACTUALIZACION MAESTRO GTIN",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
