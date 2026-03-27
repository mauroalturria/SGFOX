*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
select consulta
scan
	nadmi = admision
	mret = sqlexec(mcon1,"select PAC_codhce " + ;
		"FROM pacientes "+ ;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mhc  = PAC_codhce
		select consulta
		replace HC with mhc
	endif
endscan
do sp_desconexion