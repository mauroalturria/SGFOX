*
* Autorizacion de solicitudes de impresión HCE
*
Lparameters mlid, mltipo

muser = Alltrim(mwkusuario.idusuario)
mfech = sp_busco_fecha_serv("DT")

mret = sqlexec(mcon1,"update TabLGHce set "+;
	" TLH_estado=?mltipo,"+;
	" TLH_idusuario=?muser,"+;
	" TLH_fecmov=?mfech"+;
	" where id=?mlid")

If mret < 0
	Messagebox("ACTUALIZA HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
