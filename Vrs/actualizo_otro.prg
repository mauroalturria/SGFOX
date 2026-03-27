*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
*do sp_conexion
select consulta
scan
	ndato = dato
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
		medad = prg_edad(mfn)
		mdias = date()-mfn
		select consulta
		replace edad with medad,dias with mdias ,fecnac with mfn   
	endif
endscan
do sp_desconexion