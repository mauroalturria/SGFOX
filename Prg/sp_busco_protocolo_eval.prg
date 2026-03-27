
lparameters mOpcion, mfechades, mfechahas,mbusca,cpresta

*!*	clear
*!* Do sp_conexion
*!*	mOpcion = 2
*!*	mfechades = ctod("11/07/2009")
*!*	mfechahas = ctod("17/07/2009")

if vartype(cpresta)#"C"
	cpresta = " Guardia.codprest IN (42010104,42010105) " 
endif

mf1 = prg_dtoc(mfechades)
mf2 = prg_dtoc(mfechahas+1)

mret = SQLExec(mcon1,"SELECT id, nombre,codesp,codespe,cast(matriculas as integer) as matriculas  FROM prestadores  " + ;
	" union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe,matricula as matriculas  FROM TabMedExterno " + ;
	" where gerenciadora = 0 " , "mwkMedicogua" )
	
do case
	case mOpcion = 1
	
&&			"Prestadores.Nombre as Prof, Prestadores.Matriculas " +

		mret = SQLExec(mcon1, "select guardia.protocolo, guardia.codmed,nroregistrac, "+;
			"Registracio.Reg_NombrePac, Registracio.REG_nrohclinica,Registracio.REG_fecnacimiento, " + ;
			"Entidades.Ent_CodEnt, Entidades.Ent_Descrient, " + ;
			"guardia.FechaHoraing, guardia.FechaHoraate, " + ;
			"Tabguaevol.Eg_Evolucion, EG_motConsulta, EG_codMed, valesasist.VAL_codadmision " + ;
			"from Tabguaevol, guardia  " + ;
			"left outer join entidades 	 on guardia.codent = entidades.ent_codent " + ;
			"left outer join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
			"left outer join guardiavale on guardiavale.protocolo = guardia.protocolo "+;
			"left outer join valesasist  on valesasist.val_codvaleasist = guardiavale.nrovale "+;
			"where " + ;
			"Tabguaevol.Eg_NroRegistrac = guardia.nroregistrac And " + ;
			"Tabguaevol.Eg_Protocolo = guardia.protocolo And " + ;
			"guardia.fechahoraing >= ?mf1 and " + ;
			"guardia.fechahoraing < ?mf2 " +  ;
			" and EG_codMed >0 ", "mwkprotquir1")

			select mwkprotquir1.*,Nombre as Prof, Matriculas, '' as egm_evol,;
			prg_edad(REG_fecnacimiento,ttod(FechaHoraing),"N" ) as edad;   
			from mwkprotquir1,mwkMedicogua where EG_codMed = mwkMedicogua.id;
			and !empty(nvl(Eg_Evolucion,'')) ;
			group by protocolo,eg_codmed into cursor mwkprotquir
			

	case mOpcion = 2

		mret = SQLExec(mcon1, "select guardia.protocolo, guardia.codmed,nroregistrac, "+;
			"Registracio.Reg_NombrePac, Registracio.REG_nrohclinica,Registracio.REG_fecnacimiento,  " + ;
			"Entidades.Ent_CodEnt, Entidades.Ent_Descrient, " + ;
			"guardia.FechaHoraing, guardia.FechaHoraate, " + ;
			"Tabguaevolmed.EGM_evol, Tabguaevol.Eg_Evolucion, EG_motConsulta, EG_codMed,valesasist.VAL_codadmision " + ;
			"from Tabguaevol, guardia " + ;
			"left outer join entidades 	   on guardia.codent = entidades.ent_codent " + ;
			"left outer join registracio   on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
			"left outer join TabGuaEvolMed on Tabguaevolmed.EGM_proto = Tabguaevol.EG_protocolo " + ;
			"left outer join guardiavale on guardiavale.protocolo = guardia.protocolo "+;
			"left outer join valesasist  on valesasist.val_codvaleasist = guardiavale.nrovale "+;
			"where " + ;
			"Tabguaevol.Eg_NroRegistrac = guardia.nroregistrac And " + ;
			"Tabguaevol.Eg_Protocolo = guardia.protocolo And " + ;
			"guardia.fechahoraing >= ?mf1 and " + ;
			"guardia.fechahoraing < ?mf2 and " +  ;
			cpresta + ;
			"", "mwkprotquir1")


		select mwkprotquir1.*,Nombre as Prof, Matriculas,prg_edad(REG_fecnacimiento,ttod(FechaHoraing),"N" ) as edad; 
			from mwkprotquir1,mwkMedicogua ;
			where codMed = mwkMedicogua.id ;
			  and &mbusca and empty(nvl(Eg_Evolucion,'')) ;
			group by protocolo,eg_codmed into cursor mwkprotquir


endcase

if used ("mwkprotquir1")
	use in mwkprotquir1
endif

if mRet < 0
	messagebox("ERROR EN LA GENERACION , AVISAR A SISTEMAS",16, "Validacion")
	do sp_desconexion with "error"
	cancel
endif
