****
** Busco pacientes de alta por nombre y fecha_alta desde
****

parameter mnombre, mfechad

	mret = sqlexec(mcon1, "select PAC_codadmision, PAC_nombrepaciente, PAC_fechaadmision, " + ;
							"PAC_fechaalta, PAC_motivoalta, PAC_sexo, PAC_edad, " + ;
							"PAC_diagegreso from pacientes " + ;
							"where PAC_nombrepaciente like &mnombre and " + ; 
							"PAC_fechaalta >= ?mfechad and " + ;
							"PAC_tipopac <2", "mwkpacalta")