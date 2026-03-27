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
mccpoamb = ' and Tabambulatorio.centromedico = ?mxcentromedico '

sp_busco_tabcm()
Select mwkambitoCM
Locate For centromedico = mxcentromedico And ambito = mxambito
mabmcentroMK = centromedicoMK
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
	mbuscocm = ' 1=1 '
Else
	mbuscocm = ' turnos.ambcentro = ?mabmcentroMK  '
Endif

If !Used('mwkentidad')
	mret = SQLExec(mcon1,"select * from entidades","mwkentidad")
Endif
mdes = prg_dtoc(mdesde)
If Vartype(mhasta)#"L"
	mbusf = " and (fechaate >= ?mdesde and fechaate <= ?mhasta) "
	mbusft = " (turnos.fechatur >= ?mdesde and turnos.fechatur <= ?mhasta) "
Else
	mbusft = " turnos.fechatur = ?mdesde "
	mbusf = " and fechaate = ?mdesde "
Endif
*!*	If At("fechaate",mbusAmb)=0   &&&&& esto es provisorio despues hay que agregarle el control por fecha
*!*		mbus = " fechaate = ?mdesde "
*!*	Else
*	mbus = " 1 = 1 "
*!*	Endif
If At("codmed",mbusAmb)>0   &&&&& esto es provisorio despues hay que agregarle el control por fecha
	mbus = " fechaate = ?mdesde "
Else
	mbus = " 1 = 1 "
Endif

mret = SQLExec(mcon1,"select PRE_descriprest as prestacion, PRE_codservicio, TabAmbulatorio.*, " + ;
	" tabtipoaltas.tipoest, tabtipoaltas.descrip, TAM_mensaje " + ;
	" from TabAmbulatorio " + ;
	" inner join Prestacions on pre_codprest = TabAmbulatorio.codprest " + ;
	" inner join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo " + ;
	" where " + mbus +mbusf + mbusAmb + mccpoamb  ,"mwkambula")

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
	"TabAmbulatorio.id,TabAmbulatorio.codmed,TabAmbulatorio.codent,TabAmbulatorio.archivado,TabAmbulatorio.codestado,"+ ;
	"Pre_Especialidad,Pre_CodServicio,Prestadores.NOMBRE as nombre,TabAmbulatorio.codprest"+ ;
	",tabtipoaltas.tipoest,tabtipoaltas.descrip, REG_nroregistrac, TabAmbulatorio.nrovale ,reg_nrohclinica "+;
	" from TabAmbulatorio "+;
	" join REgistracio on REG_nroregistrac = TabAmbulatorio.nroregistrac"+ ;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest"+ ;
	" join entidades on ent_codent = TabAmbulatorio.codent"+;
	" join tabtipoaltas on TabAmbulatorio.codestado = tabtipoaltas.id " + ;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo "+ ;
	" left join Prestadores on Prestadores.Id = CodMed " + ;
	" where TabAmbulatorio.demanda in( 1 ,8) and " + mbus + ;
	iif(Len(Alltrim(msel_med))>0," and TabAmbulatorio.codmed=?midmedico " ,"")+ ;
	mbusAmb + mccpoamb  + mbusf +" group by Tabambulatorio.id ","mwkdemanda")


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN BUSQUEDA DE AMBULATORIOS DEMANDA" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mfectur1 = mdesde

mccpoamb = ''
mccpoambmp = ''
If mxambito >1
	mccpoamb = "  and turnos.codambito = ?mxambito "
	mccpoambmp = "  and turnos.codambito = medpresta.codambito "
Endif

mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
	"turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, " + ;
	"turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, turnos.codserv, " + ;
	"registracio.reg_nombrepac, " + ;
	"turnos.fechaconfirma, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
	"afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala, " + ;
	"hdesde1, hhasta1 ,reg_fecnacimiento as fechanac, hhmmtur, " +;
	"registracio.reg_nroregistrac, Prestacions.PRE_descriprest as prestacion, "+ ;
	"PRE_codservicio, Pre_Especialidad, " + ;
	"Prestadores.nombre as nombre,idturnoexterno " + ;
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
	"turnos.hhmmtur < medpresta.hhmmhas " + mccpoambmp +;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
	" where  " +mbuscocm + Iif(Upper(Left(MSEL_med,3))="AND",''," AND ")+msel_med + mbusft + mBusTur + mccpoamb + ;
	" group by turnos.horatur, afi_nroafiliado, turnos.codreserva, turnos.codprest, turnos.nrovale "+;
	" order by turnos.horatur desc, afi_nroafiliado,turnos.codprest, turnos.nrovale ", "mwkphorario1") && turnos.codreserva,
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
	"PRE_codservicio,Pre_Especialidad, " + ;
	"Prestadores.NOMBRE AS NOMBRE,idturnoexterno " + ;
	" from turnos " + ;
	"inner join preregistra on turnos.afiliado = preregistra.id " + ;
	"inner join medpresta on turnos.codmed = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + msel_med+ ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"turnos.hhmmtur < medpresta.hhmmhas " + mccpoambmp +;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
	" where "+mbuscocm +" and " + mbusft + mBusTur + mccpoamb +;
	" group by turnos.horatur,preregistra.afiliado,turnos.codreserva,turnos.codprest,turnos.nrovale"+;
	" order by turnos.horatur desc, afi_nroafiliado, turnos.codprest, turnos.nrovale ","mwkphorario2")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN CONSULTA DE TURNOS PREREGISTRADOS" + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif
*!*	---------------------------------------------------------------------------------------
*!*	FIN DE CONSULTAS AL MOTOR
*!*	---------------------------------------------------------------------------------------
Select horatur,reg_nombrepac,codprest,codent,fechanac,reg_nrohclinica,REG_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv,PRE_codservicio, Pre_Especialidad As CodEsp, nombre,codreserva,fechatur,fechaconfirma,Id As tid,idturnoexterno ;
	from mwkphorario1 ;
	union ;
	select horatur,reg_nombrepac,codprest,codent,fechanac,Space(10) As reg_nrohclinica,0 As reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv, PRE_codservicio, Pre_Especialidad, nombre,codreserva,fechatur,fechaconfirma,Id As tid,idturnoexterno ;
	from mwkphorario2 ;
	into Cursor mwkphorariossin

Select * From mwkphorariossin;
	order By fechatur, reg_nroregistrac,  codprest,horatur Desc, nrovale;
	into Cursor mwkphorariossp

Select * From mwkphorariossp;
	group By fechatur,reg_nroregistrac,codprest;  &&,codreserva
Into Cursor mwkphorarios

Select horatur,;
	iif(Ttod(fechahoraing)=Ctod("01/01/1900"),{//},fechahoraing) As fechahoraing,;
	reg_nombrepac As paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,ENT_nroprestadorexterno,;
	fechanac,Left(TAM_mensaje,200) As mensaje,mwkAmbula.protocolo As protocolo,mwkAmbula.Id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent As codent1,mwkAmbula.archivado,Nvl(demanda,0) As demanda ,;
	codestado,CodEsp,codserv,nombre,reg_nrohclinica,REG_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest,Descrip,fechaconfirma,tid,idturnoexterno;
	from mwkphorarios;
	left Join mwkentidad On ENT_codent=mwkphorarios.codent ;
	left Join mwkAmbula On (mwkAmbula.codprest=mwkphorarios.codprest ;
	and REG_nroregistrac = mwkAmbula.nroregistrac );
	group By REG_nroregistrac,horatur,mwkphorarios.codprest,mwkphorarios.nrovale;
	into Cursor mwkambu1xp  &&&join por prestacion

*** 15/12/2011  join por nrovale agregue el nroregistrac
Select horatur,;
	iif(Ttod(fechahoraing)=Ctod("01/01/1900"),{//},fechahoraing) As fechahoraing,;
	reg_nombrepac As paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,ENT_nroprestadorexterno,;
	fechanac,Left(TAM_mensaje,200) As mensaje,mwkAmbula.protocolo As protocolo,mwkAmbula.Id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent As codent1,mwkAmbula.archivado,Nvl(demanda,0) As demanda,;
	codestado,CodEsp,codserv,nombre,reg_nrohclinica,REG_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest,Descrip,fechaconfirma,tid,idturnoexterno;
	from mwkphorarios;
	left Join mwkentidad On ENT_codent=mwkphorarios.codent ;
	inner Join mwkAmbula On mwkAmbula.nrovale = mwkphorarios.nrovale;
	and  mwkAmbula.nroregistrac = mwkphorarios.REG_nroregistrac ;
	group By REG_nroregistrac,horatur,mwkphorarios.codprest;
	into Cursor mwkambu1xv
***   tabambula sin turno

Select fechahoraing As horatur, fechahoraing,;
	sp_busco_npac(mwkAmbula.nroregistrac ,8 ) As paciente, prestacion,	 ENT_descrient,ENT_nroprestadorexterno,sp_busco_npac(mwkAmbula.nroregistrac ,10 ) As fechanac,Space(200) As mensaje,  protocolo,;
	mwkAmbula.Id,Space(10) As sala,codmed, codent, codent As codent1, archivado, demanda,;
	codestado,CodEsp,pre_codservicio As codserv,nombre,sp_busco_npac(mwkAmbula.nroregistrac ,9 ) As reg_nrohclinica,;
	nroregistrac As REG_nroregistrac, codprest, nrovale ;
	,tipoest,Descrip,fechahoraate As fechaconfirma,0 As tid,0 As idturnoexterno;
	from mwkAmbula ;
	inner Join mwkentidad On ENT_codent= codent Left Join mwkmedicoamb On mwkmedicoamb.Id = CodMed ;
	group By REG_nroregistrac,horatur,codprest;
	into Cursor mwkambu1st

*
Select * From mwkambu1xp Where Nvl(demanda,0) # 8 ;
	union  Select * From mwkambu1xv Where Nvl(demanda,0) # 8 And nrovale ;
	not In (Select nrovale From mwkambu1xp Where !Isnull(protocolo));
	into Cursor mwkambu10

Select * From mwkambu10 ;
	order By REG_nroregistrac,horatur Desc,nrovale,fechahoraing ;
	into Cursor mwkambu1_

Select * From mwkambu1_ Group By REG_nroregistrac,horatur,codprest;
	into Cursor mwkambu1_1
Select * From mwkambu1st Where protocolo Not In (Select protocolo From mwkambu10);
	into Cursor mwkambu1_st

If Reccount('mwkdemanda')>0
	Select mwkdemanda
	If !Empty(Field("idturnoexterno"))
		cidexte = "idturnoexterno"
	Else
		cidexte = "Space(16)"
	Endif
	Select fechahoraing As horatur,fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,Left(TAM_mensaje,200) As mensaje,;
		protocolo,Id,Space(20) As sala,codmed,codent,archivado,codestado,Pre_Especialidad As CodEsp,PRE_codservicio As codserv,nombre,;
		demanda, reg_nrohclinica,REG_nroregistrac,codprest;
		,tipoest,Descrip,fechahoraing As fechaconfirma,999999999-999999999 As tid, nrovale,&cidexte As idturnoexterno;
		from mwkdemanda;
		union;
		Select horatur,Nvl(fechahoraing, Dtot({//})) As fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,Iif(Isnull(codent1),codent,codent1) As codent,archivado,;
		nvl(codestado,20) As codestado, CodEsp, codserv, nombre,demanda,reg_nrohclinica,REG_nroregistrac,codprest;
		,tipoest,Descrip,fechaconfirma,tid, nrovale,idturnoexterno;
		from mwkambu1_1;
		into Cursor mwkambu1p
Else
	Select horatur,Nvl(fechahoraing, Dtot({//})) As fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,Iif(Isnull(codent1),codent,codent1) As codent,archivado,;
		nvl(codestado,20) As codestado, CodEsp, codserv, nombre,demanda,reg_nrohclinica,REG_nroregistrac,codprest;
		,tipoest,Descrip,fechaconfirma,tid, nrovale,idturnoexterno;
		from mwkambu1_1;
		into Cursor mwkambu1p
Endif
If Reccount('mwkambu1_st')>0
	Select horatur,fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,codent, archivado, ;
		codestado, CodEsp, codserv, nombre,demanda,reg_nrohclinica,REG_nroregistrac,codprest ;
		,tipoest,Descrip,fechaconfirma,tid, nrovale,idturnoexterno,sp_busco_plan_reg_ent(REG_nroregistrac,codent) as plan;
		from mwkambu1p;
		union;
		Select fechahoraing As horatur,fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac, mensaje,;
		protocolo,Id, sala,codmed,codent,archivado,codestado, CodEsp, codserv,nombre,;
		demanda, reg_nrohclinica,REG_nroregistrac,codprest;
		,tipoest,Descrip, fechaconfirma,999999999-999999999 As tid, nrovale,Space(16) As idturnoexterno,sp_busco_plan_reg_ent(REG_nroregistrac,codent) as plan;
		from mwkambu1_st;
		into Cursor &mcCursor
Else
	Select horatur,fechahoraing,paciente,prestacion,ENT_descrient,ENT_nroprestadorexterno,fechanac,mensaje,;
		protocolo,Id,sala,codmed,codent, archivado, ;
		codestado, CodEsp, codserv, nombre,demanda,reg_nrohclinica,REG_nroregistrac,codprest ;
		,tipoest,Descrip,fechaconfirma,tid, nrovale,idturnoexterno,sp_busco_plan_reg_ent(REG_nroregistrac,codent) as plan;
		from mwkambu1p;
		into Cursor &mcCursor
Endif

USE IN SELECT('mwkambu1p')
USE IN SELECT('mwkambu1_st')
USE IN SELECT('mwkambu1_1')
USE IN SELECT('mwkambu10')
USE IN SELECT('mwkambu1st')
USE IN SELECT('mwkambu1xv')
USE IN SELECT('mwkambu1xp') 