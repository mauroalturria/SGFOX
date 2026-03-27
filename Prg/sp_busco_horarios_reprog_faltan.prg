*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
***
*** Generacion de planilla de Turnos
***

mret = sqlexec(mcon1, "SELECT turnos.codreserva , turnos.horatur, " + ;
				"AFI_nroafiliado,registracio.REG_nombrepac,registracio.REG_telefonos, " + ;
				"registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
				"turnos.codesp, prestacions.pre_descriprest, entidades.ENT_descrient, "  + ;
				"turnos.fechatur, prestadores.nombre, turnos.diasem " + ;
				"FROM turnos , prestadores, registracio, prestacions, entidades, afiliacion " + ;
				"WHERE turnos.codmed = prestadores.id and " + ;
				"turnos.codprest = prestacions.pre_codprest and "  + ;
				"turnos.afiliado = registracio.REG_nroregistrac and " + ;
				"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
				"turnos.codent = entidades.ENT_codent and turnos.codmed = ?mid_medico and " + ;
				"turnos.fechatur =?mfectur1  and turnos.afiliado > 0 " + mcbuqdiasem + ;
				"ORDER BY turnos.fechatur,turnos.horatur,turnos.diasem", "mwkreproghs")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0

else
	msql = 'select left(ttoc(horatur,2), 5) as hora, REG_nombrepac, ENT_descrient, pre_descriprest, REG_nrohclinica, id from mwkphorario into cursor mwkreproghs'
endif	