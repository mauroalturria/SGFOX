***
*** Busqueda de usuario x ID
***
Lparameter mid

Use in select("mwkuserhdo")

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1, "select * from Tabusuario" +;
	" where id = ?mid and fecpasiva = ?mfecpas", "mwkuserhdo")

If mret  < 0
	MTABLA = "MAESTRO DE USUARIOS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10) + "AVISE A SISTEMAS", 16, "ERROR")
	Return .F.
Endif

Return .t.
