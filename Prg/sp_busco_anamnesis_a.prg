****
** busco anamnesis por paciente
****

parameter mcodadm

mret = sqlexec(mcon1, "select TNH_fecha,TNH_anamnesis,PAC_codhci " + ;
	" from pacientes " + ;
	" left join TabNutHpac on PAC_codhci = TNH_registracio "+;
	" where PAC_codadmision = ?mcodadm " + ;
	" order by TNH_fecha desc", "mwkanam")

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif