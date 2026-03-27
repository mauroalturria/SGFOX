*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
	mcFecDes = "2006-04-01 00:00:00"
	mcFecHas = "2006-05-01 00:00:00"

	mret = sqlexec(mcon1,"select HCA_CODBARRA, hcm_fechatur,hca_registrac " + ;
		" from TabHCMovct, TabHCArchivo "+;
		" where hcm_registrac = hca_registrac " + ;
		" and hcm_fechatur >= ?mcFecDes " +;
		" and hcm_fechatur < ?mcFecHas " +;
		"  " , "mwkmovabril" )

	if mret < 0
		=aerr(eros)
		messagebox(EROS(3))
	endif
select HCA_CODBARRA, hcm_fechatur,hca_registrac ,substr(HCA_CODBARRA,7,2) as digi,day(hcm_fechatur) as dia ;
	from mwkmovabril into cursor movagru

select * from movagru group by 	hca_registrac,dia into cursor movi

select digi, count(hca_registrac) as cuantos from movi group by digi into cursor abril

copy to digitos_0406 type xls