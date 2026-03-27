*
* Actualizacion de CIAM - AUDITORIAS DE INTERNACION - blanqueo de llamadas
*
mfecnull = ctod("01/01/1900")
mret = sqlexec(mcon1,"update TabCiamAudInt set TCI_llamado = 0 "+;
		" where TCI_fecegr = ?mfecnull ")

If mret < 0
	mpaso = .f.
	Messagebox("EN ACTUALIZACION AUDITORIA DE INTERNACION"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

