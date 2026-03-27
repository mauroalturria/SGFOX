****
** listado de ausentismo de foniatria
****

parameter mfechades, mcodesp

mfecha	  = date() - 1

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
						"nombre, reg_nombrepac, afiliado " + ;
						"from turnos, registracio, afiliacion, prestadores " + ;
 						"where afiliado > 0 and fechatur >= ?mfechades and " + ;
 							"turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
 							"tipoturno < 9 and " + ;
 							"afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
 							"afiliacion.registracio = registracio.reg_nroregistrac " + ;
 						"order by codreserva, fechatur", "mwktodos1")


mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
						"prestadores.nombre, preregistra.nombre, turnos.afiliado " + ;
						"from turnos, preregistra, prestadores " + ;
 						"where afiliado > 0 and fechatur >= ?mfechades and " + ;
 							"turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
 							"tipoturno < 9 and turnos.afiliado = preregistra.id " + ;
 						"order by codreserva, fechatur", "mwktodos2")
 						
 	select * from mwktodos1 ;
 	union all ;
 	select * from mwktodos2 ;
 	into cursor mwktodos					
 						
 	select nombre, reg_nombrepac, codreserva, ;
 		sum(iif(confirmado = 0 and fechatur <= mfecha, 1, 0)) as falto,  ;
 		sum(iif(confirmado = 1 and fechatur <= mfecha, 1, 0)) as vino, ;
 		sum(iif(fechatur > mfecha, 1, 0)) as quedan ;
  	from mwktodos ;
  	group by nombre, reg_nombrepac ;
  	order by reg_nombrepac ;
  	into cursor mwktodosf
 	
 	select * from mwktodosf ;
 	where falto > 0 and quedan > 0  ;
 	order by nombre, reg_nombrepac ;
 	into cursor mwklista
