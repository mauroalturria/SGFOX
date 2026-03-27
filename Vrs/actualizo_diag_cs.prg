*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
*do sp_conexion
select pacientes
scan
	nadmi = admision
	mret = sqlexec(mcon1,"select PAC_descripdiagegr, PAC_descripdiagn, "+;
		"mte_descripcion, PAC_codcie10diagegr->descrip ,pac_denuncia  " + ;
		"FROM pacientes  "+ ;
		" left join motivoegreso on PAC_motivoalta = mte_codmotivo " +;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mhc  = nvl(PAC_descripdiagegr,'')
		mdcie = nvl(descrip ,'')
		mta 	= mte_descripcion
		mden = iif(pac_denuncia    	> '1', 1, 0)
		select pacientes
		replace diag_ing  with mhc,diagcie10 with mdcie,tipoalta with mta &&,denuncia with mden
	endif
endscan
do sp_desconexion