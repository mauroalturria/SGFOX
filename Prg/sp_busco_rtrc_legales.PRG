*
* Busco en Legales estado para el modulo que llama originalmente como Retenida/Recibida (20,22)
* 
Lparameters madmision

mfnull = ctod("01/01/1900")

Use in select("mwklegrtrc")

mret = sqlexec(mcon1,"select * from TabHciMovst"+;
	" where TabHciMovst.hcmfechaingr = ?mfnull and TabHciMovst.hcmnroadm = ?madmision","mwklegrtrc")

If mret < 0
	Messagebox("EN CONSULTA MOVIMIENTOS DE HISTORIAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
