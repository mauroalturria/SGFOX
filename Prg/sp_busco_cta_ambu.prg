****
** Busco Cuentas activas
****

parameter mnroreg,mtipo,mifechacto 
if type('mifechacto')="D"
	mfechahoy = mifechacto
else
	mfechahoy = sp_busco_fecha_serv('DD') - 1
	Mifechacto = mfechahoy 
endif
mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision,PAC_CentroMedico  "+;
	", HIS_codentidad, HIS_codcontrato, PAC_tipopaciente,HIS_fechaadmision,Entidcontr2.TIPO,HIS_CondicImpositiva  "+;
	" FROM histambgua join pacientes on pacientes.pacientes =  histambgua.HIS_codadmision "+ ;
	" inner join Entidcontr2 on Entidcontr2.CONTRATO = histambgua.HIS_codcontrato "+;
	" where  HIS_nroregistrac= ?mnroreg and PAC_fechaadmision>= ?mfechahoy  " +;
	" and TIPO = PAC_tipopaciente and tipo = ?mtipo "+;
	" order by PAC_fechaadmision desc ","mwkctasamb")

If mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "VALIDACION")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	do prg_cancelo
	Return .f.
Endif 
