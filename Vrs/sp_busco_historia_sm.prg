*********************************************************************************
* BUSCA historias en rotacion                                                    *
*********************************************************************************
	mcFecDes = "2006-03-01 00:00:00"
	mcFecHas = "2006-04-01 00:00:00"

	mret = sqlexec(mcon1,"select HCA_CODBARRA, hcm_fechatur,hcm_descesp,hca_registrac " + ;
		" from TabHCMovst, TabHCArchivo "+;
		" where hcm_registrac = hca_registrac " + ;
		" and hcm_fechatur >= ?mcFecDes " +;
		" and hcm_fechatur < ?mcFecHas " +;
		"  " , "mwkmovmarzo" )

	if mret < 0
		=aerr(eros)
		messagebox(EROS(3))
	endif
select HCA_CODBARRA, hcm_fechatur,hca_registrac ,hcm_descesp,day(hcm_fechatur) as dia ;
	from mwkmovmarzo into cursor movagru

select * from movagru group by 	hca_registrac,dia into cursor movi

select hcm_descesp,count(hca_registrac) as Cantidad from movi group by hcm_descesp into cursor marzo

copy to sectores_0306 type xls