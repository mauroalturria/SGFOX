****
**  Busco los horarios del medico con una prestacion
****

parameter mcodmed, mcodpres

mfecha = date()

	mret = sqlexec(mcon1, "select diasem, horadesde, horahasta, nombre " + ;
							"from medpresta, prestadores " +  ;
							"where medpresta.codmed = prestadores.id and " + ;
								"diasem is not null and codmed = ?mcodmed and " + ;
								"?mfecha < fecvigenh  and " + ;
								"codprest = ?mcodpres " + ;
							"group by codmed, diasem, horadesde " + ;
							"order by codmed, diasem, horadesde", "mwkhoradoc1")

	select nombre, iif(diasem = 2, 'Lunes', iif(diasem = 3, 'Martes', ;
		iif(diasem = 4, 'Miercoles', iif(diasem = 5, 'Jueves', ;
		iif(diasem = 6, 'Viernes', 'Sabado'))))) as dia, ;
		left(ttoc(horadesde,2), 5) as desde,  ;
		left(ttoc(horahasta,2), 5) as hasta ;
		from mwkhoradoc1 into cursor mwkhoradoc

** ?mfecha >= fecvigend  and		