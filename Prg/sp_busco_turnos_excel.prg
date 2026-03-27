***
*** Generacion de planilla de Turnos
***
parameters mfecturno

mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
				'turnos.diasem, turnos.codprest, prestadores.nombre, AFI_nroafiliado, REG_telefonos, ' + ;
				'turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, ' + ;
				'registracio.REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, ' + ;
				'turnos.fechatomado, turnos.usuario, especialid.ESP_descripcion ' + ;
				'from turnos , prestadores, registracio, prestacions, entidades, afiliacion, especialid, medpresta ' + ;
				'where turnos.codmed = prestadores.id and ' + ;
						'turnos.codprest = prestacions.pre_codprest and '  + ;
						'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
						'turnos.codmed = medpresta.codmed and ' + ;
						'turnos.codesp = trim(especialid.ESP_codesp) and ' + ;
						'registracio.REG_nroregistrac = afiliacion.registracio and ' + ;
						'turnos.codent = afiliacion.AFI_codentidad and ' + ;
						'turnos.codent = entidades.ENT_codent and ' + ;
						'turnos.fechatur > ?mfecturno and ' + ;
						'turnos.afiliado > 0 ' + ;
				'group by turnos.fechatur, AFI_nroafiliado, turnos.codreserva ' + ;
				'order by turnos.fechatur, turnos.horatur, AFI_nroafiliado', 'mwkphorario1')

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, preregistra.telefono as REG_telefonos, " + ;
				"turnos.diasem, turnos.codprest, prestadores.nombre, preregistra.afiliado as AFI_nroafiliado, " + ;
				"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
				"(preregistra.nombre) as REG_nombrepac, prestacions.pre_descriprest, entidades.ENT_descrient, " + ;
				"turnos.fechatomado, turnos.usuario, especialid.ESP_descripcion " + ;
				"from turnos , prestadores, preregistra, prestacions, entidades, especialid, medpresta " + ;
				"where turnos.codmed = prestadores.id and " + ;
						"turnos.codprest = prestacions.pre_codprest and "  + ;
						"turnos.afiliado = preregistra.id and " + ;
						"turnos.codent = entidades.ENT_codent and " + ;
						"turnos.codmed = medpresta.codmed and " + ;
						"turnos.codesp = trim(especialid.ESP_codesp) and " + ;
						"turnos.fechatur > ?mfecturno and " + ;
						"turnos.afiliado > 0 " + ;
				"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
				"order by turnos.fechatur, turnos.horatur", "mwkphorario2")
				
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
else

	select left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, left(REG_nrohclinica, 10) as REG_nrohclinica, ;
		REG_telefonos, usuario, fechatomado, fechatur, nombre, AFI_nroafiliado, REG_numdocumento, horatur, ;
		id, left(right(alltrim(REG_nrohclinica), 4), 2) as termina, ESP_descripcion from mwkphorario1 into cursor mwkphorario3

	select left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
		ENT_descrient, pre_descriprest, codreserva, left(REG_nrohclinica, 10) as REG_nrohclinica, ;
		REG_telefonos, usuario, fechatomado, fechatur, nombre, AFI_nroafiliado, REG_numdocumento, horatur, ;
		id, left(right(alltrim(REG_nrohclinica), 4), 2) as termina, ESP_descripcion from mwkphorario2 into cursor mwkphorario4

	select * from mwkphorario3 ;
	union ;
	select * from mwkphorario4;
	into cursor mwkphorarios

	select * from mwkphorarios order by nombre, ESP_descripcion, fechatur, horatur into cursor mwkphorario
	
	select mwkphorario1
	use
	select mwkphorario2
	use
	select mwkphorario3
	use
	select mwkphorario4
	use
	
endif	