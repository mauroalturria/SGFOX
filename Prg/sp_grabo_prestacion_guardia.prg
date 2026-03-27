****
** graba las prestaciones en guardiaprestacion
****

parameter mcual,mtipoat

if vartype(mtipoat)#"N"
	mtipoat = 0
endif
if mcual = 1

	mcp1 = mwk1.pre_codprest
	mcs1 = mwk1.pre_codservicio
	mfp1 = ctod('01/01/1900')

	mret = sqlexec(mcon1, "insert into guardiaprestacion(codprest, codserv, " + ;
		"fechapasiva, nivel,ranqueo ) values(?mcp1, ?mcs1, ?mfp1,?mtipoat , 0)")
endif

if mcual = 2

	mcp1 = mwk2.pre_codprest
	mcs1 = mwk2.pre_codservicio
	mfp1 = sp_busco_fecha_serv('DD')

	mret = sqlexec(mcon1, "update guardiaprestacion " + ;
		"set fechapasiva = ?mfp1 " + ;
		"where codprest = ?mcp1 and codserv = ?mcs1")

endif
