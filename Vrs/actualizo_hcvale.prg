*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
select cirugia
scan
	nadmi = codigo
	mret = sqlexec(mcon1,"select VAQ_urgencia,VAQ_urgenciafactur " + ;
		"FROM Valesquirof "+ ;
		" where VAQ_codadmision = ?nadmi " + ;
		"", "mwkbuspacieq")

	mret = sqlexec(mcon1,"select Urgencia " + ;
		"FROM Tabprotquir "+ ;
		" where codadmision = ?nadmi " + ;
		"", "mwkbuspaciep")

	mret = sqlexec(mcon1,"select PAC_urgenprogramad " + ;
		"FROM pacientes "+ ;
		" where PAC_codadmision = ?nadmi " + ;
		"", "mwkbuspacie")
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
		select cirugia
	if reccount( "mwkbuspacie")>0
		mhc  = nvl(mwkbuspacie.PAC_urgenprogramad ,"-")
		replace urg with mhc
	endif
	if reccount( "mwkbuspaciep")>0
		mhc  = nvl(mwkbuspaciep.Urgencia,0)
		replace urgpq with mhc
	endif
	if reccount( "mwkbuspacieq")>0
		mhc  = val(nvl(mwkbuspacieq.VAQ_urgencia,2))
		mhcf  = nvl(mwkbuspacieq.VAQ_urgenciafactur ,2)
		replace urgvale with mhc,urgvalf with mhcf
	endif
endscan
do sp_desconexion