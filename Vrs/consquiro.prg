mbusco1 	= " and pac_fechaadmision >= ?mfecdes "

mret = SQLExec(mcon1, "select " + ;
	"TabProtQuir.*, Pacientes.Pac_codhci " + ;
	"from TabProtQuir ,pacinternad, pacientes " + ;
	"where pin_codadmision = Codadmision and pac_codadmision = Codadmision "+;
	"and TipoPac = 1"+ mbusco1 , "mwkpacint01")

mifecha = sp_busco_fecha_serv("DD")-3
mbusco2 = " and FechaHoraQuir >= ?mifecha  "

mret = SQLExec(mcon1, "select TabProtQuir.*, Pac_codhci " + ;
	" From TabProtQuir " + ;
	" Inner Join histambgua on histambgua.his_codadmision = TabProtQuir.Codadmision " + ;
	" Inner Join Pacientes on Pacientes.PAC_codhci = histambgua.his_nroregistrac " + ;
	" and PAC_codadmision = TabProtQuir.Codadmision " + ;
	" Where Tabprotquir.TipoPac = 2 &mbusco2 " , "mwkpacint02")
	
		cFecSqlDesde = Dtot(mfecdes)
	cFecSqlHasta = Dtot(mfechas+1)

	mret = SQLExec(mcon1,"select a.IdTabQuirofano,a.fechahoracarga, a.FechaHoraConforme , b.TQC_HoraSalida , b.NroProtocolo, a.CodBolsa, c.CantRecibida ,c.CantConformada , c.CantSuministrada , c.CantUtilizada " +;
		"from TabBolsasProgramacion as a " +;
		"left join TabInsumosProgramacion as c on a.ID = c.IdTabBolsasProgramacion " +;
		"left join TabQuirofano as b on a.IdTabQuirofano = b.ID " +;
		"where a.FechaHoraCarga >= ?cFecSqlDesde and a.FechaHoraCarga <= ?cFecSqlHasta and a.FechaHoraConforme is not NULL AND " +;
		"(c.CantUtilizada = -999 or c.CantRecibida = -999)","mwkBolsaPendiente")
		
		
mret = SQLExec(mcon1,"select idQuirof, NroRegistrac,FechaQuirof,FechaHora " +;
	"from TabQuirofanoLog " +;
	"where FechaQuirof between ?dFechaDesde and ?dFechaHasta " +;
	"order by idQuirof, FechaHora ",cCursor)
