****
** busca los protocolo de guardia para la grilla
****

parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov
if type ('mbuscog')#"C"
	mbuscog = ''
endif
if type ('mbuscov')#"C"
	mbuscov = ''
endif
do case
	case  mcual = 1
		mfechactr = sp_busco_fecha_serv('DT')
		if type("mfecha1")="T"
			mfecha = mfecha1
		else
			mfecha = mfechactr - 172800  && 57600 && 16hs   &&  86400  &&  24hs
		endif

		horactr = val(left(ttoc(mfechactr,2),2))
		mf1 = prg_dtoc(mfecha1)
		mf2 = prg_dtoc(mfecha2+1)

		mret = sqlexec(mcon1, "select fechahoraing, REG_nombrepac," + ;
			" ent_descrient, reg_nrohclinica,reg_numdocumento  ," + ;
			" reg_telefonos, reg_domicilio, afi_nroafiliado, " + ;
			" ent_codent ,reg_nroregistrac ,TPV_Observa ,tpv_estado,REG_email  "+;
			"from afiliacion,guardia "+;
			"left outer join entidades on guardia.codent = entidades.ent_codent " + ;
			"left outer join  registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
			"left outer join tabpacvip on guardia.nroregistrac = tabpacvip.tpv_nroreg " + ;
			"where " + ;
			"guardia.nroregistrac = afiliacion.registracio and " + ;
			"guardia.codent = afiliacion.afi_codentidad and " + ;
			"guardia.fechahoraing >= ?mf1 and " + ;
			"guardia.fechahoraing < ?mf2 "+mbuscog , "mwkguardia1")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
		endif

	case  mcual = 2
		mfechactr = sp_busco_fecha_serv('DT')
		if type("mfecha1")="T"
			mfecha = mfecha1
		else
			mfecha = mfechactr - 172800  && 57600 && 16hs   &&  86400  &&  24hs
		endif

		horactr = val(left(ttoc(mfechactr,2),2))
		mf1 = prg_dtoc(mfecha1)
		mf2 = prg_dtoc(mfecha2+1)

		mret = sqlexec(mcon1, "select REG_nombrepac,REG_nroregistrac,ent_codent ," + ;
			" ent_descrient, reg_nrohclinica,reg_numdocumento  ," + ;
			" reg_telefonos, reg_domicilio, afi_nroafiliado, " + ;
			" TPV_Audit , TPV_Estado , TPV_Observa ,afi_codentidad,REG_email "+;
			"from tabpacvip,registracio,afiliacion "+;
			"left outer join entidades on afiliacion.afi_codentidad = entidades.ent_codent " + ;
			"where tpv_nroreg = REG_nroregistrac and TPV_Audit = 1 " + ;
			" and TPV_FechaMod >= ?mf1 and TPV_FechaMod <= ?mf2 "+;
			" and REG_nroregistrac = afiliacion.registracio  " + ;
			" group by reg_nrohclinica " , "mwkguardia1")

	case  mcual = 3
		mfechactr = sp_busco_fecha_serv('DT')
		horactr = val(left(ttoc(mfechactr,2),2))
		mf1 = prg_dtoc(mfecha1)
		mf2 = prg_dtoc(mfecha2+1)

		mret = sqlexec(mcon1, "select REG_nombrepac,REG_nroregistrac,ent_codent ," + ;
			" ent_descrient, reg_nrohclinica,reg_numdocumento  ," + ;
			" reg_telefonos, reg_domicilio, afi_nroafiliado, " + ;
			" TPV_Audit , TPV_Estado , TPV_Observa ,afi_codentidad,REG_email "+;
			"from tabpacvip,registracio,afiliacion "+;
			"left outer join entidades on afiliacion.afi_codentidad = entidades.ent_codent " + ;
			"where tpv_nroreg = REG_nroregistrac and TPV_Estado = 0 " + ;
			" and TPV_FechaMod >= ?mf1 and TPV_FechaMod <= ?mf2 "+;
			" and REG_nroregistrac = afiliacion.registracio  " + ;
			"  group by reg_nrohclinica " , "mwkguardia1")
endcase
