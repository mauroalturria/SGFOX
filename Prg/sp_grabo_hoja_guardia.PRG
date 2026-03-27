*
* Actualiza maestro Hoja de Guardia - Archivo de Internados
*
Lparameters mregistrac,mfhoja,mfsale,mregre,mdestino,mobs,mtipo

If mtipo = "A"
	mret = sqlexec(mcon1,"insert into TabHciHgua"+;
		" (THG_registrac,THG_fechoja,THG_salida,THG_entrada,THG_destino,THG_observa)"+;
		" values"+;
		" (?mregistrac,?mfhoja,?mfsale,?mregre,?mdestino,?mobs) ")
Else
	mbusca = mwkhgua.lid
	mret = sqlexec(mcon1,"update TabHciHgua set "+;
		"THG_registrac = ?mregistrac,"+;
		"THG_fechoja   = ?mfhoja,"+;
		"THG_salida    = ?mfsale,"+;
		"THG_entrada   = ?mregre ,"+;
		"THG_destino   = ?mdestino,"+;
		"THG_observa   = ?mobs"+;
		" where id = ?mbusca" )
Endif

If mret < 0
	Messagebox("EN ACTUALIZACION TABLA HOJAS DE GUARDIA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.
