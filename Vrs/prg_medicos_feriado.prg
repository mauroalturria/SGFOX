*****
** Medicos desde un cierto horario
****

do sp_conexion

mdiasem = 5
mfechas = ctod('17/04/2003')

mret = sqlexec(mcon1, "select nombre, medpresta.hdesde1, medpresta.hhasta1, fecvigend, fecvigenh " + ;
						"from prestadores, medpresta " + ;
						"where medpresta.codmed = prestadores.id and " + ;
							"medpresta.diasem = ?mdiasem and " + ;
							"?mfechas >= medpresta.fecvigend and " + ;
							"?mfechas < medpresta.fecvigenh  and " + ;
							"datepart(hh,hhasta1) >= 11 " + ;
							"group by nombre, hdesde1, hhasta1 " + ;
							"order by nombre" , "mwktodosc")
							
=sqldisconnect(mcon1)							
				
