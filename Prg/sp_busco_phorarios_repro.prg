***
*** Generacion de planilla de Turnos
***
parameter mfectur1, mfectur2, midmedico,lsinMK


if mxambito >1
	mccpoambbf = ' codambito = ?mxambito and '
	mccpoamb = "  turnos.codambito = ?mxambito and "
	mcjoin = 	" medpresta.codambito = turnos.codambito and "
else
	mccpoambbf = ' '
	mccpoamb = ''	
	mcjoin = ''
endif
If Vartype(lsinMK)="N"
	mccpoamb  = mccpoamb + ' usuariogenera <> "TURNOSMARKEY" AND '
Endif
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoambbf id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_repro_1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha


&& busco en turnos
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
	'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
	'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento,registracio.REG_bloq_comen, ' + ;
	'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
	'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.codserv, ' + ;
	'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
	'AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.afiliado, turnos.nrovale, medpresta.sala,TabTipoTurno.grupo,registracio.REG_email ' + ;
	'from turnos , prestadores, registracio, prestacions, entidades, afiliacion, medpresta,TabTipoTurno ' + ;
	'where &mccpoamb turnos.codmed = prestadores.id and ' + ;
	'turnos.codprest = prestacions.pre_codprest and '  + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
	'turnos.codent = afiliacion.AFI_codentidad and ' + ;
	'turnos.codent = entidades.ENT_codent and ' + ;
	'turnos.codmed   = medpresta.codmed and ' + ;
	'turnos.codprest = medpresta.codprest and ' + ;
	'turnos.diasem	 = medpresta.diasem and ' + mcjoin +;
	'turnos.fechatur >= medpresta.fecvigend and ' + ;
	'turnos.fechatur <  medpresta.fecvigenh and ' + ;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	'turnos.hhmmTur >= medpresta.hhmmDes and ' + ;
	'turnos.hhmmTur < medpresta.hhmmHas and ' + ;
	'turnos.tipoturno = TabTipoTurno.TipoTurno and '+;
	' TabTipoTurno.grupo in (0,1,2,3) and ' + ;
	'turnos.codmed = ?midmedico and ' + ;
	'turnos.fechatur >= ?mfectur1 and ' + ;
	'turnos.fechatur <= ?mfectur2 and ' + ;
	'turnos.afiliado > 0 ' + ;
	'order by turnos.fechatur, turnos.horatur, AFI_nroafiliado', 'mwkphorario1')

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_repro_2'
	cancel
endif
&& busco en turnoshis
if mfectur1 <= mfechalimite
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
		'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento,registracio.REG_bloq_comen, ' + ;
		'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.codserv, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.afiliado, turnos.nrovale, medpresta.sala,TabTipoTurno.grupo,registracio.REG_email ' + ;
		'from turnoshis as turnos , prestadores, registracio, prestacions, entidades, afiliacion, medpresta,TabTipoTurno ' + ;
		'where &mccpoamb turnos.codmed = prestadores.id and ' + ;
		'turnos.codprest = prestacions.pre_codprest and '  + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.AFI_codentidad and ' + ;
		'turnos.codent = entidades.ENT_codent and ' + ;
		'turnos.codmed   = medpresta.codmed and ' + ;
		'turnos.codprest = medpresta.codprest and ' + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		'turnos.diasem	 = medpresta.diasem and ' + mcjoin +;
		'turnos.fechatur >= medpresta.fecvigend and ' + ;
		'turnos.fechatur <  medpresta.fecvigenh and ' + ;
		'turnos.hhmmTur >= medpresta.hhmmDes and ' + ;
		'turnos.hhmmTur < medpresta.hhmmHas and ' + ;
		'turnos.tipoturno = TabTipoTurno.TipoTurno and '+;
		' TabTipoTurno.grupo in (0,1,2,3) and ' + ;
		'turnos.codmed = ?midmedico and ' + ;
		'turnos.fechatur >= ?mfectur1 and ' + ;
		'turnos.fechatur <= ?mfectur2 and ' + ;
		'turnos.afiliado > 0 ' + ;
		'order by turnos.fechatur, turnos.horatur, AFI_nroafiliado', 'mwkphorario2')
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios_repro_3'
		cancel
	endif

&& busco pre_registrados en turnoshis
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
		"turnos.diasem, turnos.codprest, prestadores.nombre, preregistra.afiliado as AFI_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento," + ;
		"(preregistra.nombre) as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
		"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.codserv, " + ;
		"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
		"preregistra.fechabaja as AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.afiliado, " + ;
		"turnos.nrovale, medpresta.sala,TabTipoTurno.grupo " + ;
		"from turnoshis as turnos, prestadores, preregistra, prestacions, entidades, medpresta,TabTipoTurno  " + ;
		"where &mccpoamb turnos.codmed = prestadores.id and " + ;
		"turnos.codprest = prestacions.pre_codprest and "  + ;
		"turnos.afiliado = preregistra.id and " + ;
		"turnos.codent = entidades.ENT_codent and " + ;
		"turnos.codmed   = medpresta.codmed and " + ;
		"turnos.codprest = medpresta.codprest and " + ;
		"turnos.diasem	 = medpresta.diasem and " + mcjoin +;
		"turnos.fechatur >= medpresta.fecvigend and " + ;
		'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		"turnos.fechatur <  medpresta.fecvigenh and " + ;
		'turnos.hhmmTur >= medpresta.hhmmDes and ' + ;
		'turnos.hhmmTur < medpresta.hhmmHas and ' + ;
		"turnos.codmed = ?midmedico and " + ;
		"turnos.fechatur >= ?mfectur1 and " + ;
		"turnos.fechatur <= ?mfectur2 and " + ;
		'turnos.tipoturno = TabTipoTurno.TipoTurno and '+;
		' TabTipoTurno.grupo in (0,1,2,3) and ' + ;
		"turnos.afiliado > 0 " + ;
		"order by turnos.fechatur, turnos.horatur", "mwkphorario4")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_phorarios_repro_4'
		cancel
	endif

endif
&& busco pre_registrados
mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
	"turnos.diasem, turnos.codprest, prestadores.nombre, preregistra.afiliado as AFI_nroafiliado, " + ;
	"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
	"(preregistra.nombre) as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.codserv, " + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, " + ;
	"preregistra.fechabaja as AFI_fechabaja, ENT_turnoshabilit, ENT_fecpas, turnos.afiliado, " + ;
	"turnos.nrovale, medpresta.sala,TabTipoTurno.grupo " + ;
	"from turnos, prestadores, preregistra, prestacions, entidades, medpresta,TabTipoTurno " + ;
	"where " + mccpoamb + " turnos.codmed = prestadores.id and " + ;
	"turnos.codprest = prestacions.pre_codprest and "  + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.codent = entidades.ENT_codent and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + ;
	"turnos.diasem	 = medpresta.diasem and " + mcjoin +;
	'medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	'turnos.hhmmTur >= medpresta.hhmmDes and ' + ;
	'turnos.hhmmTur < medpresta.hhmmHas and ' + ;
	"turnos.codmed = ?midmedico and " + ;
	"turnos.fechatur >= ?mfectur1 and " + ;
	"turnos.fechatur <= ?mfectur2 and " + ;
	'turnos.tipoturno = TabTipoTurno.TipoTurno and '+;
	' TabTipoTurno.grupo in (0,1,2,3) and ' + ;
	"turnos.afiliado > 0 " + ;
	"order by turnos.fechatur, turnos.horatur", "mwkphorario3")


if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios_repro_5'
	cancel
else

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
		left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
		AFI_nroafiliado, REG_numdocumento,REG_bloq_comen, observa, nombre, horatur, id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, AFI_fechabaja, ;
		ENT_turnoshabilit, ENT_fecpas, afiliado, nrovale, sala,grupo,REG_email  ;
		from mwkphorario1 into cursor mwkphorario5

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
		left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
		AFI_nroafiliado, REG_numdocumento,space(200) as REG_bloq_comen, observa, nombre, horatur, id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, AFI_fechabaja, ;
		ENT_turnoshabilit, ENT_fecpas, afiliado, nrovale, sala,grupo,space(50) as REG_email   ;
		from mwkphorario3 into cursor mwkphorario7


	if mfectur1 <= mfechalimite
		select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
			ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
			left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
			AFI_nroafiliado, REG_numdocumento,REG_bloq_comen, observa, nombre, horatur, id, codent, codmed, codmedsoli, ;
			tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, AFI_fechabaja, ;
			ENT_turnoshabilit, ENT_fecpas, afiliado, nrovale, sala,grupo,REG_email   ;
			from mwkphorario2 into cursor mwkphorario6

		select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
			ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 1,'SI','NO' )  as confirma, ;
			left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
			AFI_nroafiliado, REG_numdocumento,space(200) as REG_bloq_comen, observa, nombre, horatur, id, codent, codmed, codmedsoli, ;
			tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, AFI_fechabaja, ;
			ENT_turnoshabilit, ENT_fecpas, afiliado, nrovale, sala,grupo,space(50) as REG_email   ;
			from mwkphorario4 into cursor mwkphorario8

		select * from mwkphorario5 ;
			union ;
			select * from mwkphorario6 ;
			union ;
			select * from mwkphorario7 ;
			union ;
			select * from mwkphorario8;
			into cursor mwkphorario
	else
		select * from mwkphorario5 ;
			union ;
			select * from mwkphorario7 ;
			into cursor mwkphorario
	endif

	msql = "select * from mwkphorario order by fechatur, horatur into cursor mwkphorarios"

	if mfectur1 <= mfechalimite
		select mwkphorario1
		use
		select mwkphorario2
		use
		select mwkphorario3
		use
		select mwkphorario4
		use
		select mwkphorario5
		use
		select mwkphorario6
		use
		select mwkphorario7
		use
		select mwkphorario8
		use
	else
		select mwkphorario1
		use

		select mwkphorario3
		use

		select mwkphorario5
		use

		select mwkphorario7
		use

	endif
endif
