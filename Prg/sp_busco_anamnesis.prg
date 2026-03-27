****
** busco anamnesis por paciente
****

parameter mcodadm,mfechapasiva 

mfechapasiva = iif(EMPTY(mfechapasiva ),ctod('01/01/1900'),mfechapasiva)
mret = sqlexec(mcon1, "select TNH_fecha,TNH_anamnesis,PAC_codhci," + ;
	" TabNutHpac.id as Id, TNH_fechapasiva,cast(0 as integer ) as elegido," + ;
	" IdUsuario,TNH_usuario " + ;
	" from pacientes " + ;
	" left join TabNutHpac on pacientes.PAC_codhci = TabNutHpac.TNH_registracio "+;
	" left join Tabusuario on Tabusuario .codigovax = TabNutHpac.TNH_usuario "+;
	" where PAC_codadmision = ?mcodadm and " + ;
	" (tnh_fechapasiva > ?mfechapasiva   or  tnh_fechapasiva is null) " + ;
	" order by TNH_fecha desc", "mwkanam")

mret = sqlexec(mcon1, "select PAC_codhci from pacientes " + ;
	" where PAC_codadmision = ?mcodadm " ,"mwkpacHci")
	
if mret<1
	=aerr(eros)
	messagebox (eros(2))
ENDIF
