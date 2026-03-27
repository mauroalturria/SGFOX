
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad, cast("   " as char(3)) as sec_codsector, " + ;
	" cast("   " as char(45)) as sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, " + ;
	" PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	" PAC_horaadmision, PAC_codhci, HIS_codcontrato as COB_codcontrato , " + ;
	" PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, PAC_operadm , PAC_operalta , " + ;
	" PAC_fechaalta,PAC_categoria, pac_domicilio,ENT_codent,idusuario, " + ;
	" TabProtQuir.*,tabquirofano.id as idquirofano,Cirujano,Anestesista,Ayudante," + ;
	" BiopsiaIntraOp,BiopsioDiferida,Cardiologo,Cirujanote,Comentario,DuracEst,Edad, " + ;
	" EstComen,Estado ,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,HoraInic,Instrumen," + ;
	" Material,NroProtocolo,NroQuirofano,Operacion,Rayos, " + ;
	" Diagnostico, hemocomen,fechaquirof,MateComen  ,Nroregistrac,OperCod,codmed,quirofano,"+;
	" tabquirofano.id , Tabquiroflog . FechaMod , Tabquiroflog . UsuarioQ ," + ;
	" laboratorio,AnestesiaTipo,MatInstancia,PAC_codadmision as lug_pacientes,"+;
	" PAC_fechaadmision as lug_fechaingreso,PAC_horaadmision as lug_horaingreso " + ;
	" from TabProtQuir  " + ;
	" left join Tabquiroflog "+;
	" on ( Tabquiroflog.Dato = Tabprotquir.Codadmision  and Tabquiroflog.IdTabQuirofano = TabProtQuir.id ) "+;
	" left join  tabquirofano on tabquirofano.id = TabProtQuir.quirofano " +;
	" left join  histambgua on histambgua .his_codadmision = Tabprotquir.Codadmision  " +;
	" left join  pacientes on pacientes.pac_codadmision  =  histambgua .his_codadmision " +;
	" left join  entidades on histambgua .HIS_codentidad  = entidades .ENT_codent " +;
	" left join  afiliacion on " +;
	" pacientes.PAC_codhci = afiliacion.registracio and " + ;
	" histambgua.HIS_codentidad = afiliacion.AFI_codentidad " + ;
	" left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax  " +;
	" where  "+;
	" TipoPac = 2 &mbusco1 " + ;
	" ", "mwkpacint02")
	
	
	
	mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad, cast('' as char(3)) as sec_codsector, " + ;
	" cast('' as char(45)) as sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, " + ;
	" PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	" PAC_horaadmision, PAC_codhci, HIS_codcontrato as COB_codcontrato , " + ;
	" PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, PAC_operadm , PAC_operalta , " + ;
	" PAC_fechaalta,PAC_categoria, pac_domicilio,ENT_codent,idusuario, " + ;
	" TabProtQuir.*,tabquirofano.id as idquirofano,Cirujano,Anestesista,Ayudante," + ;
	" BiopsiaIntraOp,BiopsioDiferida,Cardiologo,Cirujanote,Comentario,DuracEst,Edad, " + ;
	" EstComen,Estado ,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,HoraInic,Instrumen," + ;
	" Material,NroProtocolo,NroQuirofano,Operacion,Rayos, " + ;
	" Diagnostico, hemocomen,fechaquirof,MateComen  ,Nroregistrac,OperCod,codmed,quirofano,"+;
	" tabquirofano.id , Tabquiroflog . FechaMod , Tabquiroflog . UsuarioQ ," + ;
	" laboratorio,AnestesiaTipo,MatInstancia,PAC_codadmision as lug_pacientes,"+;
	" PAC_fechaadmision as lug_fechaingreso,PAC_horaadmision as lug_horaingreso " + ;
	" from TabProtQuir  " + ;
	" left join Tabquiroflog "+;
	" on ( Tabquiroflog.Dato = Tabprotquir.Codadmision  and Tabquiroflog.IdTabQuirofano = TabProtQuir.id ) "+;
	" left join  tabquirofano on tabquirofano.id = TabProtQuir.quirofano " +;
	" left join  histambgua on histambgua .his_codadmision = Tabprotquir.Codadmision  " +;
	" left join  pacientes on pacientes.pac_codadmision  =  histambgua .his_codadmision " +;
	" left join  entidades on histambgua .HIS_codentidad  = entidades .ENT_codent " +;
	" left join  afiliacion on " +;
	" pacientes.PAC_codhci = afiliacion.registracio and " + ;
	" histambgua.HIS_codentidad = afiliacion.AFI_codentidad " + ;
	" left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax  " +;
	" where  "+;
	" TipoPac = 2 &mbusco1 " + ;
	" ", "mwkpacint02")