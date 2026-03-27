****
** Consumo de Guardia por dia - horario
****

	
	mfecdes = ctod('01/08/2003')
	mfechas = ctod('31/08/2003')

	mret = sqlexec(mcon1, "select VAL_fechasolicitud, PAC_codhci, PAC_nombrepaciente, " + ;
							"pia_codprest, pre_descriprest, VAL_horasolicitud, his_codentidad, " + ;
							"VAL_codservvale, ser_descripserv, VAL_fechasolicitud " + ;
							"from pacientes, servicios, preinsuvas, histambgua, prestacions " + ;
							"where VAL_codadmision = PAC_codadmision and " + ;
							"VAL_codadmision = his_codadmision and " + ;
							"pia_valeasist  = valeasist and " + ;
							"pia_codprest = pre_codprest and " + ;
							"VAL_codservvale = ser_codserv and " + ;
							"VAL_fechasolicitud >= ?mfecdes and " + ;
							"VAL_fechadolicitud <= ?mfechas and " + ;
							"VAL_codsector = 'GUA' " + ;
							"order by VAL_fechasolicitud, VAL_horasolicitud ", "mwkconsumos1")
							
	