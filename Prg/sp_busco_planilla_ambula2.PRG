*
* Consulta Planilla Ambulatorio ART
*
Lparameters mf1, mf2, mcadPS

mbuscog2 = " and TabAmbulatorio.codestado > 1 "
mccpoamb = ""

If mxambito > 1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif

mfnull = Ctot("01/01/1900")

mret = SQLExec(mcon1, "select tabambulatorio.protocolo, tabambulatorio.fechahoraing, REG_nombrepac,"+;
	" nombre, codprest, ENT_descrient, PRE_descriprest, PRE_especialidad, tabambulatorio.fechahoraate,"+;
	" tabambulatorio.codestado, TabAmbulatorio.id, tabambulatorio.nrovale, REG_nrohclinica,"+;
	" reg_telefonos, reg_domicilio, afi_nroafiliado, TabAmbulatorio.codprest as pia_codprest," + ;
	" ESP_descripcion, TabAmbulatorio.codent, prestacions.Pre_codservicio as codserv, TabAmbulatorio.codmed,"+;
	" TabAmbulatorio.nroregistrac, Tabambulatorio.usuario, ent_descrient, codcie9,"+;
	" TabTipoAltas.tipoest as taltaest, descrip, REG_numdocumento, REG_fecnacimiento, REG_sexo,"+;
	" VAL_fechasolicitud, VAL_horasolicitud, val_bono, tipoest,"+;
	" Tabambulatorio.codmed as lidprestador, "+;
	" TabArtReg.ID as IdArtReg, TAR_codart, TAR_proxate, TAR_siniestro,val_operadorcarga,REG_localidad,REG_provincia, "+;
	" TabArtSg.TAS_IdArt, TabTipoAltas.descrip as taltades "+;
	" from prestacions, "+;
	" entidades,"+;
	" especialid, "+;
	" registracio, "+;
	" afiliacion, "+;
	" tabtipoaltas, "+;
	" TabAmbulatorio "+;
	" left outer join prestadores  on prestadores.id    = TabAmbulatorio.codmed"+;
	" left outer join TabArtSg     on TabArtSg.TAS_IdSG = prestadores.id "+;
	" left outer join TabArtReg    on TAR_registracio   = registracio.REG_nroregistrac and TAR_entidad = TabAmbulatorio.codent and TAR_finpro = ?mfnull "+;
	" join VALESASIST on VALESASIST.VAL_codvaleasist    = Tabambulatorio.nrovale"+;
	" where "+;
	" TabAmbulatorio.nroregistrac  = registracio.REG_nroregistrac and " + ;
	" TabAmbulatorio.nroregistrac  = afiliacion.REGISTRACIO and " + ;
	" TabAmbulatorio.codprest      = prestacions.PRE_codprest and " + ;
	" TabAmbulatorio.codestado 	   = tabtipoaltas.id and " + ;
	" prestacions.PRE_especialidad = ESP_codesp and " + ;
	" TabAmbulatorio.codent	       = entidades.ENT_codent and " + ;
	" TabAmbulatorio.fechahoraing >= ?mf1 and " + ;
	" TabAmbulatorio.fechahoraing < ?mf2  " + mbuscog2 + mccpoamb , "mwkambula0")

If mret < 0
	mltabla = "PLANILLA DE GUARDIA AMBULATORIO"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

misql = "select "+;
	" ttod(fechahoraing) as fechahoraing, " + ;
	" left(ttoc(fechahoraing, 2), 5) as hora, " + ;
	" REG_nombrepac as paciente, "+;
	" strtran(pre_descriprest,'CONSULTA ','') as prestacion, " + ;
	" ent_descrient, "+;
	" protocolo, "+;
	" iif(isnull(nombre), space(40), nombre) as nombre, "+;
	" descrip," + ;
	" codent, "+;
	" tipoest,"+;
	" descrabrev, " + ;
	" descripcion, "+;
	" REG_nrohclinica, "+;
	" REG_telefonos, " + ;
	" REG_domicilio, "+;
	" fechahoraate, "+;
	" esp_descripcion, " + ;
	" codestado, "+;
	" mwkambula0.id, "+;
	" codprest, "+;
	" nroregistrac, "+;
	" afi_nroafiliado, "+;
	" fechahoraing as lfechahora, "+;
	" REG_fecnacimiento, "+;
	" tipoest " + ;
	" IdArtReg, TAR_codart, TAR_proxate, TAR_siniestro, "+;
	" lidprestador,PRE_especialidad,nrovale,codserv,codmed,val_operadorcarga,reg_numdocumento,"+;
	" REG_sexo,REG_localidad,REG_provincia,val_fechasolicitud, val_horasolicitud,codcie9,TAS_IdArt,taltades,taltaest,val_bono "+;
	" from mwkambula0 "+;
	" left Join mwkciap2e On mwkciap2e.Id = codcie9 "+;
	" where " + mcadPS +;
	" group by fechahoraing, protocolo, codprest, mwkambula0.id into cursor mwkambula01"

&misql

Select protocolo, fechahoraing, paciente as REG_nombrepac, ;
	iif(Isnull(mwkambula01.nombre) Or (Empty(mwkambula01.nombre) And codmed>1),mwkMedicogua01.nombre,mwkambula01.nombre) As nombre, ;
	descrip,codprest, ENT_descrient, prestacion as PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula01.Id,;
	nrovale, REG_nrohclinica, REG_telefonos, REG_domicilio, ;
	ESP_descripcion, codent, codserv, codmed,tipoest, val_operadorcarga,  ;
	nroregistrac,reg_numdocumento, descrabrev, descripcion, AFI_nroafiliado,REG_sexo,REG_fecnacimiento,;
	REG_localidad,REG_provincia,val_fechasolicitud, val_horasolicitud, codcie9, Nvl(lidprestador,0000000) As lidprestador, Nvl(TAS_IdArt,0000000) As lIdArt,  ;
	taltades,taltaest, Iif(Nvl(TAR_siniestro,0) = 0, val_bono, Transform(TAR_siniestro)) As val_bono, IdArtReg, TAR_codart, TAR_proxate, hora ;
	from mwkambula01 Left Join mwkMedicogua01 On codmed = mwkambula01.Id  ;
	group By protocolo,nrovale ;
	order By fechahoraing Into Cursor mwkambula01

Return .T.
