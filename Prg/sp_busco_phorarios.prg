***
*** Generacion de planilla de Turnos
***
Parameter mfectur1, mfectur2, midmedico, mcodesp , msel_med,mlibres,mxcodprest,lxcentro,lvales


If Type ('mlibres')#"N"
	mlibres =	0
Endif
If Type ('mxcodprest')#"N"
	mxcodprest =	0
Endif
If Vartype(lxcentro)<>"N"
	lxcentro=0
Endif
If Vartype(lvales)<>"N"
	lvales = 0
Endif
If Type ('msel_med')#"C"
	msel_med =	' turnos.codmed = ?midmedico and '
Endif
If Type('mcodesp') # "C"
	msel_esp = ""
Else
	msel_esp = " turnos.codesp = ?mcodesp and "
Endif
mccpocmed = ''
mccentro =''
Do Case
Case lxcentro= 0 OR mxambito >1
	mccentro = ''
Case lxcentro=1
	mccentro =  " and (sala not like '%LIMA%' AND sala not like '%CP%' ) "
Case lxcentro=2
	mccentro =   " and sala like '%LIMA%' "
Case lxcentro=3
	mccentro =   " and sala like '%CP%' "
Case lxcentro=9
	mccentro = Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  ))
Endcase

mccpoamb = mccentro
mccpoambbf = ''
mcjoin = ''
mccpoambm  = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito and Turnos.codambito = ?mxambito "
	mcjoin = 	" medpresta.codambito = turnos.codambito and "
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoambm = "  and medpresta.codambito = ?mxambito  "
Endif

lsigue = .T.
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoambbf  id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios1'
	Cancel
Endif
mret = SQLExec(mcon1,'select tipoturno as tt,Abreviatura FROM Tabtipoturno','mwktt')
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios1'
	Cancel
Endif
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha

If !Used('mwkpmed')
	Do sp_busco_phordatos
Endif
Do sp_muestra_ubicacion
Select * From MwkUbica Into Cursor mwkconsultorio

&& busco en turnos
mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
	'turnos.codreserva, registracio.reg_nrohclinica, registracio.REG_numdocumento,registracio.Reg_email,'+;
	'registracio.REG_bloq_comen,turnos.codserv,  ' + ;
	'registracio.reg_nombrepac, ' + ;
	'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,' + ;
	'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia,turnos.UsuarioSector,turnos.tipotomado, ' + ;
	'afi_fechabaja, turnos.afiliado, turnos.nrovale, turnos.fechaconfirma, medpresta.sala ' + ;
	',hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur,prestadores.nombre as medsolicita , turnos.usuariogenera ' +;
	'from turnos '+;
	' inner join registracio on turnos.afiliado = registracio.reg_nroregistrac '+;
	' inner join afiliacion on (registracio.reg_nroregistrac = afiliacion.registracio '+;
	' and turnos.codent = afiliacion.afi_codentidad )'+;
	' inner join medpresta on (' + ;
	'turnos.codmed   = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' +;
	'turnos.diasem	 = medpresta.diasem and ' + mcjoin +;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas )' + ;
	'inner join Prestadores on Prestadores.Id = turnos.CodMedsoli '+;
	'where ' + ;
	'turnos.fechatur >= ?mfectur1 and ' + msel_esp + msel_med +;
	'turnos.fechatur <= ?mfectur2 ' + mccpoamb +;
	'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva, turnos.hhmmtur,turnos.codprest  ' + ;
	'', 'mwkphorario1')

&& busco pre_registrados
*	'turnos.afiliado > 0 '
&&	"turnos.tipoturno < 8 and "

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios2'
	Cancel
Endif

mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado, " + ;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento,preregistra.email as Reg_email, " + ;
	"(preregistra.nombre) as reg_nombrepac, " + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,turnos.codserv, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia,turnos.UsuarioSector,turnos.tipotomado, " + ;
	"preregistra.fechabaja as afi_fechabaja, turnos.afiliado, " + ;
	"turnos.nrovale,turnos.fechaconfirma,  medpresta.sala " + ;
	",hdesde1, hhasta1 , fechanac,hhmmtur,prestadores.nombre as medsolicita, turnos.usuariogenera " +;
	"from turnos "+;
	" inner join preregistra on turnos.afiliado = preregistra.id "+;
	" inner join medpresta on (" + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + ;
	"turnos.fechatur >= medpresta.fecvigend and " + mcjoin +;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas ) ' + ;
	" inner join Prestadores on Prestadores.Id = turnos.CodMedsoli "+;
	"where  " + ;
	"turnos.fechatur >= ?mfectur1 and " + msel_esp +msel_med+;
	"turnos.fechatur <= ?mfectur2  " + mccpoamb + ;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva, turnos.hhmmtur,turnos.codprest   " + ;
	"", "mwkphorario3")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios3'
	Cancel
Endif

&& busco en turnoshis
If mfectur1 <= mfechalimite
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.REG_numdocumento,registracio.Reg_email'+;
		',registracio.REG_bloq_comen, ' + ;
		'registracio.reg_nombrepac, ' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,turnos.codserv, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia,turnos.UsuarioSector,turnos.tipotomado, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale, turnos.fechaconfirma, medpresta.sala ' + ;
		',hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur,prestadores.nombre as medsolicita , turnos.usuariogenera ' +;
		'from turnoshis as turnos , registracio, afiliacion, medpresta ' + ;
		'left join Prestadores on Prestadores.Id = turnos.CodMedsoli '+;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + msel_esp +msel_med+;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' + ;
		'turnos.codmed   = medpresta.codmed and ' + ;
		'turnos.codprest = medpresta.codprest and ' + ;
		'turnos.diasem	 = medpresta.diasem and ' + ;
		'turnos.fechatur >= medpresta.fecvigend and ' + ;
		'turnos.fechatur <  medpresta.fecvigenh and ' + mcjoin +;
		'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
		'turnos.fechatur >= ?mfectur1 and ' + ;
		'turnos.fechatur <= ?mfectur2 ' + mccpoamb +;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva, turnos.hhmmtur,turnos.codprest   ' + ;
		'', 'mwkphorario2')
	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_phorarios4'
		Cancel
	Endif

&& busco pre_registrados en turnoshis
	mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, "+;
		"preregistra.telefono as reg_telefonos, " + ;
		"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento,preregistra.email as Reg_email, " + ;
		"(preregistra.nombre) as reg_nombrepac, " + ;
		"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,turnos.codserv, " + ;
		"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia,turnos.UsuarioSector,turnos.tipotomado, " + ;
		"preregistra.fechabaja as afi_fechabaja, turnos.afiliado, " + ;
		"turnos.nrovale, turnos.fechaconfirma, medpresta.sala " + ;
		",hdesde1, hhasta1 ,fechanac,hhmmtur,prestadores.nombre as medsolicita, turnos.usuariogenera " +;
		"from turnoshis as turnos, preregistra, medpresta " + ;
		"left join Prestadores on Prestadores.Id = turnos.CodMed "+;
		"where  " + ;
		"turnos.afiliado = preregistra.id and " + ;
		"turnos.codmed   = medpresta.codmed and " + ;
		"turnos.codprest = medpresta.codprest and " + msel_esp +msel_med+;
		"turnos.diasem	 = medpresta.diasem and " + ;
		"turnos.fechatur >= medpresta.fecvigend and " + mcjoin +;
		"turnos.fechatur <  medpresta.fecvigenh and " + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
		'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
		"turnos.fechatur >= ?mfectur1 and " + ;
		"turnos.fechatur <= ?mfectur2 " + mccpoamb +;
		"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva, turnos.hhmmtur,turnos.codprest   " + ;
		"", "mwkphorario4")
	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_phorarios5'
		Cancel
	Endif
Endif
mihora = sp_busco_fecha_serv("DT")
midia = Ttod(mihora)

Select fechatur, Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, Iif(confirmado = 1,'SI','NO' ) As confirma, ;
	left(reg_nrohclinica, 10) As reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, REG_numdocumento,Reg_email,REG_bloq_comen, observa, ;
	iif(Isnull(fechaobserva),"                   ",Ttoc(fechaobserva)) As fechaobserva, ;
	fechanac,;
	nvl(medsolicita,Space(50)) As medsolicita, nombre, horatur, mwkphorario1.Id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia,UsuarioSector,tipotomado, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale,fechaconfirma , sala ;
	,Ttoc(hdesde1,2) As hdesde1, hhasta1, '*' + Str(diasem,1) + Strtran(Str(codmed,4), ' ', '0') + ;
	strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + Substr(Ttoc(hdesde1,2), 4,2) +'*' As codbarra ;
	,prg_edad(Nvl(fechanac,mfectur1),mfectur1,"N") As edad,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ;
	,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0000 ) As demora, usuariogenera;
	from mwkphorario1 ;
	left Join mwkpent On codent = ent_codent ;
	left Join mwkpesp On codesp = esp_codesp ;
	left Join mwkpmed On codmed = mwkpmed.Id ;
	left Join mwkppres On codprest = pre_codprest ;
	order By horatur, afiliado;
	into Cursor mwkphorario5

Select fechatur, Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, Iif(confirmado =1,'SI','NO' )  As confirma, ;
	left(reg_nrohclinica, 10) As reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, REG_numdocumento,Reg_email,Space(200) As REG_bloq_comen, observa, ;
	iif(Isnull(fechaobserva),"                   ",Ttoc(fechaobserva)) As fechaobserva, ;
	fechanac, ;
	nvl(medsolicita,Space(50)) As medsolicita,nombre, horatur, mwkphorario3.Id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia,UsuarioSector,tipotomado, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, fechaconfirma ,sala ;
	,Ttoc(hdesde1,2) As hdesde1, hhasta1, '*' + Str(diasem,1) + Strtran(Str(codmed,4), ' ', '0') + ;
	strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + Substr(Ttoc(hdesde1,2), 4,2) +'*' As codbarra ;
	,Int((mfectur1-Nvl(fechanac,mfectur1))/365) As edad ,esp_descripcion,hhmmtur ,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ;
	,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0000 ) As demora, usuariogenera;
	from mwkphorario3 ;
	left Join mwkpent On codent = ent_codent ;
	left Join mwkpesp On codesp = esp_codesp ;
	left Join mwkpmed On codmed = mwkpmed.Id ;
	left Join mwkppres On codprest = pre_codprest ;
	order By horatur, afiliado;
	into Cursor mwkphorario7

If mfectur1 <= mfechalimite

	Select fechatur, Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, Iif(confirmado = 1,'SI','NO' )  As confirma, ;
		left(reg_nrohclinica, 10) As reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, REG_numdocumento,Reg_email,REG_bloq_comen, observa, ;
		iif(Isnull(fechaobserva),"                   ",Ttoc(fechaobserva)) As fechaobserva, ;
		fechanac, ;
		nvl(medsolicita,Space(50)) As medsolicita,nombre, horatur, mwkphorario2.Id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia,UsuarioSector,tipotomado, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
		ent_turnoshabilit, ent_fecpas, afiliado, nrovale,fechaconfirma , sala ;
		,Ttoc(hdesde1,2)As hdesde1, hhasta1, '*' + Str(diasem,1) + Strtran(Str(codmed,4), ' ', '0') + ;
		strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + Substr(Ttoc(hdesde1,2), 4,2) +'*' As codbarra ;
		,Int((mfectur1-Nvl(fechanac,mfectur1))/365) As edad,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  ;
		,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0000 ) As demora, usuariogenera;
		from mwkphorario2 ;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkpmed On codmed = mwkpmed.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		order By horatur, afiliado;
		into Cursor mwkphorario6

	Select fechatur, Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, Iif(confirmado = 1,'SI','NO' )  As confirma, ;
		left(reg_nrohclinica, 10) As reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado,  REG_numdocumento,Reg_email,Space(200) As REG_bloq_comen, observa, ;
		iif(Isnull(fechaobserva),"                   ",Ttoc(fechaobserva)) As fechaobserva, ;
		fechanac, ;
		nvl(medsolicita,Space(50)) As medsolicita,nombre, horatur, mwkphorario4.Id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia,UsuarioSector,tipotomado, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
		ent_turnoshabilit, ent_fecpas, afiliado, nrovale,fechaconfirma , sala ;
		,Ttoc(hdesde1,2)As hdesde1, hhasta1, '*' + Str(diasem,1) + Strtran(Str(codmed,4), ' ', '0') + ;
		strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + Substr(Ttoc(hdesde1,2), 4,2) +'*' As codbarra ;
		,Int((mfectur1-Nvl(fechanac,mfectur1))/365) As edad ,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  ;
		,Iif(midia =fechatur And horatur<mihora And confirmado= 0,Int((mihora-horatur)/60),0000 ) As demora, usuariogenera;
		from mwkphorario4 ;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkpmed On codmed = mwkpmed.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		order By horatur, afiliado;
		into Cursor mwkphorario8


	If Reccount('mwkphorario8')>0
		Select * From mwkphorario6 ;
			union ;
			select * From mwkphorario8 ;
			into Cursor mwkphorari
	Else
		Select * From mwkphorario6 ;
			into Cursor mwkphorari
	Endif
	If Reccount('mwkphorario7')>0
		Select * From mwkphorario5 ;
			union ;
			select * From mwkphorario7 ;
			into Cursor mwkphoraria
	Else
		Select * From mwkphorario5 ;
			into Cursor mwkphoraria
	Endif

	If Reccount('mwkphoraria')>0
		Select * From mwkphorari ;
			union ;
			select * From mwkphoraria ;
			into Cursor mwkphorarioo
	Else
		Select * From mwkphorari ;
			into Cursor mwkphorarioo
	Endif
	Select mwkphorari
	Use
	Select mwkphoraria
	Use
	Select mwkphorario2
	Use
	Select mwkphorario4
	Use
	Select mwkphorario6
	Use
	Select mwkphorario8
	Use

Else
	mcunion = ''
	If mlibres =1 &&& busca turnos libres
		msql_presta = mxcodprest
		msql_codmed = midmedico
		msql_fecha = sp_busco_fecha_serv("DD")
		mbusqueda =''
		If msql_presta >0
			mbusqueda = " medpresta.codprest = ?msql_presta and "
		Endif
		mbusqueda = mbusqueda + "  medpresta.codmed = ?msql_codmed "
		mret = SQLExec(mcon1, "select codmed, diasem, horadesde, horahasta, codprest, sala, " + ;
			"fecvigend, fecvigenh, hdesde1, hhasta1,hhmmdes,hhmmhas,duracion as durtur,reservados,nombre " + ;
			"from medpresta,prestadores " + ;
			"where &mbusqueda " + mccpoambm+;
			" and diasem > 0 and generaagen = 1 and medpresta.codmed = prestadores.id and " + ;
			"fecvigenh > ?msql_fecha and fecvigenh <>fecvigend " , "mwkmedp")

		mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
			'turnos.diasem, turnos.codprest,   ' + ;
			'turnos.codreserva, turnos.codserv,  ' + ;
			'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva,' + ;
			'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia,turnos.UsuarioSector,turnos.tipotomado, ' + ;
			'turnos.afiliado, turnos.nrovale, turnos.fechaconfirma, medpresta.sala, ' + ;
			'hdesde1, hhasta1  ,hhmmtur, turnos.usuariogenera  ' +;
			'from turnos '+;
			' inner join medpresta on (' + ;
			'turnos.codmed   = medpresta.codmed and ' + ;
			'turnos.diasem	 = medpresta.diasem and ' + mcjoin +;
			'turnos.fechatur >= medpresta.fecvigend and ' + ;
			'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
			'turnos.fechatur <  medpresta.fecvigenh and ' + ;
			'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
			'turnos.hhmmtur < medpresta.hhmmhas )' + ;
			'where &msel_med afiliado = 0 and tipoturno<>9 and ' + ;
			'turnos.fechatur >= ?mfectur1 and ' +;
			'turnos.fechatur <= ?mfectur2 ' + mccpoamb +;
			'group by turnos.fechatur, turnos.hhmmtur,turnos.codprest  ' + ;
			'', 'mwkphorariol')

		Select fechatur, Left(Ttoc(horatur,2), 5) As hora,Space(40) As reg_nombrepac, ;
			Padr("Disponible",45) As ent_descrient, Space(48) As pre_descriprest, Space(10) As codreserva, 'LI'  As confirma, ;
			SPACE(10) As reg_nrohclinica, Space(20) As reg_telefonos, Space(15) As  usuario,Ctot("  /  /  ") As  fechatomado, ;
			SPACE(20) As afi_nroafiliado, 000000000000 As REG_numdocumento,Space(50) As Reg_email,Space(200) As REG_bloq_comen,;
			SPACE(100) As  observa, "                   " As fechaobserva, ;
			ctod("  /  /  ") As fechanac, ;
			Space(50) As medsolicita,nombre, horatur, mwkphorariol.Id, 0000 As codent, mwkphorariol.codmed, 0000 As codmedsoli, ;
			tipoturno, 0 As solicigia,1 As UsuarioSector,1 As tipotomado,'    ' As  codesp,0000000000 As  codprest, mwkphorariol.diasem,0 As confirmado,0000 As codserv,;
			ctod("  /  /  ") As  afi_fechabaja, ;
			"S" As ent_turnoshabilit, Ctod("  /  /  ") As ent_fecpas, afiliado, nrovale, Ctod("  /  /  ") As fechaconfirma ,mwkphorariol.sala ;
			,Ttoc(mwkphorariol.hdesde1,2) As hdesde1, mwkphorariol.hhasta1, '*' + Str(mwkphorariol.diasem,1) + Strtran(Str(mwkphorariol.codmed,4), ' ', '0') + ;
			strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(mwkphorariol.hdesde1,2), 2) + Substr(Ttoc(mwkphorariol.hdesde1,2), 4,2) +'*' As codbarra ;
			,000 As edad ,Space(20) As esp_descripcion,hhmmtur ,0 As pre_tipomuestra,0 as PRE_Lateralidad ,0 as PRE_tipozona ,000 As demora,Space(15) As  usuariogenera;
			From mwkphorariol,mwkmedp ;
			WHERE mwkphorariol.codmed   = mwkmedp.codmed And ;
			mwkphorariol.diasem	 = mwkmedp.diasem And ;
			mwkphorariol.fechatur >= mwkmedp.fecvigend And ;
			mwkmedp.fecvigend <> mwkmedp.fecvigenh And;
			mwkphorariol.fechatur <  mwkmedp.fecvigenh And ;
			mwkphorariol.hhmmtur >= mwkmedp.hhmmdes And ;
			mwkphorariol.hhmmtur < mwkmedp.hhmmhas ;
			GROUP By horatur, afiliado   Order By horatur, afiliado Into Cursor mwkphorariol1

		mcunion = " union select * From mwkphorariol1 "

	Endif

	If Reccount('mwkphorario7')>0
		Select * From mwkphorario5 ;
			union ;
			select * From mwkphorario7 &mcunion ;
			into Cursor mwkphorarioo
	Else
		Select * From mwkphorario5 &mcunion ;
			into Cursor mwkphorarioo
	Endif
Endif
If lvales = 1
	Do sp_busco_vales_ambu With mfectur1,mfectur2,midmedico , 'mwkdemanda'

	Select  fechatur, Left(Ttoc(horatur,2), 5) As hora,  reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, 'DE'  As confirma, ;
		reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, REG_numdocumento, Reg_email, REG_bloq_comen,;
		SPACE(100) As  observa, "                   " As fechaobserva, ;
		fechanac, Space(50) As medsolicita, nombre, horatur, mwkdemanda.Id,;
		codent,  codmed, codmedsoli, 0 As tipoturno, 0 As solicigia,1 As UsuarioSector,;
		1 As tipotomado, codesp, codprest, Dow(fechatur) As diasem,1 As confirmado,codserv,;
		afi_fechabaja, ent_turnoshabilit, ent_fecpas, afiliado, nrovale, fechatomado As  fechaconfirma ,Space(10) As sala ;
		,'00:00:00' As hdesde1, Datetime() As hhasta1, '*' + Str(Dow(fechatur),1) + Strtran(Str(codmed,4), ' ', '0') + ;
		strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  '00'+ '23' +'*' As codbarra ;
		,000 As edad , esp_descripcion,Int(Val(Strtran(Left(Ttoc(horatur,2), 5),":",""))) As hhmmtur , pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,000 As demora, usuariogenera;
		From mwkdemanda;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkpmed On codmed = mwkpmed.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		into Cursor mwkdemandatur
	If Reccount('mwkphorarioo')>0
		Select * From mwkdemandatur Union All Select * From mwkphorarioo;
			INTO Cursor mwkphorarioo1
	Else
		Select * From mwkdemandatur ;
			INTO Cursor mwkphorarioo1
	Endif
	Select * From mwkphorarioo1 Into Cursor mwkphorarioo
Endif

Select mwkphorarioo.*,mwkconsultorio.interno,abreviatura From mwkphorarioo;
	left Outer Join mwkconsultorio On mwkconsultorio.lugar = mwkphorarioo.sala ;
	inner Join mwktt On mwktt.tt = mwkphorarioo.tipoturno ;
	into Cursor mwkphorario

msql = "select * from mwkphorario "+;
	"order by fechatur, codmed,horatur into cursor mwkphorarios"

Select mwkphorario1
Use
Select mwkphorario3
Use
Select mwkphorario5
Use
Select mwkphorario7
Use

