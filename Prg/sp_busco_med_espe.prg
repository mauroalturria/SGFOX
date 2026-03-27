*!*	---------------------------------------------
*!*	Busco medicos dada una especialidad 
*!*	Resultado mwkprestaesp
*!*	---------------------------------------------
parameter mopcion, mcodesp, mcursor, mfecdes, mfechas

if type('mcursor')#"C"
	mcursor = "mwkprestaesp"
Endif

if type('mfecdes')#"D"
	mfecdes = sp_busco_fecha_serv('DD') - 30
Endif

if type('mfechas')#"D"
	mfechas = sp_busco_fecha_serv('DD') + 4
endif

mfecnul = CTOD("01/01/1900")
Do Case 
	Case mopcion = 1
		mret = Sqlexec(mcon1,"SELECT nombre, prestadores.id " + ;
			"FROM Prestadores " + ;
			"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecdes) and codesp = ?mcodesp "+;
			"ORDER BY Nombre", mcursor)
	Case mopcion = 2
		mret = Sqlexec(mcon1,"SELECT nombre, prestadores.id " + ;
			"FROM Prestadores " + ;
			"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecdes) and codesp = ?mcodesp "+;
			" Or Id = 1" + ;
			"ORDER BY Nombre", mcursor)
	
EndCase

if mret < 0
	=aerr(eros)
	Messagebox("ERROR AL LEER LOS PRESTADORES ", 48, "VALIDACION")
	Return .f.
endif
