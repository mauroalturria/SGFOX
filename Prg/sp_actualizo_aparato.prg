*!*	-------------------------------------------------------
*!*	Actualizo los Aparatos
*!*	-------------------------------------------------------
Parameter lnIdAparato, lcDescrip

If lnIdAparato > 0
	mret = SQLExec(mcon1,"Update TabAparatos Set Apa_Descrip = ?lcDescripwhere id = ?lnIdAparato")
Else
	mFechaNull = '1900-01-01'
	mret = SQLExec(mcon1,"Insert into TabAparatos (Apa_Descrip, Apa_FecPasiva) Values (?lcDescrip, ?mFechaNull)")
Endif 

if mret < 0
	aerror(eros)
	messagebox("ERROR AL ACTUALIZAR EL CURSOR, REINTENTE",16, "VALIDACION")
	Return .f.
endif