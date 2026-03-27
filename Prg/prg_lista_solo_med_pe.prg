****
**
****
	
	mfecha = sp_busco_fecha_serv('DD')
	
	mret = sqlexec(mcon1, "select a.diasem, a.fecvigend, a.fecvigenh, a.horadesde, " + ;
							"a.horahasta, nombre " + ;
							"from tabreservado as a, prestadores " + ;
							"where a.codmed = prestadores.id and " + ; 
							"a.fecvigenh > ?mfecha and a.tipoturno = 7 " + ;
							"order by nombre, a.diasem", "mwkpp" )
							
							
	if mret < 0						
	else
		report form repmedpe to printer prompt noconsole
	endif
	
