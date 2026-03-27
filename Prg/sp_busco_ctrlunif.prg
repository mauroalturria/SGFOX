***********
** Busco historias unifcicadas
***********
parameters mnroDoc, mnrohclinica, mfechad, mfechaH, mbusco

if vartype(mbusco) # "C"
	mbusco = ""
endif

if used ("mwkCtrlUnif")
	use in mwkCtrlUnif
endif

if vartype(mfechad) = "D"
	mcfecdes = prg_dtoc(mfechad)
	mcfecHas = prg_dtoc(mfechah + 1)

	mret = SQLExec(mcon1,"select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, " + ;
		"reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, usuario, " + ;
		"TabCtrlUnif.fecha, reg_fecbajapadronO, reg_fecbajapadronD, Nvl(REG_bloq_comenD,'') as REG_bloq_comenD, nrocontrol " + ;
		",d.PacienteSAP as sapD,o.PacienteSAP as sapO "+;
		"from TabCtrlUnif " + ;
		" left join SAP.pacientes d on reg_nrohclinicad = d.PacienteSG " + ;
		" left join SAP.pacientes o on reg_nrohclinicaO = o.PacienteSG " + ;
		"where TabCtrlUnif.fecha >= ?mcfecdes and TabCtrlUnif.fecha < ?mcfecHas " + mbusco ,"mwkCtrlUnif")

	if mret<1
		=aerr(eros)
		messagebox(eros(3))
		return .f.
	endif

	return .t.
else
	if empty(mnroDoc)

		mret = SQLExec(mcon1,"select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, " + ;
			"reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, " + ;
			"TabCtrlUnif.fecha, reg_fecbajapadronO, reg_fecbajapadronD, REG_bloq_comenD, nrocontrol " + ;
			",d.PacienteSAP as sapD,o.PacienteSAP as sapO "+;
			"from TabCtrlUnif " + ;
			" left join SAP.pacientes d on reg_nrohclinicad = d.PacienteSG " + ;
			" left join SAP.pacientes o on reg_nrohclinicaO = o.PacienteSG " + ;
			"where ( reg_nrohclinicaO = ?mnrohclinica or reg_nrohclinicaD = ?mnrohclinica )" + mbusco ,"mwkCtrlUnif")

		select reg_nombrepaco, reg_nombrepacd, ;
			reg_nrohclinicaO, reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, ;
			TabCtrlUnif.fecha, iif(nrocontrol = 1, dtoc(reg_fecbajapadronD), space(10)) as reg_fecbajapadronD, ;
			iif(nrocontrol = 1, dtoc(reg_fecbajapadronO), space(10)) as reg_fecbajapadronO, ;
			nvl(REG_bloq_comenD, space(40)) as REG_bloq_comenD, nrocontrol,sapd,sapo ;
			from mwkCtrlUnif ;
			into cursor mwkCtrlUnif
	endif

	if val(mnrohclinica) = 0

		mret = SQLExec(mcon1,"select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, " + ;
			"reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, " +;
			"TabCtrlUnif.fecha, reg_fecbajapadronO, reg_fecbajapadronD, REG_bloq_comenD, nrocontrol " + ;
			",d.PacienteSAP as sapD,o.PacienteSAP as sapO "+;
			"from TabCtrlUnif " + ;
			" left join SAP.pacientes d on reg_nrohclinicad = d.PacienteSG " + ;
			" left join SAP.pacientes o on reg_nrohclinicaO = o.PacienteSG " + ;
			"where ( reg_numdocumentoO = ?mnroDoc or reg_numdocumentoD = ?mnroDoc ) " + mbusco ,"mwkCtrlUnif")

		select reg_nombrepaco, reg_nombrepacd, ;
			reg_nrohclinicaO, reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, ;
			TabCtrlUnif.fecha, iif(nrocontrol = 1, dtoc(reg_fecbajapadronD), space(10)) as reg_fecbajapadronD, ;
			iif(nrocontrol = 1, dtoc(reg_fecbajapadronO), space(10)) as reg_fecbajapadronO, ;
			nvl(REG_bloq_comenD, space(40)) as REG_bloq_comenD, nrocontrol,sapd,sapo ;
			from mwkCtrlUnif ;
			into cursor mwkCtrlUnif
	endif

	if mnroDoc * val(mnrohclinica) > 0

		mret = SQLExec(mcon1,"select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, " + ;
			"reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, " +;
			"TabCtrlUnif.fecha, reg_fecbajapadronO, reg_fecbajapadronD, REG_bloq_comenD, nrocontrol " + ;
			",d.PacienteSAP as sapD,o.PacienteSAP as sapO "+;
			"from TabCtrlUnif " + ;
			" left join SAP.pacientes d on reg_nrohclinicad = d.PacienteSG " + ;
			" left join SAP.pacientes o on reg_nrohclinicaO = o.PacienteSG " + ;
			"where ( reg_nrohclinicaO = ?mnrohclinica or reg_nrohclinicaD = ?mnrohclinica ) " + mbusco, "mwkCtrlUnif1")

		mret = SQLExec(mcon1, "select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, " + ;
			"reg_nrohclinicaD, reg_numdocumentoO, reg_numdocumentoD, " +;
			"TabCtrlUnif.fecha, reg_fecbajapadronO, reg_fecbajapadronD, REG_bloq_comenD, nrocontrol " + ;
			",d.PacienteSAP as sapD,o.PacienteSAP as sapO "+;
			"from TabCtrlUnif " + ;
			" left join SAP.pacientes d on reg_nrohclinicad = d.PacienteSG " + ;
			" left join SAP.pacientes o on reg_nrohclinicaO = o.PacienteSG " + ;
			"where ( reg_numdocumentoO = ?mnroDoc or reg_numdocumentoD = ?mnroDoc ) " + mbusco ,"mwkCtrlUnif2")

		select * ;
			from mwkCtrlUnif1 ;
			union ;
			select * ;
			from mwkCtrlUnif2 ;
			into cursor mwkCtrlUnif

		select reg_nombrepaco, reg_nombrepacd, reg_nrohclinicaO, reg_nrohclinicaD, ;
			reg_numdocumentoO, reg_numdocumentoD, TabCtrlUnif.fecha, ;
			iif(nrocontrol = 1, dtoc(reg_fecbajapadronD), space(10)) as reg_fecbajapadronD, ;
			iif(nrocontrol = 1, dtoc(reg_fecbajapadronO), space(10)) as reg_fecbajapadronO, ;
			nvl(REG_bloq_comenD, space(40)) as REG_bloq_comenD, nrocontrol ,sapd,sapo;
			from mwkCtrlUnif ;
			into cursor mwkCtrlUnif
	endif
endif

if mret<1
	=aerr(eros)
	messagebox(eros(3))
	return .f.
endif
