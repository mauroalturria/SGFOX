*
* Busqueda de Pacientes Ambulatorios
*
Lparameters mdesde,  midmedico, mbusAmb, mBusTur, mcCursor,mhasta


If vartype(midmedico) # "N"
	msel_med = ""
	mselmsg = ''
Else
	msel_med = " turnos.codmed = ?midmedico and "
	mselmsg = ' and TAM_codmed = ?midmedico '
Endif

If vartype(mbusAmb) # "C"
	mbusAmb = ""
Endif

If vartype(mBusTur) # "C"
	mBusTur = ""
Endif

If vartype(mcCursor)# "C"
	mcCursor = "mwkambu"
Endif 

If !used('mwkentidad')
	mret = sqlexec(mcon1,"select * from entidades","mwkentidad")
Endif
mdes = prg_dtoc(mdesde)
if vartype(mhasta)#"L"
	mbusf = " and fechaate >= ?mdesde and fechaate <= ?mhasta "
	mbusft = " turnos.fechatur >= ?mdesde and turnos.fechatur <= ?mhasta " 
else
	mbusft = " turnos.fechatur = ?mdesde " 
	mbusf = " and fechaate = ?mdesde "
endif	
if at("codmed",mbusAmb)>0   &&&&& esto es provisorio despues hay que agregarle el control por fecha
	mbus = " fechaate = ?mdesde "
else
	mbus = " 1 = 1 "
endif
mret = sqlexec(mcon1,"select PRE_descriprest as prestacion, PRE_codservicio,TabAmbulatorio.*"+;
	",tabtipoaltas.tipoest,tabtipoaltas.descrip,TAM_mensaje"+;
	" from TabAmbulatorio,tabtipoaltas "+;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest "+;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo"+ ;
	" where TabAmbulatorio.codestado = tabtipoaltas.id and " + mbus + mbusAmb ,"mwkambula")  &&&+ mbusf se agrega despues

mret = sqlexec(mcon1,"select * from TabAmbMsg"+;
	" where TAM_fechah >=?mdesde "+mselmsg ,"mwkambmsg")

mret = sqlexec(mcon1,"select fechahoraing,fechahoraate,REG_nombrepac as paciente,"+ ;
	"PRE_descriprest as prestacion,ENT_descrient,TabAmbulatorio.demanda,"+;
	"REG_fecnacimiento as fechanac,TAM_mensaje,TabAmbulatorio.protocolo,"+ ;
	"TabAmbulatorio.id,TabAmbulatorio.codmed,TabAmbulatorio.codent,TabAmbulatorio.codestado,"+ ;
	"Pre_Especialidad,Pre_CodServicio,Prestadores.NOMBRE as nombre,TabAmbulatorio.codprest"+ ;
	",tabtipoaltas.tipoest,tabtipoaltas.descrip"+;
	" from TabAmbulatorio,tabtipoaltas "+;
	" join REgistracio on REG_nroregistrac = TabAmbulatorio.nroregistrac"+ ;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest"+ ;
	" join entidades on ent_codent = TabAmbulatorio.codent"+;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo"+ ;
	" left join Prestadores on Prestadores.Id = CodMed" + ;
	" where TabAmbulatorio.codestado = tabtipoaltas.id and "+ mbus +" and TabAmbulatorio.demanda = 1"+ ;
	iif(len(alltrim(msel_med))>0," and TabAmbulatorio.codmed=?midmedico ","")+ ;
	mbusAmb + " group by Tabambulatorio.id","mwkdemanda")

If mret < 0
	Messagebox("EN BUSQUEDA DE AMBULATORIOS DEMANDA" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

mfectur1 = mdesde

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp," + ;
	"turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos," + ;
	"turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv," + ;
	"registracio.reg_nombrepac," + ;
	"turnos.fechaconfirma, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva," + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia," + ;
	"afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala," + ;
	"hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur," +;
	"registracio.reg_nroregistrac,Prestacions.PRE_descriprest as prestacion,"+ ;
	"PRE_codservicio,Pre_Especialidad," + ;
	"Prestadores.nombre as nombre" + ;
	" from turnos,registracio,afiliacion,medpresta" + ;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed" + ;
	" where " + ;
	"turnos.afiliado = registracio.reg_nroregistrac and " + ;
	"registracio.reg_nroregistrac = afiliacion.registracio and " + ;
	"turnos.codent = afiliacion.afi_codentidad and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + msel_med +;
	"turnos.diasem	 = medpresta.diasem and " + ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
	"turnos.hhmmtur < medpresta.hhmmhas and " + ;
	mbusft + mBusTur + ;
	" group by turnos.fechatur,afi_nroafiliado,turnos.codreserva,turnos.codprest,turnos.nrovale ", "mwkphorario1")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS REGISTRADOS" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp,"+;
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
	"Prestadores.NOMBRE AS NOMBRE" + ;
	" from turnos, preregistra, medpresta" + ;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed " + ;
	" where  " + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + msel_med+ ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"turnos.hhmmtur < medpresta.hhmmhas and " + ;
	mbusft + mBusTur +;
	" group by turnos.fechatur,preregistra.afiliado,turnos.codreserva,turnos.codprest,turnos.nrovale","mwkphorario2")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS PREREGISTRADOS" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

Select horatur,reg_nombrepac,codprest,codent,fechanac,reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv,PRE_codservicio, Pre_Especialidad as CodEsp, nombre,codreserva,fechatur,fechaconfirma,id as tid ;
	from mwkphorario1 ;
	union ;
	select horatur,reg_nombrepac,codprest,codent,fechanac,0 as reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv, PRE_codservicio, Pre_Especialidad, nombre,codreserva,fechatur,fechaconfirma,id as tid ;
	from mwkphorario2 ;
	into cursor mwkphorariossin

select * from mwkphorariossin;
	group by fechatur,reg_nroregistrac,codreserva,codprest;
	into cursor mwkphorarios
	
Select horatur,;
	iif(ttod(fechahoraing)=ctod("01/01/1900"),{//},fechahoraing) as fechahoraing,;
	reg_nombrepac as paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,;
	fechanac,left(TAM_mensaje,200) as mensaje,mwkAmbula.protocolo as protocolo,mwkAmbula.id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent as codent1,nvl(demanda,0) as demanda ,;
	codestado,CodEsp,codserv,nombre,reg_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest,descrip,fechaconfirma,tid,fechahoraate;
	from mwkphorarios;
	left join mwkentidad on ENT_codent=mwkphorarios.codent ;
	left join mwkAmbula on (mwkAmbula.codprest=mwkphorarios.codprest ;
		and reg_nroregistrac = mwkAmbula.nroregistrac );
	group by reg_nroregistrac,horatur,mwkphorarios.codprest,mwkphorarios.nrovale;
	into cursor mwkambu1xp  &&&join por prestacion
	
Select horatur,;
	iif(ttod(fechahoraing)=ctod("01/01/1900"),{//},fechahoraing) as fechahoraing,;
	reg_nombrepac as paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,;
	fechanac,left(TAM_mensaje,200) as mensaje,mwkAmbula.protocolo as protocolo,mwkAmbula.id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent as codent1,nvl(demanda,0) as demanda,;
	codestado,CodEsp,codserv,nombre,reg_nroregistrac,mwkphorarios.codprest,mwkphorarios.nrovale ;
	,tipoest,descrip,fechaconfirma,tid,fechahoraate;
	from mwkphorarios;
	left join mwkentidad on ENT_codent=mwkphorarios.codent ;
	inner join mwkAmbula on mwkAmbula.nrovale = mwkphorarios.nrovale;
	group by reg_nroregistrac,horatur,mwkphorarios.codprest;
	into cursor mwkambu1xv   &&&join por nrovale
	&&and 

select * from mwkambu1xp where nvl(demanda,0) # 8 ;
union  select * from mwkambu1xv where nvl(demanda,0) # 8 and nrovale ;
	not in (select nrovale from mwkambu1xp where !isnull(protocolo));
into cursor mwkambu10

select * from mwkambu10 ;
order by reg_nroregistrac,horatur,nrovale,fechahoraing ;
into cursor mwkambu1_

select * from mwkambu1_ group by reg_nroregistrac,horatur,codprest;
into cursor mwkambu1

If reccount('mwkdemanda')>0
	Select horatur,nvl(fechahoraing, dtot({//})) as fechahoraing,paciente,prestacion,ENT_descrient,fechanac,mensaje,;
		protocolo,id,sala,codmed,iif(isnull(codent1),codent,codent1) as codent,;
		nvl(codestado,20) as codestado, CodEsp, codserv, nombre,demanda,reg_nroregistrac,codprest;
		,tipoest,descrip,fechaconfirma,tid,nvl(fechahoraate, dtot({//})) as fechahoraate;
		from mwkambu1;
		union;
		select fechahoraing as horatur,fechahoraing,paciente,prestacion,ENT_descrient,fechanac,left(TAM_mensaje,200) as mensaje,;
		protocolo,id,space(20) as sala,codmed,codent,codestado,Pre_Especialidad,Pre_CodServicio,nombre,;
		demanda,0 as reg_nroregistrac,codprest;
		,tipoest,descrip,fechahoraing as fechaconfirma,999999999-999999999 as tid,nvl(fechahoraate, dtot({//})) as fechahoraate;
		from mwkdemanda where demanda # 8;
		into cursor &mcCursor
Else
	Select horatur,nvl(fechahoraing, dtot({//})) as fechahoraing,paciente,prestacion,ENT_descrient,fechanac,mensaje,;
		protocolo,id,sala,codmed,iif(isnull(codent1),codent,codent1) as codent,  ;
		nvl(codestado,20) as codestado, CodEsp, codserv, nombre,demanda,reg_nroregistrac,codprest ;
		,tipoest,descrip,fechaconfirma,tid,nvl(fechahoraate, dtot({//})) as fechahoraate;
		from mwkambu1;
		into cursor &mcCursor
Endif

