***
*** Generacion de planilla de Turnos
***

DO SP_CONEXION

mfectur1 = ctod('09/10/2003')
mfectur2 = ctod('09/11/2003')

&& busco en turnos
mret = sqlexec(mcon1, "select reg_nombrepac, afi_nroafiliado, reg_nrohclinica, ent_descrient "  + ;
						"from turnos, registracio, entidades, afiliacion " + ;
						"where turnos.afiliado = registracio.reg_nroregistrac and " + ;
						"reg_nroregistrac = afiliacion.registracio and " + ;
						"turnos.codent = afi_codentidad and " + ;
						"turnos.codent = entidades.ent_codent and " + ;
						"turnos.tipoturno < 9 and " + ;
						"turnos.fechatur >= ?mfectur1 and " + ;
						"turnos.fechatur <= ?mfectur2 and " + ;
						"turnos.afiliado > 0 " + ;
				"group by reg_nombrepac, afi_nroafiliado, codreserva, fechatur " + ;
				"order by reg_nombrepac", "mwkphorario1")

&& busco en turnoshis
mret = sqlexec(mcon1, "select reg_nombrepac, afi_nroafiliado, reg_nrohclinica, ent_descrient "  + ;
						"from turnoshis as turnos, registracio, entidades, afiliacion " + ;
						"where turnos.afiliado = registracio.reg_nroregistrac and " + ;
						"reg_nroregistrac = afiliacion.registracio and " + ;
						"turnos.codent = afi_codentidad and " + ;
						"turnos.codent = entidades.ent_codent and " + ;
						"turnos.tipoturno < 9 and " + ;
						"turnos.fechatur >= ?mfectur1 and " + ;
						"turnos.fechatur <= ?mfectur2 and " + ;
						"turnos.afiliado > 0 " + ;
				"group by reg_nombrepac, afi_nroafiliado, codreserva, fechatur " + ;
				"order by reg_nombrepac", "mwkphorario2")


	select * from mwkphorario1 ;
	union all ;
	select * from mwkphorario2 ;
	into cursor mwkphorario

	select * ;
	from mwkphorario ;
	order by reg_nombrepac, afi_nroafiliado, reg_nrohclinica  ;
	into cursor mwkphorario3

	select reg_nombrepac, afi_nroafiliado, reg_nrohclinica, ;
		ent_descrient, count(afi_nroafiliado) as cantur ;  	
	from mwkphorario3 ;
	group by reg_nombrepac, afi_nroafiliado, reg_nrohclinica ;
	order by reg_nombrepac ;
	into cursor mwkphorario4


	select * ;
	from mwkphorario4 ;
	group by reg_nombrepac, afi_nroafiliado ;
	having cantur > 3 ;
	order by reg_nombrepac ;
	into cursor mwkphorario5

=SQLDISCONNECT(MCON1)