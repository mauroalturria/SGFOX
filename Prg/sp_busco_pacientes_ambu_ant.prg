*
* Busqueda de Pacientes Ambulatorios
*
Lparameters mdesde, mhasta, midmedico, mbusAmb, mBusTur, mcCursor

If vartype(midmedico) # "N"
	msel_med = ""
Else
	msel_med = " turnos.codmed = ?midmedico and "
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

mret = sqlexec(mcon1,"select PRE_descriprest as prestacion, TabAmbulatorio.*"+;
	" from TabAmbulatorio"+;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest "+;
	" where fechahoraing >= ?mdesde and fechahoraing < ?mhasta " + mbusAmb,"mwkambula")

mret = sqlexec(mcon1,"select * from TabAmbMsg"+;
	" where TAM_fechah >=?mdesde and TAM_fechah < ?mhasta","mwkambmsg")

mret = sqlexec(mcon1,"select fechahoraing,fechahoraate,REG_nombrepac as paciente,"+ ;
	"PRE_descriprest as prestacion,ENT_descrient,"+;
	"REG_fecnacimiento as fechanac,TAM_mensaje as mensaje,TabAmbulatorio.protocolo,"+ ;
	"TabAmbulatorio.id,TabAmbulatorio.codmed,TabAmbulatorio.codent,TabAmbulatorio.codestado,"+ ;
	"Pre_Especialidad,Pre_CodServicio,Prestadores.NOMBRE as nombre,TabAmbulatorio.codprest"+ ;
	" from TabAmbulatorio"+;
	" join REgistracio on REG_nroregistrac = TabAmbulatorio.nroregistrac"+ ;
	" join Prestacions on pre_codprest = TabAmbulatorio.codprest"+ ;
	" join entidades on ent_codent = TabAmbulatorio.codent"+;
	" left join TabAmbMsg on TAM_protocolo = Tabambulatorio.protocolo"+ ;
	" left join Prestadores on Prestadores.Id = CodMed" + ;
	" where fechahoraing >= ?mdesde and fechahoraing < ?mhasta and TabAmbulatorio.demanda = 1"+ ;
	iif(len(alltrim(msel_med))>0," and TabAmbulatorio.codmed=?midmedico ","")+ ;
	mbusAmb + " group by Tabambulatorio.id","mwkdemanda")

If mret < 0
	Messagebox("EN BUSQUEDA DE AMBULATORIOS DEMANDA" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

mfectur1 = mdesde
mfectur2 = mhasta - 1

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp," + ;
	"turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos," + ;
	"turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv," + ;
	"registracio.reg_nombrepac," + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva," + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia," + ;
	"afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala," + ;
	"hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur," +;
	"registracio.reg_nroregistrac,Prestacions.PRE_descriprest as prestacion,"+ ;
	"Pre_Especialidad," + ;
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
	"turnos.fechatur >= ?mfectur1 and " + ;
	"turnos.fechatur <= ?mfectur2 " + mBusTur + ;
	" group by turnos.fechatur,afi_nroafiliado,turnos.codreserva,turnos.hhmmtur", "mwkphorario1")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS REGISTRADOS" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp,"+;
	"preregistra.telefono as REG_telefonos," + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado," + ;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento," + ;
	"(preregistra.nombre) as reg_nombrepac," + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,"+;
	"turnos.codserv,turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia," + ;
	"preregistra.fechabaja as afi_fechabaja, turnos.afiliado," + ;
	"turnos.nrovale, medpresta.sala,hdesde1, hhasta1 , fechanac,hhmmtur,"+ ;
	"Prestacions.PRE_descriprest as prestacion, " +;
	"Pre_Especialidad, " + ;
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
	"turnos.fechatur >= ?mfectur1 and " + ;
	"turnos.fechatur <= ?mfectur2  " + mBusTur +;
	" group by turnos.fechatur,preregistra.afiliado,turnos.codreserva,turnos.hhmmtur","mwkphorario2")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS PREREGISTRADOS" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	Return .f.
Endif

Select horatur,reg_nombrepac,codprest,codent,fechanac,reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv, Pre_Especialidad as CodEsp, nombre ;
	from mwkphorario1 ;
	union ;
	select horatur,reg_nombrepac,codprest,codent,fechanac,0 as reg_nroregistrac,sala,codmed,nrovale,prestacion, ;
	codserv, Pre_Especialidad, nombre ;
	from mwkphorario2 ;
	into cursor mwkphorarios

Select horatur,;
	iif(ttod(fechahoraing)=ctod("01/01/1900"),{//},fechahoraing) as fechahoraing,;
	reg_nombrepac as paciente,mwkphorarios.prestacion,	mwkentidad.ENT_descrient,;
	fechanac,TAM_mensaje as mensaje,mwkAmbula.protocolo as protocolo,mwkAmbula.id,;
	sala,mwkphorarios.codmed,mwkphorarios.codent,mwkAmbula.codent as codent1,;
	codestado,CodEsp,codserv,nombre,reg_nroregistrac,mwkphorarios.codprest ;
	from mwkphorarios;
	left join mwkentidad on ENT_codent=mwkphorarios.codent ;
	left join mwkAmbula on (mwkAmbula.codprest=mwkphorarios.codprest ;
		and reg_nroregistrac = mwkAmbula.nroregistrac ;
		and ttod(mwkAmbula.fechahoraing) = ttod(mwkphorarios.horatur) );
	left join mwkAmbMsg on TAM_protocolo=mwkAmbula.protocolo and alltrim(TAM_protocolo) <> "0";
	group by reg_nroregistrac,horatur,mwkphorarios.codprest;
	into cursor mwkambu1
	&&and mwkAmbula.nrovale=mwkphorarios.nrovale
If reccount('mwkdemanda')>0
	Select horatur,nvl(fechahoraing, dtot({//})) as fechahoraing,paciente,prestacion,ENT_descrient,fechanac,mensaje,;
		protocolo,id,sala,codmed,iif(isnull(codent1),codent,codent1) as codent,;
		nvl(codestado,20) as codestado, CodEsp, codserv, nombre,0 as demanda,reg_nroregistrac,codprest;
		from mwkambu1;
		union;
		select fechahoraing as horatur,fechahoraing,paciente,prestacion,ENT_descrient,fechanac,mensaje,;
		protocolo,id,space(20) as sala,codmed,codent,codestado,Pre_Especialidad,Pre_CodServicio,nombre,;
		1 AS demanda,0 as reg_nroregistrac,codprest;
		from mwkdemanda;
		into cursor &mcCursor
Else
	Select horatur,nvl(fechahoraing, dtot({//})) as fechahoraing,paciente,prestacion,ENT_descrient,fechanac,mensaje,;
		protocolo,id,sala,codmed,iif(isnull(codent1),codent,codent1) as codent,  ;
		nvl(codestado,20) as codestado, CodEsp, codserv, nombre,0 as demanda,reg_nroregistrac,codprest ;
		from mwkambu1;
		into cursor &mcCursor
Endif

