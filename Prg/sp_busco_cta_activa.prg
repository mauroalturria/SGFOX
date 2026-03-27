****
** Busco Cuentas activas
****

Parameter mnroreg,mifechacto,mcta,mxCM
If Type('mifechacto')="D"
	mfechahoy = mifechacto
Else
	mfechahoy = sp_busco_fecha_serv('DD') - 1
	mifechacto = mfechahoy
Endif
If Vartype(mxCM)<>"N"
	mxCM = 0
ENDIF
mfiltraCM = ''
*!*	IF mxCM  = 1
*!*		mfiltraCM = '' &&& no lo pongo porque no creo que haga falta. lo filtro despues
*!*	endif
mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta,PAC_horaalta, PAC_codhci, PAC_codadmision"+;
",PAC_motivoalta,PAC_CentroMedico,PAC_sectorinternac,COB_codentidad, COB_codcontrato,COB_CondicImpositiva  "+;
" FROM pacientes,coberturas "+ ;
" where COB_pacientes = PAC_codadmision and PAC_codhci = ?mnroreg and PAC_fechaalta is null " +;
" ","mwkctainter")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta,PAC_horaalta, PAC_codhci, PAC_codadmision "+;
" ,PAC_motivoalta,PAC_CentroMedico,COB_codentidad, COB_codcontrato,COB_CondicImpositiva  FROM pacientes,coberturas "+ ;
" where  COB_pacientes = PAC_codadmision and  PAC_codhci = ?mnroreg and PAC_fechaalta >= ?mifechacto " +;
" order by PAC_fechaadmision desc","mwkctainteralta")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Do prg_cancelo
	Return .F.
Endif

If Reccount ("mwkctainter")>0
	If Type('mifechacto')="D"
		mfechahoy = mifechacto
	Else
		mfechahoy 	= PAC_fechaadmision
	Endif
Endif

If Type('mcta')="C"
	If mnroreg>0
		mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta,PAC_horaalta, PAC_codhci, PAC_codadmision  "+;
		",PAC_motivoalta,PAC_CentroMedico , HIS_codentidad, HIS_codcontrato, PAC_tipopaciente,HIS_fechaadmision,HIS_CondicImpositiva "+;
		" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
		" where  HIS_nroregistrac= ?mnroreg and PAC_codadmision= ?mcta  " +;
		" order by PAC_fechaadmision desc ","mwkctasamb")
	Else
		mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta,PAC_horaalta, PAC_codhci, PAC_codadmision  "+;
		",PAC_motivoalta,PAC_CentroMedico , HIS_codentidad, HIS_codcontrato, PAC_tipopaciente,HIS_fechaadmision,HIS_CondicImpositiva "+;
		" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
		" where HIS_nroregistrac= PAC_codhci and  PAC_codadmision= ?mcta  " +;
		" order by PAC_fechaadmision desc ","mwkctasamb")
	Endif
Else
	mret = SQLExec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta,PAC_horaalta, PAC_codhci, PAC_codadmision  "+;
	",PAC_motivoalta,PAC_CentroMedico , HIS_codentidad, HIS_codcontrato, PAC_tipopaciente,HIS_fechaadmision,Entidcontr2.TIPO,HIS_CondicImpositiva  "+;
	" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
	" inner join Entidcontr2 on Entidcontr2.CONTRATO = histambgua.HIS_codcontrato "+;
	" where  HIS_nroregistrac= ?mnroreg and PAC_fechaadmision>= ?mfechahoy  " +;
	" and (TIPO = PAC_tipopaciente or TIPO is null) "+;
	" order by PAC_fechaadmision desc ","mwkctasamb")
Endif

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Do prg_cancelo
	Return .F.
Endif
