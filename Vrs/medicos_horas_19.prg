do sp_conexion

mfecha1 = ctod('01/03/2008')
mfecha2 = ctod('19/04/2008')

mret = sqlexec(mcon1, "select franjahoraria.id,CODMED,prestadores.nombre, fecvigend, fecvigenh, " +  ;
							"Horadesde, Horahasta, hhmmDes,hhmmHas,diasem " + ;
						"from prestadores, franjahoraria " + ;
						"where prestadores.id = franjahoraria.codmed and " + ;
						"?mfecha1 < franjahoraria.fecvigenh AND " + ;
						"CODMED IN(SELECT CODMED FROM TURNOS WHERE FECHATUR >= ?MFECHA1 " + ;
							"AND FECHATUR <= ?MFECHA2 AND TIPOTURNO < 9 GROUP BY CODMED, DIASEM) " + ;
						"group by codmed, diasem, hhmmDes, FECVIGEND " + ;
						"order by codmed " , "mwktodosc")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

**"?mfecha1 >= medpresta.fecvigend  and " + ;
**"datepart(hh, hhasta) >= 19 " + ;
**"group by codesp, codmed, diasem, hdesde1 " + ;

=sqldisconnect(mcon1)