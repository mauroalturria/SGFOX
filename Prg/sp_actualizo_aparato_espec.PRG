*!*	-------------------------------------------------------
*!*	Actualizo los Aparatos por Especialidad (SDEP)
*!*	-------------------------------------------------------
lParameter lnAbm, lnId, lnidApa, lcCodEsp

do case 

	Case lnAbm = 1

		If lnId > 0
			mret = SQLExec(mcon1,"Update TabapaxEsp Set Ape_IdApa = ?lnidApa, Ape_CodEsp = ?lcCodEsp  where id = ?lnId")
		Else
			mFecNull = Ctod("01/01/1900")
			mret = SQLExec(mcon1,"Insert into TabapaxEsp (Ape_IdApa, Ape_CodEsp, Ape_fpasiva) Values (?lnidApa, ?lcCodEsp, ?mFecNull)")
		Endif 

	Case lnAbm = 2 && cambio de fPasiva

		mfvigenh = sp_busco_fecha_serv('DT')
		mret = SQLExec(mcon1,"Update TabapaxEsp Set Ape_fpasiva = ?mfvigenh where id = ?lnId")

EndCase 

if mret < 0
	=aerror(eros)
	messagebox("ERROR AL ACTUALIZAR EL CURSOR, REINTENTE",16, "VALIDACION")
	Return .f.
endif