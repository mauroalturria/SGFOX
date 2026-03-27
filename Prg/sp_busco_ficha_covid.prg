*
* Fichas de Epidemiología / covid
*
Lparameters mopcion,mbuscar,mcursor

If Vartype(mcursor)<>"C"
	mcursor = 'mwkepicov'
Endif

If Vartype(mbuscar)<>"C"
	mbuscar= ''
Endif
mfecbase = prg_dtoc(sp_busco_fecha_serv("DD")-30)
Do Case
	Case mopcion= 1
		Use In Select(mcursor)
		mret = SQLExec(mcon1,"select ID, COV_MuestraFecha,COV_Registrac, COV_fecmodifica,COV_inisintoma,COV_HisopaVigilan "+;
			" from Zabfichepncov19 "+mbuscar,mcursor )
	Case mopcion = 2
		Use In Select(mcursor)
		mret = SQLExec(mcon1,"select Zabfichepncov19.ID as idcov, COV_MuestraFecha, RC_nroregistracio as COV_Registrac,"+;
		" Zabregcontagio.FecHorDbAdd as COV_fecmodifica,COV_inisintoma,RC_hisopadoFecha,"+;
			" pac_codadmision as admisionficha,rc_estado,COV_HisopaVigilan "+;
			" from ZabRegContagio left join Zabfichepncov19 on COV_Registrac = RC_nroregistracio "+;
			" inner join pacientes on RC_nroregistracio = pac_codhci "+;
			" inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision "+;
			" where rc_fechapasiva = '1900-01-01' " +mbuscar+;
			" order by RC_nroregistracio  " ,'mwkepicovpre' ) 
			SELECT * FROM mwkepicovpre group by COV_Registrac into cursor &mcursor 
	Case mopcion = 3
		Use In Select(mcursor)
		mret = SQLExec(mcon1,"select Zabfichepncov19.ID as idcov, COV_MuestraFecha,RC_nroregistracio  as COV_Registrac, COV_fecmodifica,COV_inisintoma,"+;
			" pac_codadmision as admisionficha,PAC_fechaalta,pac_fechaadmision, rc_estado ,RC_hisopadoFecha,RC_fechaInicio,RC_fechaFin,RC_fechaPasiva,"+;
			" REG_nrohclinica,REG_numdocumento,COV_HisopaVigilan "+;
			" from ZabRegContagio left join Zabfichepncov19 on COV_Registrac = RC_nroregistracio "+;
			" inner join registracio on  RC_nroregistracio = REG_nroregistrac "+;
			" left join pacientes on RC_nroregistracio = pac_codhci "+;
			" where RC_fechaPasiva = '1900-01-01'  " +mbuscar+;
			" group by ZabRegContagio.ID order by ZabRegContagio.ID " ,mcursor )

Case mopcion = 4
		Use In Select(mcursor)
		mret = SQLExec(mcon1,"select Zabfichepncov19.ID as idcov, COV_MuestraFecha,RC_nroregistracio  as COV_Registrac, COV_fecmodifica,COV_inisintoma,"+;
			" rc_estado ,RC_hisopadoFecha,RC_fechaInicio,RC_fechaFin,RC_fechaPasiva,"+;
			" REG_nrohclinica,REG_numdocumento,COV_HisopaVigilan "+;
			" from ZabRegContagio left join Zabfichepncov19 on COV_Registrac = RC_nroregistracio "+;
			" inner join registracio on  RC_nroregistracio = REG_nroregistrac "+;
			" where RC_fechaPasiva = '1900-01-01' " +mbuscar+;
			" group by ZabRegContagio.ID order by ZabRegContagio.ID " ,mcursor )
Endcase

If mret < 0
	Messagebox("FICHAS DE EPIDEMIOLOGIA"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif


