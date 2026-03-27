****
*** busca los servicios de acuerdo al tipo de paciente
****
lparameters mtipo, mbusco,mcursor

if type('mtipo')#"N"
	mtipo = 0
endif

if type('mbusco')#"C"
	mbusco = ''
endif
if type('mcursor')#"C"
	mcursor = 'mwkserv'
endif

use in select(mcursor )

do case
	case mtipo = 1 &&&& guardia

		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico from servicios, servcargval " + ;
			"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
			"and scv_mnemonico is not null and ser_fechapasiva is null "+;
			"order by ser_descripserv", mcursor )

	case mtipo = 2 &&&& ambulatorio

		mret = sqlexec(mcon1,"select ser_codserv, ser_descripserv,scv_mnemonico from servicios, servcargval  " + ;
			"where ser_ambulatorio = 'S'  and ser_codserv = servcargval.scv_codservicio " + ;
			"and scv_mnemonico is not null and ser_fechapasiva is null "+;
			"order by ser_descripserv", mcursor )

	case mtipo = 3 &&&& internacion

		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico from servicios, servcargval " + ;
			"where ser_internacion = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
			"and scv_mnemonico is not null and ser_fechapasiva is null "+;
			"order by ser_descripserv", mcursor )

	case mtipo = 4 &&&& Servicios Full

		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,SER_quirofano,ser_internacion "+;
			" from servicios" + ;
			" where ser_fechapasiva is null" + mbusco + ;
			" order by ser_descripserv,ser_codserv ",mcursor )

	case mtipo = 5 &&&& Servicios con prestaciones

		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv"+;
			" from servicios,prestacions " + ;
			" where ser_fechapasiva is null and PRE_codservicio = ser_codserv "+mbusco+;
			" order by ser_descripserv",mcursor )

	case mtipo = 6 &&&& internacion Y GUARDIA
		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico from servicios"+;
			" LEFT JOIN servcargval ON ser_codserv = servcargval.scv_codservicio " + ;
			" where (ser_internacion = 'S' or  ser_guardia = 'S') " + ;
			" and ser_fechapasiva is null "+;
			" order by ser_descripserv", mcursor )
	case mtipo = 7 &&&& Servicios Full
		use in select("mwkservaux")
		use in select(mcursor )
		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv "+;
			" from servicios" + ;
			" where ser_fechapasiva is null" + mbusco + ;
			" order by ser_descripserv,ser_codserv ","mwkservt")
		mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv  "+;
			" from servicios,prestacions " + ;
			" where ser_fechapasiva is null and PRE_codservicio = ser_codserv "+mbusco+;
			" group by ser_descripserv ","mwkservp")
		select * from  mwkservp union all;
			select * from mwkservt ;
			where ser_descripserv not in ( select ser_descripserv from mwkservp ) and ser_descripserv  is not null into cursor mwkservauxso
			select * from mwkservauxso ORDER BY ser_descripserv  into cursor mwkservaux
		use dbf('mwkservaux') in 0 again alias mwkserv
		use in select("mwkservauxSO")
		use in select("mwkservaux")

	otherwise

		mret = sqlexec(mcon1,'SELECT ser_codserv,ser_descripserv,scv_mnemonico ' + ;
			'FROM servicios, servcargval ' + ;
			"where ser_codserv = servcargval.scv_codservicio " + ;
			"and scv_mnemonico is not null and ser_fechapasiva is null "+;
			" group by ser_codserv order by ser_descripserv", mcursor )

endcase

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "sp_servicio"
	cancel
endif
