
do sp_conexion

mret  = sqlexec(mcon1, "select fechahoraing, protocolo, reg_nombrepac, " + ;
							"ent_descrient, fechahoraate " + ;
							"from guardia, registracio, entidades " + ;
 							"where guardia.nroregistrac = reg_nroregistrac and " + ;
       								"codent = ent_codent and " + ;
       								"fechahoraing > '2004-05-09 00:00:00' and " + ;
       								"fechahoraing < '2004-05-11 00:00:00' " + ;
       						"order by fechahoraing", "mwkgua")
       						
=sqldisconnect(mcon1)
       								