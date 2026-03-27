*
* Control de cambios actualización
*
Lparameters mform
With mform
	manio = .txtanio.value
	mmedi = mwkctrlcab.idmed
	
	For mi = 0 to 10
	
		mindi = alltrim(str(mi))
		mpreg = ".txtt" + mindi + ".visible and .txtt" + mindi +".value <> mwkctrlcab.c" + mindi
		
		If &mpreg
			
			mval1 = ".txtt" + mindi + ".value"
			mval2 = &mval1
			mval3 = "mwkctrlcab.c" + mindi
			mval4 = &mval3
			
			Use in select("mwkctrl")			
			mret = sqlexec(mcon1,"select * from TabMedCbio where anio = ?manio and idmedico = ?mmedi and cantcont = ?mi","mwkctrl")
			
			If mret < 0
				Messagebox("EN CONSULTA DE CONTROL DE CAMBIOS",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif
			
			If used("mwkctrl")
			
				If reccount("mwkctrl") > 0
				
					mlid = mwkctrl.id
					mret = sqlexec(mcon1,"update TabMedCbio set cantidad = ?mval2 where id = ?mlid")
					
					If mret < 0
						Messagebox("EN ACTUALIZACION DE CONTROL DE CAMBIOS",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif

					Do sp_insert_tabCtrlErr with "CONTROL DE CAMBIOS","ACTUALIZACION CONTROL DE CAMBIOS, PROFESIONAL: "+;
						alltrim(.txtprofesional.value)+", ESPECIALIDAD: "+.txtespecialidad.value+;
						", AÑO "+alltrim(Str(manio))+;
						", TIPO "+alltrim(str(mi))+", VALOR ORIGINAL: "+alltrim(str(mval4))+;
						", VALOR NUEVO: "+alltrim(str(mval2)),mwkusuario.idusuario

				Else

					mret = sqlexec(mcon1,"insert into TabMedCbio (anio,cantcont,cantidad,idmedico)"+;
						" values (?manio,?mi,?mval2,?mmedi)")

					If mret < 0
						Messagebox("EN REGISTRO DE CONTROL DE CAMBIOS",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif

					Do sp_insert_tabCtrlErr with "CONTROL DE CAMBIOS","REGISTRO CONTROL DE CAMBIOS, PROFESIONAL: "+;
						alltrim(.txtprofesional.value)+", ESPECIALIDAD: "+.txtespecialidad.value+;
						", AÑO "+alltrim(Str(manio))+;
						", TIPO "+alltrim(str(mi))+", VALOR: "+alltrim(str(mval2)),mwkusuario.idusuario

				Endif
			Endif
		Endif
	Next mi
	Use in select("mwkctrl")
Endwith
