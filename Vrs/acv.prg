*do sp_conexion
set step on
select acv
scan
	if empty(codadm)
		mnroreg = acv.H_clinica
		mfecha1 = acv.fecha
		mfecha2 = ttod(acv.hora + 12*3600)
	*	mihora = ttod(fechahorai + 12*3600)
		mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
			" ,PAC_motivoalta, PAC_diagegreso,PAC_codcie10diagalt,PAC_descripdiagegr"+;
			" FROM pacientes,registracio  "+ ;
			" where  REG_nrohclinica = ?mnroreg and PAC_codhci = REG_nroregistrac and PAC_fechaadmision >=?mfecha1 " +;
			" and PAC_fechaadmision <=?mfecha2  and pac_tipopac<2","mwkbuspacie")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3))
		endif
		select acv
		if reccount( "mwkbuspacie")>0
			replace codadm with mwkbuspacie.PAC_codadmision,;
				motivoalta with  nvl(mwkbuspacie.PAC_motivoalta,0), ;
				diagegreso with nvl(mwkbuspacie.PAC_diagegreso,''),;
				codcie10 with nvl(mwkbuspacie.PAC_codcie10diagalt,''),;
				descdiag with nvl(mwkbuspacie.PAC_descripdiagegr,''),;
				fecalta with nvl(mwkbuspacie.PAC_fechaalta,ctod("01/01/1900"))
		endif
	endif
endscan

