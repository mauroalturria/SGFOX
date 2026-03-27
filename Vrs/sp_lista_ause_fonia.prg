****
** listado de ausentismo de foniatria
****

do sp_conexion

mfechades = ctod('07/04/2003')
mfecha	  = date() - 1

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
						"nombre, reg_nombrepac, afiliado " + ;
						"from turnos, registracio, afiliacion, prestadores " + ;
 						"where afiliado > 0 and fechatur >= ?mfechades and " + ;
 							"turnos.codesp ='KINE' and codmed = prestadores.id and " + ;
 							"tipoturno < 9 and " + ;
 							"afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
 							"afiliacion.registracio = registracio.reg_nroregistrac " + ;
 						"order by codreserva, fechatur", "mwktodos1")


mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
						"prestadores.nombre, preregistra.nombre, turnos.afiliado " + ;
						"from turnos, preregistra, prestadores " + ;
 						"where afiliado > 0 and fechatur >= ?mfechades and " + ;
 							"turnos.codesp ='KINE' and codmed = prestadores.id and " + ;
 							"tipoturno < 9 and turnos.afiliado = preregistra.id " + ;
 						"order by codreserva, fechatur", "mwktodos2")
 						
 	select * from mwktodos1 ;
 	union all ;
 	select * from mwktodos2 ;
 	into cursor mwktodos					
 						
 	select nombre, afiliado, reg_nombrepac, codreserva, ;
 		sum(iif(confirmado = 0 and fechatur <= mfecha, 1, 0)) as falto,  ;
 		sum(iif(confirmado = 1 and fechatur <= mfecha, 1, 0)) as vino, ;
 		count(afiliado) as turnos ;
  	from mwktodos ;
  	group by afiliado ;
  	order by afiliado ;
  	into cursor mwktodosf
 	
 	select * from mwktodosf ;
 	where falto > 0   ;
 	order by nombre, reg_nombrepac ;
 	into cursor mwklista
 	
 	brow 
=sqldisconnect(mcon1)
 	 