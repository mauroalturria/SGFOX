do sp_conexion
select medpresta
scan
	mcodmed = codmed
	mesp = alltrim(codesp)

	mret = sqlexec(mcon1,"insert into Tabprofesp (CodCargo, CodProf, codiEsp) "+;
		"values (5,?mcodmed,?mesp)  ")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif
endscan
=sqldisconnect(mcon1)
