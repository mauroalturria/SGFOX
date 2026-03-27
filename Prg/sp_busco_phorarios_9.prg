***
*** Generacion de planilla de Turnos
***
*parameter mfectur1, mfectur2, midmedico

mfectur1 = ctod('01/05/2002')
mfectur2 = ctod('09/05/2002')
midmedico = 309

mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
				'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
				'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.fechatomado, turnos.usuario, turnos.confirmado ' + ;
				'from turnos , prestadores, registracio, prestacions, entidades, afiliacion ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
						'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
						'turnos.codent = afiliacion.AFI_codentidad and ' + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.tipoturno = 9 and ' + ;
						'turnos.codmed = ?midmedico and ' + ;
						'turnos.fechatur >= ?mfectur1 and ' + ;
						'turnos.fechatur <= ?mfectur2 and ' + ;
						'turnos.afiliado > 0 ' + ;
				'group by turnos.fechatur, AFI_nroafiliado, turnos.codreserva ' + ;
				'order by turnos.fechatur, turnos.horatur, AFI_nroafiliado', 'mwkphorario1')

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
				"turnos.diasem, turnos.codprest, prestadores.nombre, preregistra.afiliado as AFI_nroafiliado, " + ;
				"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
				"(preregistra.nombre) as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
				"turnos.fechatomado, turnos.usuario, turnos.confirmado " + ;
				"from turnos , prestadores, preregistra, prestacions, entidades " + ;
				"where turnos.codmed = prestadores.id and " + ;
						"turnos.codprest = prestacions.pre_codprest and "  + ;
						"turnos.afiliado = preregistra.id and " + ;
						"turnos.codent = entidades.ENT_codent and " + ;
						"turnos.tipoturno = 9 and " + ;
						"turnos.codmed = ?midmedico and " + ;
						"turnos.fechatur >= ?mfectur1 and " + ;
						"turnos.fechatur <= ?mfectur2 and " + ;
						"turnos.afiliado > 0 " + ;
				"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
				"order by turnos.fechatur, turnos.horatur", "mwkphorario2")
				
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
else

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
		AFI_nroafiliado, REG_numdocumento, nombre, horatur, ;
		id from mwkphorario1 into cursor mwkphorario3

	select fechatur, left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, iif(confirmado = 0, 'NO', 'SI') as confirma, ;
		left(REG_nrohclinica, 10) as REG_nrohclinica, REG_telefonos, usuario, fechatomado, ;
		AFI_nroafiliado, REG_numdocumento, nombre, horatur, ;
		id from mwkphorario2 into cursor mwkphorario4

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