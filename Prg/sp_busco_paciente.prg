****
** BUSCA PACIENTES
****
parameter mnrodoc, mnroafi, mcodadmi,mnrohc
if empty(mnroafi)
	mnroafi = 0
endif
mnrohc = IIF(VARTYPE(mnrohc)="C",mnrohc,"")
if empty(mnrodoc)
	mnrodoc = 0
endif

DO case
CASE !EMPTY(mnrohc)
		mret = sqlexec(mcon1,"select *,TPV_Estado from registracio " + ;
			" left outer join TabPacVip on  registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
			"where registracio.REG_nrohclinica = ?mnrohc", "mwkencontrado")
CASE type('mcodadmi') = "C"
	mret = sqlexec(mcon1, "select PAC_nombrepaciente,PAC_codadmision, PAC_habitacion, PAC_cama, " + ;
		"PAC_domicilio, PAC_codhci, PAC_codhce, ENT_codent, ENT_descrient,ENT_nroprestadorexterno,COB_codcontrato, TPV_Estado  " + ;
		"from pacientes " + ;
		"left join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes " +;
		"left join entidades on coberturas.COB_codentidad = entidades.ENT_codent " +;
		" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
		"where PAC_codadmision = ?mcodadmi "+ ;
		"group by PAC_codadmision " , "mwkpacint")
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		do sp_desconexion with "error"
		cancel
	endif

CASE mnroafi >0
	mret = sqlexec(mcon1,"select *,TPV_Estado from  afiliacion,registracio " + ;
		" left outer join TabPacVip on  registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
		"where registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"afiliacion.AFI_nroafiliado = ?mnroafi", "mwkencontrado")

	if eof('mwkencontrado')
		mret = sqlexec(mcon1,"select *,TPV_Estado from registracio " + ;
			" left outer join TabPacVip on  registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
			"where registracio.REG_numdocumento = ?mnrodoc", "mwkencontrado")
	endif

	if eof('mwkencontrado')
		mret = sqlexec(mcon1,"select *,cast(0 as integer) as TPV_Estado from preregistra " + ;
			"where nrodocumento = ?mnrodoc", "mwkencontrado")
	endif
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		do sp_desconexion with "error"
		cancel
	ENDIF
CASE mnrodoc >0
	mret = sqlexec(mcon1,"select *,TPV_Estado from registracio " + ;
		" left outer join TabPacVip on  registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
		"where registracio.REG_numdocumento = ?mnrodoc", "mwkencontrado")

	if eof('mwkencontrado')
		mret = sqlexec(mcon1,"select *,cast(0 as integer) as TPV_Estado from preregistra " + ;
			"where nrodocumento = ?mnrodoc", "mwkencontrado")
	endif
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		do sp_desconexion with "error"
		cancel
	endif
	
endcase