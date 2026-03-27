****
**  Busco dias en medpresta para sobreturnos
****

parameter mcodmed, mcodpres
mfecha = date()

	mret = sqlexec(mcon1, "select diasem, horadesde, horahasta, cantidad, porcentaje, id, " + ;
							"fvigend, fvigenh from tabsobretoa " +  ;
							"where codmed = ?mcodmed " + ;
							"order by codmed, diasem, horadesde", "mwkhoradoc1")

	mret = sqlexec(mcon1, "select diasem, horadesde, horahasta, cantidadps, id, " + ;
							"fecvigend, fecvigenh from tabprepaga " +  ;
							"where codmed = ?mcodmed " + ;
							"order by codmed, diasem, horadesde", "mwkhoradoc2")

	
	mret = sqlexec(mcon1, "select diasem, horadesde, horahasta, fecvigend, fecvigenh " + ;
							"from medpresta " +  ;
							"where diasem is not null and codmed = ?mcodmed " + ;
								"fecvigend <= ?mfecha and fecvigenh > ?mfecha " + ;
							"group by codmed, diasem, horadesde " + ;
							"order by codmed, diasem, horadesde", "mwkhoradoc3")

	endif

	select diasem, horadesde, horahasta, cantidad, porcentaje, id, tabomed, ;
		iif(diasem = 2, 'Lunes', iif(diasem = 3, 'Martes', ;
		iif(diasem = 4, 'Miercoles', iif(diasem = 5, 'Jueves', ;
		iif(diasem = 6, 'Viernes', 'Sabado'))))) as dia, ;
		left(ttoc(horadesde,2), 5) as desde,  ;
		left(ttoc(horahasta,2), 5) as hasta ;
		from mwkhoradoc1 into cursor mwkhoradoc