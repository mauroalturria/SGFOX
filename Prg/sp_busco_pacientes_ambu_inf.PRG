*!*	Gustavo Fittipaldi, 17/07/2012
*!*	V5 - varias consultas 
*!*	-----------------------------------------------------
*!*	Busqueda de Pacientes Ambulatorios
*!*	-----------------------------------------------------
Lparameters mdesde,  midmedico, mbusAmb, mBusTur, mcCursor,mhasta

If Vartype(midmedico) # "N"
	msel_med = ""
	mselmsg = ''
Else
	msel_med = " turnos.codmed = ?midmedico and "
	mselmsg = ' and TAM_codmed = ?midmedico '
Endif

If Vartype(mbusAmb) # "C"
	mbusAmb = ""
Endif

If Vartype(mBusTur) # "C"
	mBusTur = ""
Endif

If Vartype(mcCursor)# "C"
	mcCursor = "mwkambu"
Endif

If !Used('mwkentidad')
	mret = SQLExec(mcon1,"select * from entidades","mwkentidad")
Endif
mdes = prg_dtoc(mdesde)
If Vartype(mhasta)#"L"
	mbusf = " and fechaate >= ?mdesde and fechaate <= ?mhasta "
	mbusft = " turnos.fechatur >= ?mdesde and turnos.fechatur <= ?mhasta "
Else
	mbusft = " turnos.fechatur = ?mdesde "
	mbusf = " and fechaate = ?mdesde "
Endif
If At("codmed",mbusAmb)>0   &&&&& esto es provisorio despues hay que agregarle el control por fecha
	mbus = " fechaate = ?mdesde "
Else
	mbus = " 1 = 1 "
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = SQLExec(mcon1,"select PRE_descriprest as prestacion, PRE_codservicio, TabAmbulatorio.*, " + ;
	" tabtipoaltas.tipoest, tabtipoaltas.descrip, TAM_mensaje, " + ;
	" TabEstados.Descrip as DescripInf, b.Id as InformesId, tipoArch , b.EstadoInforme " + ;
	" from TabAmbulatorio " + ;
	" inner join Prestacions on pre_codprest = TabAmbulatorio.codprest " + ;
	" inner join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo " + ;
    "    Left join (select * from informes where tipoArch = 'TXT' and fechainforme >= ?mdesde  " + ;
    "            and informes.EstadoInforme < 5) b " + ;
    "            on Tabambulatorio.NroVale = b.nrovale " + ;
    "    left join TabEstados on TabEstados.Estado = b.EstadoInforme and propietario = 10 " + ;
	" where 1=1 and " + mbus + mbusAmb + mccpoamb  ,"mwkambula")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif

mret = SQLExec(mcon1,"select * from TabAmbMsg "+;
	" where TAM_fechah >=?mdesde "+mselmsg ,"mwkambmsg")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif



mret = SQLExec(mcon1,"select fechahoraing,fechahoraate,REG_nombrepac as paciente,"+ ;
	"PRE_descriprest as prestacion,ENT_descrient,ENT_nroprestadorexterno,TabAmbulatorio.demanda,"+;
	"REG_fecnacimiento as fechanac,TAM_mensaje,TabAmbulatorio.protocolo,"+ ;
	"TabAmbulatorio.id,TabAmbulatorio.codmed,TabAmbulatorio.codent,TabAmbulatorio.codestado,"+ ;
	"Pre_Especialidad,Pre_CodServicio,Prestadores.NOMBRE as nombre,TabAmbulatorio.codprest"+ ;
	",tabtipoaltas.tipoest,tabtipoaltas.descrip, REG_nroregistrac, TabAmbulatorio.nrovale, "+;
	" TabEstados.Descrip as DescripInf, b.Id as InformesId, tipoArch , b.EstadoInforme " + ;
	" from TabAmbulatorio "+;
	" join REgistracio on REG_nroregistrac = TabAmbulatorio.nroregistrac"+ ;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest"+ ;
	" join entidades on ent_codent = TabAmbulatorio.codent"+;
	" join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo "+ ;
	" left join Prestadores on Prestadores.Id = CodMed " + ;
    "    Left join (select * from informes where tipoArch = 'TXT' and fechainforme >= ?mdesde  " + ;
    "            and informes.EstadoInforme < 5) b " + ;
    "            on Tabambulatorio.NroVale = b.nrovale " + ;
    "    left join TabEstados on TabEstados.Estado = b.EstadoInforme and propietario = 10 " + ;
	" where TabAmbulatorio.demanda = 1 and " + mbus + ;
	iif(Len(Alltrim(msel_med))>0," and TabAmbulatorio.codmed=?midmedico " ,"")+ ;
	mbusAmb + mccpoamb  + " group by Tabambulatorio.id ","mwkdemanda")

If mret <= 0
	Messagebox("EN BUSQUEDA DE AMBULATORIOS DEMANDA" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mfectur1 = mdesde

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and turnos.codambito = ?mxambito "
Endif 

mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
	"turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, " + ;
	"turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, turnos.codserv, " + ;
	"registracio.reg_nombrepac, " + ;
	"turnos.fechaconfirma, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
	"afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala, " + ;
	"hdesde1, hhasta1 ,reg_fecnacimiento as fechanac, hhmmtur,turnos.idturnoexterno, " +;
	"registracio.reg_nroregistrac, Prestacions.PRE_descriprest as prestacion, "+ ;
	"PRE_codservicio, Pre_Especialidad, " + ;
	"Prestadores.nombre as nombre,  " + ;
	" TabEstados.Descrip as DescripInf, b.Id as InformesId, tipoArch , b.EstadoInforme " + ;
	" from turnos " + ;
	"Inner join registracio on turnos.afiliado = registracio.reg_nroregistrac " + ;
	"Inner join afiliacion on registracio.reg_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.afi_codentidad " + ;
	"Inner join medpresta on " + ;
		"turnos.codmed   = medpresta.codmed and " + ;
		"turnos.codprest = medpresta.codprest and " + ; 
		"turnos.diasem	 = medpresta.diasem and " + ;
		"turnos.fechatur >= medpresta.fecvigend and " + ;
		"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
		"turnos.fechatur <  medpresta.fecvigenh and " + ;
		"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
		"turnos.hhmmtur < medpresta.hhmmhas " + ;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
    "    Left join (select * from informes where tipoArch = 'TXT' and fechainforme >= ?mdesde   " + ;
    "            and informes.EstadoInforme < 5) b " + ;
    "            on turnos .NroVale = b.nrovale " + ;
    "    left join TabEstados on TabEstados.Estado = b.EstadoInforme and propietario = 10 " + ;
	" where 1=1 " + IIF(upper(LEFT(MSEL_med,3))="AND",''," AND ")+msel_med + mbusft + mBusTur + mccpoamb + ;
	" group by turnos.fechatur, afi_nroafiliado, turnos.codreserva, turnos.codprest, turnos.nrovale ", "mwkphorario1")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN CONSULTA DE TURNOS REGISTRADOS" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and turnos.codambito = ?mxambito "
Endif 

mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp,"+;
	"preregistra.telefono as REG_telefonos," + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado," + ;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento," + ;
	"(preregistra.nombre) as reg_nombrepac," + ;
	"turnos.fechaconfirma, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,"+;
	"turnos.codserv,turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia," + ;
	"preregistra.fechabaja as afi_fechabaja, turnos.afiliado," + ;
	"turnos.nrovale, medpresta.sala,hdesde1, hhasta1 , fechanac,hhmmtur,"+ ;
	"Prestacions.PRE_descriprest as prestacion, " +;
	"PRE_codservicio,Pre_Especialidad,turnos.idturnoexterno, " + ;
	"Prestadores.NOMBRE AS NOMBRE, " + ;
	" TabEstados.Descrip as DescripInf, b.Id as InformesId, tipoArch , b.EstadoInforme " + ;
	" from turnos " + ;
	"inner join preregistra on turnos.afiliado = preregistra.id " + ;
	"inner join medpresta on turnos.codmed = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + msel_med+ ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"turnos.hhmmtur < medpresta.hhmmhas " + ;
	" join Prestacions on pre_codprest = turnos.codprest "+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
    "    Left join (select informes.* from informes where tipoArch = 'TXT' and fechainforme >= ?mdesde  " + ;
    "            and informes.EstadoInforme < 5) b " + ;
    "            on turnos.NroVale = b.nrovale " + ;
    "    left join TabEstados on TabEstados.Estado = b.EstadoInforme and propietario = 10 " + ;
    "where  1=1 and " + mbusft + mBusTur + mccpoamb +;
	" group by turnos.fechatur,preregistra.afiliado,turnos.codreserva,turnos.codprest,turnos.nrovale","mwkphorario2")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN CONSULTA DE TURNOS PREREGISTRADOS" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Turnos GI
*!*	mret = SQLExec(mcon1, "select  turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
*!*	        "turnos.diasem, " + ;
*!*	        "Prestacions.pre_codprest as codprest, " + ;
*!*	        "afi_nroafiliado, reg_telefonos, " + ;
*!*	        "turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, turnos.codserv, " + ;
*!*	        "registracio.reg_nombrepac, " + ;
*!*	        "turnos.fechaconfirma, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, " + ;
*!*	        "turnos.codent, turnos.codmed, " + ;
*!*	        "valesasist.val_medicosolicit as codmedsoli, " + ;
*!*	        "turnos.tipoturno, turnos.solicigia, " + ;
*!*	        "afi_fechabaja, " + ;
*!*	        "Pacientes.Pac_CodHci as afiliado, " + ;
*!*	        "TabTurnosGi.GI_CodValeAsist as nrovale, " + ;
*!*	        "medpresta.sala, " + ;
*!*	        "hdesde1, hhasta1 ,reg_fecnacimiento as fechanac, hhmmtur, " + ;
*!*	        "registracio.reg_nroregistrac, Prestacions.PRE_descriprest as prestacion, " + ;
*!*	        "PRE_codservicio, Pre_Especialidad, " + ;
*!*	        "Prestadores.nombre as nombre, " + ;
*!*	        "TabEstados.Descrip as DescripInf, b.Id as InformesId, tipoArch , b.EstadoInforme " + ;
*!*	"from TabTurnosGi " + ;
*!*	        "Inner join turnos on TabTurnosGi.GI_IdTurno = turnos.Id " +  ;
*!*	        "Inner join ValesAsist on ValesAsist.Val_CodValeAsist = TabTurnosGi.GI_CodValeAsist " + ;
*!*	        "Inner join PRESINSUVAS on PRESINSUVAS.Pia_ValesAsist = ValesAsist.valesasist " + ;
*!*	        "Inner join Coberturas on Coberturas.Cob_Pacientes = ValesAsist.VAL_codadmision " + ;
*!*	        "Inner join Pacientes on Pacientes.Pac_CodAdmision = ValesAsist.VAL_codadmision " + ;
*!*	        "Inner join registracio on Pacientes.Pac_CodHci = registracio.reg_nroregistrac " + ;
*!*	        "Inner join afiliacion on registracio.reg_nroregistrac = afiliacion.registracio and " + ;
*!*	        "        Coberturas.Cob_codEntidad = afiliacion.afi_codentidad " + ;
*!*	        "Inner join medpresta on " + ;
*!*	        "        turnos.codmed   = medpresta.codmed and " + ;
*!*	        "        turnos.codprest = medpresta.codprest and " + ;
*!*	        "        turnos.diasem    = medpresta.diasem and " + ;
*!*	        "        turnos.fechatur >= medpresta.fecvigend and " + ;
*!*	        "        medpresta.fecvigend <> medpresta.fecvigenh and " + ;
*!*	        "        turnos.fechatur <  medpresta.fecvigenh and " + ;
*!*	        "        turnos.hhmmtur >= medpresta.hhmmdes and " + ;
*!*	        "        turnos.hhmmtur < medpresta.hhmmhas " + ;
*!*	        "join Prestacions on pre_codprest = PRESINSUVAS.Pia_codprest " + ;
*!*	        "left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
*!*	        "Left join (select Id, EstadoInforme, NroVale, TipoArch " + ;
*!*	        "                from informes " + ;
*!*	        "                where tipoArch = 'TXT' and " + ;
*!*	        "                        fechainforme >= ?mdesde and " + ;
*!*	        "                        informes.EstadoInforme < 5) b " + ;
*!*	        "        on TabTurnosGi.GI_CodValeAsist = b.nrovale " + ;
*!*	        "left join TabEstados on TabEstados.Estado = b.EstadoInforme and propietario = 10 " + ;
*!*		" where 1=1 " + IIF(upper(LEFT(MSEL_med,3))="AND",''," AND ") + msel_med + mbusft + mBusTur + mccpoamb + ;
*!*	"Group By turnos.fechatur, afi_nroafiliado, PRESINSUVAS.Pia_codprest, TabTurnosGi.GI_CodValeAsist","mwkphorario3")

*!*	If mret <= 0
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Messagebox("EN CONSULTA DE TURNOS GI - REGISTRADOS" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
*!*		Return .F.
*!*	Endif


*!*	---------------------------------------------------------------------------------------
*!*	FIN DE CONSULTAS AL MOTOR
*!*	---------------------------------------------------------------------------------------

Select horatur,reg_nombrepac,codprest,codent,fechanac,reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv,PRE_codservicio, Pre_Especialidad As CodEsp, nombre,codreserva,fechatur,fechaconfirma,Id As tid, ;
	DescripInf, InformesId,  idturnoexterno,tipoturno ;
	from mwkphorario1 ;
Union ;
	select horatur,reg_nombrepac,codprest,codent,fechanac,0 As reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv, PRE_codservicio, Pre_Especialidad, nombre,codreserva,fechatur,fechaconfirma,Id As tid, ;
	DescripInf, InformesId, idturnoexterno, tipoturno ;
	from mwkphorario2 ;
	into Cursor mwkphorariossin

*!*	Union ;
*!*	Select horatur,reg_nombrepac,codprest,codent,fechanac,reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
*!*		codserv,PRE_codservicio, Pre_Especialidad As CodEsp, nombre,codreserva,fechatur,fechaconfirma,Id As tid, ;
*!*		DescripInf, InformesId, tipoturno ;
*!*		from mwkphorario3 ;	

Select * ;
	From mwkphorariossin;
	group By fechatur,reg_nroregistrac,codreserva,codprest;
	into Cursor mwkphorarios

Select horatur,;
	iif(Ttod(fechahoraing)=Ctod("01/01/1900"),{//},fechahoraing) As fechahoraing,;
	reg_nombrepac As paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,ENT_nroprestadorexterno,;
	fechanac,Left(TAM_mensaje,200) As mensaje,mwkAmbula.protocolo As protocolo,mwkAmbula.Id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent As codent1,Nvl(demanda,0) As demanda ,;
	codestado,CodEsp,codserv,nombre,reg_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest, idturnoexterno, ;
	Iif(tipoturno = 3,'GI' + Space(50), Descrip) as Descrip,; 
	fechaconfirma,tid, mwkphorarios.DescripInf, mwkphorarios.InformesId ;
	from mwkphorarios;
	left Join mwkentidad On ENT_codent=mwkphorarios.codent ;
	left Join mwkAmbula On (mwkAmbula.codprest = mwkphorarios.codprest ;
	and reg_nroregistrac = mwkAmbula.nroregistrac );
	group By reg_nroregistrac,horatur,mwkphorarios.codprest,mwkphorarios.nrovale;
	into Cursor mwkambu1xp  &&&join por prestacion

*** 15/12/2011  join por nrovale agregue el nroregistrac
Select horatur,;
	iif(Ttod(fechahoraing)=Ctod("01/01/1900"),{//},fechahoraing) As fechahoraing,;
	reg_nombrepac As paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,ENT_nroprestadorexterno,;
	fechanac,Left(TAM_mensaje,200) As mensaje,mwkAmbula.protocolo As protocolo,mwkAmbula.Id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent As codent1,Nvl(demanda,0) As demanda,;
	codestado,CodEsp,codserv,nombre,reg_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest,idturnoexterno,;
	Iif(tipoturno = 3,'GI' + Space(50), Descrip) as Descrip,;
	fechaconfirma,tid, mwkphorarios.DescripInf, mwkphorarios.InformesId;
	from mwkphorarios;
	left Join mwkentidad On ENT_codent=mwkphorarios.codent ;
	inner Join mwkAmbula On mwkAmbula.nrovale = mwkphorarios.nrovale;
	and  mwkAmbula.nroregistrac = mwkphorarios.reg_nroregistrac ;
	group By reg_nroregistrac,horatur,mwkphorarios.codprest;
	into Cursor mwkambu1xv

*
Select * ;
	From mwkambu1xp ;
	Where Nvl(demanda,0) # 8 ;
	union  ;
Select * ;
	From mwkambu1xv ;
	Where Nvl(demanda,0) # 8 And nrovale ;
	not In (Select nrovale From mwkambu1xp Where !Isnull(protocolo));
	into Cursor mwkambu10

Select * ;
	From mwkambu10 ;
	order By reg_nroregistrac,horatur,nrovale,fechahoraing ;
	into Cursor mwkambu1_

Select * ;
	From mwkambu1_ ;
	Group By reg_nroregistrac,horatur,codprest;
	into Cursor mwkambu1

Select mwkambu1
lnLenInf = 50

If Reccount('mwkdemanda')>0

	Select horatur,Nvl(fechahoraing, Dtot({//})) As fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,Iif(Isnull(codent1),codent,codent1) As codent,;
		nvl(codestado,20) As codestado, CodEsp, codserv, nombre,demanda,reg_nroregistrac,codprest;
		,tipoest,idturnoexterno,Descrip,fechaconfirma,tid, nrovale,  Nvl(DescripInf,Space(lnLenInf)) as DescripInf, InformesId ;
	from mwkambu1;
		union;
	select fechahoraing As horatur,fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,Left(TAM_mensaje,200) As mensaje,;
		protocolo,Id,Space(20) As sala,codmed,codent,codestado,Pre_Especialidad,PRE_codservicio,nombre,;
		demanda, reg_nroregistrac,codprest;
		,tipoest,SPACE(16) as idturnoexterno,Descrip,fechahoraing As fechaconfirma,999999999-999999999 As tid, nrovale, ;
		Nvl(DescripInf,Space(lnLenInf)) as DescripInf, InformesId;
	from mwkdemanda ;
	Where demanda # 8;
	into Cursor &mcCursor
	
Else

	Select horatur,Nvl(fechahoraing, Dtot({//})) As fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,Iif(Isnull(codent1),codent,codent1) As codent,  ;
		nvl(codestado,20) As codestado, CodEsp, codserv, nombre,demanda,reg_nroregistrac,codprest ;
		,tipoest,idturnoexterno,Descrip,fechaconfirma,tid, nrovale, Nvl(DescripInf,Space(lnLenInf)) as DescripInf, InformesId;
		from mwkambu1;
		into Cursor &mcCursor
Endif
