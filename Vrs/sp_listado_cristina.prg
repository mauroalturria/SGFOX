***
*** Generacion de planilla de Turnos
***
*parameter mfectur1, mfectur2, midmedico

mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, afi_nroafiliado, reg_telefonos, ' + ;
				'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, ' + ;
				'registracio.reg_nombrepac, prestacions.pre_descriprest, entidades.ent_descrient, ' + ;
				'turnos.fechatomado, turnos.usuario, turnos.confirmado, ' + ;
				'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia ' + ;
				'from turnoscancel as turnos , prestadores, registracio, prestacions, entidades, afiliacion ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
						'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
						'turnos.codent = afiliacion.afi_codentidad and ' + ;
						'turnos.codent = entidades.ent_codent and ' + ;
						'turnos.CODCANCELA = 5 and ' + ;
						'turnos.codmed = 65 and ' + ;
						'turnos.afiliado > 0 ' + ;
				'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
				'order by turnos.fechatur, turnos.horatur, afi_nroafiliado', 'mwkphorario1')

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as reg_telefonos, " + ;
				"turnos.diasem, turnos.codprest, prestadores.nombre, preregistra.afiliado as afi_nroafiliado, " + ;
				"turnos.codreserva, ('0000000000') as reg_nrohclinica, nrodocumento as reg_numdocumento, " + ;
				"(preregistra.nombre) as reg_nombrepac, prestacions.pre_descriprest, entidades.ent_descrient, " + ;
				"turnos.fechatomado, turnos.usuario, turnos.confirmado, " + ;
				"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia " + ;
				"from turnoscancel as turnos , prestadores, preregistra, prestacions, entidades " + ;
				"where turnos.codmed = prestadores.id and " + ;
						"turnos.codprest = prestacions.pre_codprest and "  + ;
						"turnos.afiliado = preregistra.id and " + ;
						"turnos.codent = entidades.ent_codent and " + ;
						"turnos.codcancela = 5 and " + ;
						"turnos.codmed = 65 AND " + ;
						"turnos.afiliado > 0 " + ;
				"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
				"order by turnos.fechatur, turnos.horatur", "mwkphorario2")
				
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	=sqldisconnect(mcon1)
	CANCEL
else

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, reg_numdocumento, nombre, horatur, id, codent, codmed, codmedsoli, ;		
		tipoturno, solicigia, codesp, codprest, diasem ;
		from mwkphorario1 into cursor mwkphorario3

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(reg_nrohclinica, 10) as reg_nrohclinica, reg_telefonos, usuario, fechatomado, ;
		afi_nroafiliado, reg_numdocumento, nombre, horatur, id, codent, codmed, codmedsoli, ;
		tipoturno, solicigia, codesp, codprest, diasem ;
		from mwkphorario2 into cursor mwkphorario4

	select * from mwkphorario3 ;
	union ;
	select * from mwkphorario4;
	into cursor mwkphorario

	select * from mwkphorario order by fechatur, horatur into cursor mwkphorarios
	
	select mwkphorario1
	use
	select mwkphorario2
	use
	select mwkphorario3
	use
	select mwkphorario4
	use

endif	