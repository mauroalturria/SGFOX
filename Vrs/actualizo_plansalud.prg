*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
select sivendia2
scan
	nadmi = admision
	mret = sqlexec(mcon1,"select REG_nombrepac, REG_domicilio," + ;
		"REG_numdocumento,REG_telefonos , REG_fecnacimiento  " + ;
		"FROM pacientes,registracio " + ;
		" where PAC_codadmision = ?nadmi and PAC_codhci = registracio " + ;
		"", "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mdom = REG_domicilio
		mtel = REG_telefonos
		mfec = REG_fecnacimiento
		select sivendia2
		replace domic with mdom,telef with mtel,fnac with mfec
	endif
endscan
do sp_desconexion