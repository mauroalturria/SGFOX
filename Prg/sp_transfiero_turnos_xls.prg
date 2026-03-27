***
*** Generacion de planilla de Turnos
***

parameters mfecturno

mret = sqlexec(mcon1, 'select turnos.fechatur, turnos.horatur, especialid.ESP_descripcion, ' + ;
	'prestadores.nombre, prestacions.pre_descriprest, ' + ;
	'registracio.REG_nombrepac, entidades.ENT_descrient, turnos.codreserva ' + ;
	'from turnos , prestadores, registracio, prestacions, entidades, especialid ' + ;
	'where turnos.codmed = prestadores.id and ' + ;
	'turnos.codprest = prestacions.pre_codprest and '  + ;
	'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
	'trim(turnos.codesp) = trim(especialid.ESP_codesp) and ' + ;
	'turnos.codent = entidades.ENT_codent and ' + ;
	'turnos.tipoturno < 9 and ' + ;
	'turnos.afiliado > 0 and ' + ;
	'turnos.fechatur > ?mfecturno ' + ;
	'group by turnos.fechatur, turnos.afiliado, turnos.codreserva ' + ;
	'order by turnos.fechatur, turnos.horatur, turnos.afiliado', 'mwkphorario1')


mret = sqlexec(mcon1, "select turnos.fechatur, turnos.horatur, especialid.ESP_descripcion, " + ;
	"prestadores.nombre, prestacions.pre_descriprest, " + ;
	"(preregistra.nombre) as REG_nombrepac, entidades.ENT_descrient, turnos.codreserva " + ;
	"from turnos , prestadores, preregistra, prestacions, entidades, especialid " + ;
	"where turnos.codmed = prestadores.id and " + ;
	"turnos.codprest = prestacions.pre_codprest and "  + ;
	"turnos.afiliado = preregistra.id and " + ;
	"turnos.codent = entidades.ENT_codent and " + ;
	"trim(turnos.codesp) = trim(especialid.ESP_codesp) and " + ;
	"turnos.tipoturno < 9 and " + ;
	"turnos.fechatur = ?mfecturno and " + ;
	"turnos.afiliado > 0 " + ;
	"group by turnos.fechatur, preregistra.afiliado, turnos.codreserva " + ;
	"order by turnos.fechatur, turnos.horatur", "mwkphorario2")

*if mret < 0
*	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
*	=sqldisconnect(mcon1)
*	CANCEL
*else

*	select left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
*		ENT_descrient, pre_descriprest, codreserva, left(REG_nrohclinica, 10) as REG_nrohclinica, ;
*		REG_telefonos, usuario, fechatomado, fechatur, nombre, AFI_nroafiliado, REG_numdocumento, horatur, ;
*		id, left(right(alltrim(REG_nrohclinica), 4), 2) as termina, ESP_descripcion from mwkphorario1 into cursor mwkphorario3
*
*	select left(ttoc(horatur,2), 5) as hora, left(REG_nombrepac, 40) as REG_nombrepac, ;
*		ENT_descrient, pre_descriprest, codreserva, left(REG_nrohclinica, 10) as REG_nrohclinica, ;
*		REG_telefonos, usuario, fechatomado, fechatur, nombre, AFI_nroafiliado, REG_numdocumento, horatur, ;
*		id, left(right(alltrim(REG_nrohclinica), 4), 2) as termina, ESP_descripcion from mwkphorario2 into cursor mwkphorario4
*
*	select * from mwkphorario3 ;
*	union ;
*	select * from mwkphorario4;
*	into cursor mwkphorarios

*	select * from mwkphorarios order by nombre, ESP_descripcion, fechatur, horatur into cursor mwkphorario

*	select mwkphorario1
*	use
*	select mwkphorario2
*	use
*	select mwkphorario3
*	use
*	select mwkphorario4
*	use
*
*endif
