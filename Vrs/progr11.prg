A=UX XXX
			do while !eof('mwkhora')
		susp
				mcbar = round(val(substr(mwkhora.codbarra, 2, 11)), 0)
				mcmed = mwkhora.codmed
				mfech = mwkhora.fechatur
				mhdes = mwkhora.hordesde
				mhhas = mwkhora.horhasta
				mnomb = alltrim(mwkhora.nombre)
				msala = alltrim(mwkhora.sala)
				mhora = ctot('01/01/1900')
		
				mret = sqlexec(mcon1, "select * from horarioconsule where codbarra = ?mcbar", "mwkveocbar")
				if empty(mwkveocbar.codbarra)
					mret = sqlexec(mcon1, "insert into horarioconsule(codbarra, codmed, fecha, " + ;
								"horadesde, horahasta, nombre, sala) " + ;
								"values(?mcbar, ?mcmed, ?mfech, ?mhdes, ?mhhas, ?mnomb, ?msala)")
		
					if mret < 0
						messagebox('ERROR EN LA ACTIALIZACION DE HORAS CONSULTORIO', 48,'Validacion')
						cancel
					endif	 			
				endif
				skip 1 in mwkhora
			enddo	
