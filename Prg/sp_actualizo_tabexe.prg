****
** Actualizo tabla TabExe
****
parameter mnomexe, mdescri, mfecpas, mabm, midexe,mlauncher,mtitulo,micono

if mabm = 1	&& nuevo exe
	mfecpas = ctod('01/01/1900')

	mret = sqlexec(mcon1, "insert into tabexe(nomexe, descrip, fecpasiva,launcher,titulo,icono) " + ;
		"values(?mnomexe, ?mdescri, ?mfecpas, ?mlauncher, ?mtitulo, ?micono)")

else

	mret = sqlexec(mcon1, "update tabexe set nomexe = ?mnomexe, descrip = ?mdescri, " + ;
		"launcher = ?mlauncher,titulo = ?mtitulo,icono = ?micono,"+;
		"fecpasiva = ?mfecpas where id = ?midexe")
endif

