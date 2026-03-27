***
*** Generacion de planilla de Turnos
***
Parameter mfectur1,lxcentro
If Vartype(lxcentro)<>"N"
	lxcentro=0
Endif

lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoambbf id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios1'
	Cancel
Endif
Go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use in mwkctrlfecha
mccpocmed = ''
mccentro =''
Do Case
Case lxcentro= 0 OR mxambito>0
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
 
mccpoambbf  = ''
if mxambito >1
	mccpoamb = "   and medpresta.codambito = ?mxambito and turnos.codambito = ?mxambito "
	mccpoambbf = ' codambito = ?mxambito and '
endif
If !used('mwkpmed')
	Do sp_busco_phordatos
Endif
&& busco en turnos
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
	'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv,  ' + ;
	'registracio.reg_nombrepac, ' + ;
	'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, ' + ;
	'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
	'afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala ' + ;
	',hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur,prestadores.nombre as medsolicita ' +;
	'from turnos , registracio, afiliacion, medpresta ' + ;
	'left join Prestadores on Prestadores.Id = turnos.CodMedsoli '+;
	'where ' + ;
	'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.afi_codentidad and ' + ;
	'turnos.codmed   = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' +;
	'turnos.diasem	 = medpresta.diasem and ' + ;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
	'turnos.fechatur = ?mfectur1 ' + mccpoamb +;
	'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva, turnos.hhmmtur ' + ;
	'', 'mwkphorario1')
&& busco pre_registrados
*	'turnos.afiliado > 0 '
&&	"turnos.tipoturno < 8 and "
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios2'
	Cancel
Endif

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
	"turnos.diasem, turnos.codprest, preregistra.afiliado as afi_nroafiliado, " + ;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento, " + ;
	"(preregistra.nombre) as reg_nombrepac, " + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
	"preregistra.fechabaja as afi_fechabaja, turnos.afiliado, " + ;
	"turnos.nrovale, medpresta.sala " + ;
	',hdesde1, hhasta1 , fechanac,hhmmtur,prestadores.nombre as medsolicita ' +;
	"from turnos, preregistra, medpresta " + ;
	"left join Prestadores on Prestadores.Id = turnos.CodMedsoli "+;
	"where  " + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	'turnos.hhmmtur >= medpresta.hhmmdes and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.hhmmtur < medpresta.hhmmhas and ' + ;
	"turnos.fechatur = ?mfectur1 " + mccpoamb+ ;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva, turnos.hhmmtur  " + ;
	"", "mwkphorario3")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios3'
	Cancel
Endif
&&& busco los posibles errores
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and turnos.codambito = ?mxambito "
endif

mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, reg_telefonos, turnos.codreserva, ' + ;
	'registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv,  ' + ;
	'registracio.reg_nombrepac, turnos.fechatomado, turnos.usuario, turnos.confirmado, '+;
	'turnos.observa, turnos.fechaobserva,turnos.codent, turnos.codmed, turnos.codmedsoli,'+;
	' turnos.tipoturno, turnos.solicigia, ' + ;
	'turnos.afiliado, turnos.nrovale ' + ;
	',reg_fecnacimiento as fechanac,hhmmtur,prestadores.nombre as medsolicita ' +;
	'from turnos , registracio ' + ;
	'left join Prestadores on Prestadores.Id = turnos.CodMedsoli '+;
	'where ' + ;
	'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	'turnos.fechatur = ?mfectur1 ' + mccpoamb+;
	'group by turnos.fechatur, afiliado, turnos.codreserva, turnos.hhmmtur ' + ;
	'', 'mwkpthorario1')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_pthorarios2'
	Cancel
Endif

Select mwkpthorario1.*, ctot('  /  /    ') as hdesde1,ctot('  /  /    ') as hhasta1, space(20) as sala;
	from mwkpthorario1 into cursor mwkpthorario1

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, "+;
	"preregistra.telefono as REG_telefonos, turnos.diasem, turnos.codprest, "+;
	"turnos.codreserva, ('0000000000') as reg_nrohclinica, "+;
	"nrodocumento as reg_numdocumento, (preregistra.nombre) as reg_nombrepac, " + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, "+;
	"turnos.codserv, turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, "+;
	"turnos.solicigia, turnos.afiliado, turnos.nrovale, fechanac,hhmmtur,prestadores.nombre as medsolicita  " +;
	"from turnos, preregistra " + ;
	"left join Prestadores on Prestadores.Id = turnos.CodMedsoli "+;
	"where  " + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.fechatur = ?mfectur1 " + mccpoamb+;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva, turnos.hhmmtur  " + ;
	"", "mwkpthorario3")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_pthorarios3'
	Cancel
Endif

* 09-02-2011 se agregan campos hdesde1,hhasta1,sala
Select mwkpthorario3.*, ctot('  /  /    ') as hdesde1, ctot('  /  /    ') as hhasta1, space(20) as sala;
	from mwkpthorario3 into cursor mwkpthorario3


Select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	fechanac,nvl(medsolicita,space(50)) as medsolicita, ;
	nombre, horatur, mwkphorario1.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + substr(ttoc(hdesde1,2), 4,2) + '*' as codbarra ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ;
	from mwkphorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario5

Select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	fechanac,nvl(medsolicita,space(50)) as medsolicita, ;
	nombre, horatur, mwkphorario3.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, sala ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + substr(ttoc(hdesde1,2), 4,2) + '*' as codbarra ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad ,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ;
	from mwkphorario3 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario7

&&todos los turnos

* 09-02-2011 se agregan campos hdesde1,hhasta1,sala, codbarra

Select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afiliado as afi_nroafiliado,;
	reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	fechanac,nvl(medsolicita,space(50)) as medsolicita, ;
	nombre, horatur, mwkpthorario1.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + substr(ttoc(hdesde1,2), 4,2) + '*' as codbarra,sala ;
	from mwkpthorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkpthorario5

* 09-02-2011 se agregan campos hdesde1,hhasta1,sala, codbarra

Select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, iif(confirmado =1,'SI','NO' )  as confirma, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
	afiliado as afi_nroafiliado,;
	reg_numdocumento, observa, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	fechanac,nvl(medsolicita,space(50)) as medsolicita, ;
	nombre, horatur, mwkpthorario3.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad ,esp_descripcion,hhmmtur,pre_tipomuestra,PRE_Lateralidad ;
	,ttoc(hdesde1,2) as hdesde1, hhasta1, '*' + str(diasem,1) + strtran(str(codmed,4), ' ', '0') + ;
	strtran(substr(dtoc(fechatur),1, 5),'/','') +  left(ttoc(hdesde1,2), 2) + substr(ttoc(hdesde1,2), 4,2) + '*' as codbarra,sala ;
	from mwkpthorario3 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest where afiliado>1 ;
	order by horatur, afiliado;
	into cursor mwkpthorario7

Select * from mwkphorario5 ;
	union ;
	select * from mwkphorario7 ;
	into cursor mwkphorari

Select * from mwkpthorario5 ;
	union ;
	select * from mwkpthorario7 ;
	into cursor mwkpthoraria

* 09-02-2011 se agrega campo interno

Select *,0 as interno from mwkpthoraria where codreserva not in ( select codreserva from mwkphorari) into cursor mwkphorario

msql = "select * from mwkphorario order by fechatur, codmed,horatur into cursor mwkphorarios"

