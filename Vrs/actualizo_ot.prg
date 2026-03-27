*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
*do sp_conexion
select consulta
scan
	nadmi = dato
	mret = sqlexec(mcon1,"select PAC_codhce " + ;
		"FROM pacientes "+ ;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")
	mdiag = PAC_descripdiagn	
	ndato = alltrim(PAC_codhce)
	mret = sqlexec(mcon1,"select reg_fecnacimiento " + ;
		"FROM registracio "+ ;
		" where reg_nrohclinica = ?ndato " + ;
		"", "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mfn   = mwkbuspacie.reg_fecnacimiento
		select consulta
		replace diagingr with mdiag ,fecnac with mfn   
	endif
endscan
do sp_desconexion