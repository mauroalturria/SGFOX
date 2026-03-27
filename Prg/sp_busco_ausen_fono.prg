***
*** Generacion de planilla de Turnos de un afiliado
***

parameter mafili

&& busco en turnos
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, turnos.confirmado, ' + ;
				'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
				'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.usuario, turnos.fechatomado ' + ;
				'from turnos , prestadores, registracio, prestacions, entidades, afiliacion ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
						'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
						'turnos.codent = afiliacion.AFI_codentidad and ' + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.tipoturno < 9 and ' + ;
						'turnos.afiliado = ?mafili ' + ;
				'group by turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva ' + ;				
				'order by turnos.fechatur, turnos.codmed, turnos.horatur', 'mwkphorario3')

&& busco en turnoshis
mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, turnos.confirmado, ' + ;
				'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
				'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.usuario, turnos.fechatomado ' + ;
				'from turnoshis as turnos , prestadores, registracio, prestacions, entidades, afiliacion ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
						'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
						'turnos.codent = afiliacion.AFI_codentidad and ' + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.tipoturno < 9 and ' + ;
						'turnos.afiliado = ?mafili ' + ;
				'group by turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva ' + ;				
				'order by turnos.fechatur, turnos.codmed, turnos.horatur', 'mwkphorario4')


&& busco los cancelados
mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
				"turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, cast(3 as integer) as confirmado, " + ;
				"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
				"registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
				"turnos.usucancela as usuario, turnos.feccancela as fechatomado " + ;
				"from turnoscancel as turnos , prestadores, registracio, prestacions, entidades, afiliacion " + ;
				"where turnos.codmed = prestadores.id and " + ;
						"turnos.codprest = prestacions.pre_codprest and " + ;
						"turnos.afiliado = registracio.REG_nroregistrac and " + ;
						"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
						"turnos.codent = afiliacion.AFI_codentidad and " + ;
						"turnos.codent = entidades.ENT_codent and " + ;
						"turnos.afiliado = ?mafili " + ;
				"group by turnos.fechatur, turnos.codmed, AFI_nroafiliado, turnos.codreserva " + ;		
				"order by turnos.fechatur, turnos.codmed, turnos.horatur", "mwkphorario5")

	select * from mwkphorario3 ;
		union all ;
			select * from mwkphorario4 ;
				union all ;
					select * from mwkphorario5 ;
					into cursor mwkphorario2
				
if eof('mwkphorario2')

	&& busco en turnos
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, turnos.afiliado as AFI_nroafiliado, ' + ;
				'turnos.confirmado, turnos.codreserva, 0 as REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, ' + ;
				'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.usuario, turnos.fechatomado ' + ;
				'from turnos , prestadores, preregistra, prestacions, entidades ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.afiliado = preregistra.id and ' + ;
						'turnos.tipoturno < 9 and ' + ;
						'turnos.afiliado = ?mafili ' + ;
				'group by turnos.fechatur, turnos.codmed, turnos.afiliado, turnos.codreserva ' + ;		
				'order by turnos.fechatur, turnos.codmed, turnos.horatur', 'mwkphorario3')
				
	&& busco en turnoshis
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, turnos.afiliado as AFI_nroafiliado, ' + ;
				'turnos.confirmado, turnos.codreserva, 0 as REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, ' + ;
				'preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.usuario, turnos.fechatomado ' + ;
				'from turnoshis as turnos , prestadores, preregistra, prestacions, entidades ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.afiliado = preregistra.id and ' + ;
						'turnos.tipoturno < 9 and ' + ;
						'turnos.afiliado = ?mafili ' + ;
				'group by turnos.fechatur, turnos.codmed, turnos.afiliado, turnos.codreserva ' + ;		
				'order by turnos.fechatur, turnos.codmed, turnos.horatur', 'mwkphorario4')

	&& busco los cancelados
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
				"turnos.diasem, turnos.codprest, prestadores.nombre, turnos.afiliado as AFI_nroafiliado, cast(3 as integer) as confirmado, " + ;
				"turnos.codreserva, 0 as  REG_nrohclinica, preregistra.nrodocumento as REG_numdocumento, " + ;
				"preregistra.nombre as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
				"turnos.usucancela as usuario, turnos.feccancela as fechatomado " + ;
				"from turnoscancel as turnos , prestadores, preregistra, prestacions, entidades " + ;
				"where turnos.codmed = prestadores.id and " + ;
						"turnos.codprest = prestacions.pre_codprest and " + ;
						"turnos.afiliado = preregistra.id and " + ;
						"turnos.codent = entidades.ENT_codent and " + ;
						"turnos.afiliado = ?mafili " + ;
				"group by turnos.fechatur, turnos.codmed, turnos.afiliado, turnos.codreserva " + ;		
				"order by turnos.fechatur, turnos.codmed, turnos.horatur", "mwkphorario5")

	select * from mwkphorario3 ;
		union all ;
			select * from mwkphorario4 ;
				union all ;
					select * from mwkphorario5 ;
					into cursor mwkphorario2
				
endif

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
else

	msql = "select fechatur, left(ttoc(horatur,2), 5) as hora, nombre, pre_descriprest, " + ;
			"iif(confirmado = 0, 'NO', iif(confirmado = 1, 'SI', 'AN')) as confirmado, " + ;
			"codreserva, usuario, fechatomado, id " + ;
			"from mwkphorario2 order by fechatur desc into cursor mwkphorarios2"
endif	

