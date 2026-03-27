***
*** Generacion de planilla de Turnos
***
parameter mfectur1, mfectur2, midmedico, mcodesp , msel_med

if type ('msel_med')#"C"
	msel_med =	' turnos.codmed = ?midmedico and '
endif

if type('mcodesp') # "C"
	msel_esp = ""
else
	msel_esp = " turnos.codesp = ?mcodesp and "
endif

lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

if !used('mwkpmed')
	do sp_busco_phordatos
endif
&& busco en turnos
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
	'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv,  ' + ;
	'registracio.reg_nombrepac, ' + ;
	'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, ' + ;
	'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
	'afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala ' + ;
	',hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur,UsuarioSector,TIPOTOMADO        ' +;
	'from turnos , registracio, afiliacion, medpresta ' + ;
	'where ' + ;
	'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.afi_codentidad and ' + ;
	'turnos.codmed   = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' + msel_esp + msel_med +;
	'turnos.diasem	 = medpresta.diasem and ' + ;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
	'turnos.fechatur >= ?mfectur1 and ' + ;
	'turnos.fechatur <= ?mfectur2 ' + ;
	'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
	'', 'mwkphorario1')
&& busco pre_registrados
*	'turnos.afiliado > 0 '
&&	"turnos.tipoturno < 8 and "
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios2'
	cancel
endif
mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado, " + ;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento, " + ;
	"(preregistra.nombre) as reg_nombrepac, " + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
	"preregistra.fechabaja as afi_fechabaja, turnos.afiliado, " + ;
	"turnos.nrovale, medpresta.sala " + ;
	',hdesde1, hhasta1 , fechanac,hhmmtur,UsuarioSector,TIPOTOMADO        ' +;
	"from turnos, preregistra, medpresta " + ;
	"where  " + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + msel_esp +msel_med+;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
	"turnos.fechatur >= ?mfectur1 and " + ;
	"turnos.fechatur <= ?mfectur2  " + ;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
	"", "mwkphorario3")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios3'
	cancel
endif

&& busco en turnoshis
if mfectur1 <= mfechalimite
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, ' + ;
		'registracio.reg_nombrepac, ' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala ' + ;
		',hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur,UsuarioSector,TIPOTOMADO        ' +;
		'from turnoshis as turnos , registracio, afiliacion, medpresta ' + ;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + msel_esp +msel_med+;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' + ;
		'turnos.codmed   = medpresta.codmed and ' + ;
		'turnos.codprest = medpresta.codprest and ' + ;
		'turnos.diasem	 = medpresta.diasem and ' + ;
		'turnos.fechatur >= medpresta.fecvigend and ' + ;
		'turnos.fechatur <  medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
		'turnos.fechatur >= ?mfectur1 and ' + ;
		'turnos.fechatur <= ?mfectur2 ' + ;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario2')
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios4'
		cancel
	endif
&& busco pre_registrados en turnoshis
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, "+;
		"preregistra.telefono as reg_telefonos, " + ;
		"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento, " + ;
		"(preregistra.nombre) as reg_nombrepac, " + ;
		"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, " + ;
		"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
		"preregistra.fechabaja as afi_fechabaja, turnos.afiliado, " + ;
		"turnos.nrovale, medpresta.sala " + ;
		',hdesde1, hhasta1 ,fechanac,hhmmtur,UsuarioSector,TIPOTOMADO        ' +;
		"from turnoshis as turnos, preregistra, medpresta " + ;
		"where  " + ;
		"turnos.afiliado = preregistra.id and " + ;
		"turnos.codmed   = medpresta.codmed and " + ;
		"turnos.codprest = medpresta.codprest and " + msel_esp +msel_med+;
		"turnos.diasem	 = medpresta.diasem and " + ;
		"turnos.fechatur >= medpresta.fecvigend and " + ;
		"turnos.fechatur <  medpresta.fecvigenh and " + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
		'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
		"turnos.fechatur >= ?mfectur1 and " + ;
		"turnos.fechatur <= ?mfectur2 " + ;
		"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
		"", "mwkphorario4")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios5'
		cancel
	endif
endif

select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	nombre, horatur, mwkphorario1.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion,hhmmtur,UsuarioSector,TIPOTOMADO     ;
	from mwkphorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario5

select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	nombre, horatur, mwkphorario3.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad ,esp_descripcion,hhmmtur,UsuarioSector,TIPOTOMADO    ;
	from mwkphorario3 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario7

if mfectur1 <= mfechalimite

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, reg_numdocumento, observa, ;
		iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
		nombre, horatur, mwkphorario2.id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
		ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
		,ttoc(hdesde1,2)as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra ;
		,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion,hhmmtur,UsuarioSector,TIPOTOMADO     ;
		from mwkphorario2 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkpmed on codmed = mwkpmed.id ;
		left join mwkppres on codprest = pre_codprest ;
		order by horatur, afiliado;
		into cursor mwkphorario6

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, reg_numdocumento, observa, ;
		iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
		nombre, horatur, mwkphorario4.id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
		ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
		,ttoc(hdesde1,2)as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
		strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + '*' as codbarra ;
		,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad ,esp_descripcion,hhmmtur,UsuarioSector,TIPOTOMADO     ;
		from mwkphorario4 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkpmed on codmed = mwkpmed.id ;
		left join mwkppres on codprest = pre_codprest ;
		order by horatur, afiliado;
		into cursor mwkphorario8


	if reccount('mwkphorario8')>0
		select * from mwkphorario6 ;
			union ;
			select * from mwkphorario8 ;
			into cursor mwkphorari
	else
		select * from mwkphorario8 ;
			into cursor mwkphorari
	endif
 	if reccount('mwkphorario7')>0
		select * from mwkphorario5 ;
			union ;
			select * from mwkphorario7 ;
			into cursor mwkphoraria
	else
		select * from mwkphorario5 ;
			into cursor mwkphoraria
	endif

 	if reccount('mwkphoraria')>0
		select * from mwkphorari ;
			union ;
			select * from mwkphoraria ;
			into cursor mwkphorario
	else
		select * from mwkphorari ;
			into cursor mwkphorario
	endif
	select mwkphorari
	use
	select mwkphoraria
	use
	select mwkphorario2
	use
	select mwkphorario4
	use
	select mwkphorario6
	use
	select mwkphorario8
	use

else
	if reccount('mwkphorario7')>0
		select * from mwkphorario5 ;
			union ;
			select * from mwkphorario7 ;
			into cursor mwkphorario
	else
		select * from mwkphorario5 ;
			into cursor mwkphorario
	endif
endif

msql = "select * from mwkphorario order by fechatur, codmed,horatur into cursor mwkphorarios"

select mwkphorario1
use
select mwkphorario3
use
select mwkphorario5
use
select mwkphorario7
use

