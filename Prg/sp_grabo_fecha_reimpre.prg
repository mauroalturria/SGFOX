*********
* Grabo fecha hora de impresion del vale en guardiavale
*********
parameter mid

mfechahora = sp_busco_fecha_serv('DT')
mret = SQLExec(mcon1,"update guardiavale set fechamodif = ?mfechahora "+;
	" where id = ?mid ")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0

endif
