*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
select obito
scan
	nadmi = nro_admisi
	mret = sqlexec(mcon1,"select PAC_descripdiagegr, PAC_codcie10diagegr->descrip " + ;
		"FROM pacientes "+ ;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mhc  = nvl(PAC_descripdiagegr,'')
		mdcie = nvl(descrip ,'')
		select obito
		replace diag_ing  with mhc,diagcie10 with mdcie
	endif
endscan
do sp_desconexion