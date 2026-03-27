
mfecdes = ctod('01/05/2002')
mfechas = ctod('31/05/2002')

mret = sqlexec(mcon1, "select turnos.codesp, turnos.codmed, turnos.fechatur, turnos.horatur, " + ;
				"medpresta.hdesde1, medpresta.hhasta1, " + ;
				"especialid.esp_descripcion, prestadores.nombre " + ;
				"from turnos, especialid, prestadores, medpresta " + ;
				"where turnos.codesp = trim(especialid.esp_codesp) and " + ;
				"turnos.codmed = prestadores.id and " + ;
				"turnos.diasem = medpresta.diasem and " + ;
				"turnos.codmed = medpresta.codmed and " + ;
				"turnos.fechatur >= medpresta.fecvigend and " + ;
				"turnos.fechatur < medpresta.fecvigenh and " + ;
				"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
				"tipoturno < 9 and " + ;
				"datepart(hh,hhasta1) > 18 " + ;
				"group by turnos.codesp, turnos.codmed, turnos.fechatur, hdesde1 " + ;
				"order by turnos.codesp, turnos.codmed, turnos.fechatur, hdesde1 " , "mwktodosc")
				
select * from mwktodosc group by codesp, codmed, fechatur order by codesp, codmed, fechatur				