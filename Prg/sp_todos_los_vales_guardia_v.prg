****
** Busco todos los vales abiertos por prestacion para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaser
mfechactr = ctod("01/01/1900")
nosigue = .f.
mret = sqlexec(mcon1,'select * from TabPlanGua where '+;
	"VAL_fechasolicitud = ?mfechactr " ,'mwkctrl')

mfechactr = ttod( mwkctrl.fechahoraate )
if ( mfechas > mfechactr or mfecdes < ctod("01/09/2004") );
		and alltrim(mwkusuario.sector) # "SISTEMAS"
	nosigue = .t.
endif
cfecdes = prg_dtoc(mfecdes )
cfechas = prg_dtoc(mfechas + 1 )

mret = SQLExec(mcon1,"SELECT id, nombre  FROM prestadores  " + ;
	" union  SELECT ID , nombre FROM TabMedExterno " + ;
	" where gerenciadora = 0 " , "mwkMedicopg" )

mret =	sqlexec(mcon1, "select pre_codprest,pre_descriprest,PRE_codservicio  " + ;
	"from prestacions " + ;
	" ", "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
mret = sqlexec(mcon1, "select insumos as pre_codprest, INS_descriinsumo as pre_descriprest "+;
	" from insumos  " + ;
	"where INS_fechapasivo is null" , "mwkinsumos")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
endif


if nosigue
	messagebox("ESE RANGO DE FECHAS SOLICITELO EN SISTEMAS"+ chr(13);
		+"HABILITADO DESDE 01/09/2004 HASTA "+dtoc(mfechactr), 16, "Validacion")
else
	if alltrim(mwkusuario.sector) = "SISTEMAS" or mfecdes > mfechactr
		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecdes)+" hasta:"+ transf(mfechas)+;
			" a las:"+ transf(datetime()),"", mwkusuario.idusuario, "Consulta"
	msecs = seconds()
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
			"pia_codprest, pia_cantsolicitada " + ;
			"from presinsuvas, valesasist " + ;
			"where valesasist = pia_valesasist and " + ;
			"VAL_fechasolicitud between ?mfecdes and ?mfechas and " + ;
			"VAL_codsector = 'GUA' " +;
			"", "mwktodogua2")

		if mret < 0
			=aerr(eros)
			if eros(1) = 1526 and eros(5) = 400
				messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
			else
				messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
			endif
		else

			mret = sqlexec(mcon1, "select VAL_codvaleasist, PAC_nombrepaciente, PAC_codhce " + ;
				"from valesasist, pacientes " + ;
				"where VAL_codadmision = pacientes and " + ;
				"VAL_fechasolicitud between ?mfecdes and ?mfechas and " + ;
				"VAL_codsector = 'GUA' " + ;
				"", "mwktodogua1")

			if mret < 0
				=aerr(eros)
				if eros(1) = 1526 and eros(5) = 400
					messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
				else
					messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				endif
			else

				mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_codservvale, COB_codentidad, ENT_descrient, " + ;
					"ser_descripserv " + ;
					"from servicios, coberturas, entidades, " + ;
					"valesasist " + ;
					"where VAL_codadmision = COB_pacientes and " + ;
					"COB_codentidad = ENT_codent and " + ;
					"VAL_codservvale = ser_codserv and " + ;
					"VAL_fechasolicitud between ?mfecdes and ?mfechas and " + ;
					"VAL_codsector = 'GUA' " + mbuscaser + ;
					"", "mwktodogua3")

				if mret < 0
					=aerr(eros)
					if eros(1) = 1526 and eros(5) = 400
						messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
					else
						messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
					endif
				else
					mret = sqlexec(mcon1, "select nrovale,guardia.fechahoraate,guardiavale.diagnostico, " + ;
						"guardia.codmed from guardia,guardiavale  " + ;
						"where guardia.protocolo = guardiavale.protocolo and " +;
						" fechahoraing >= ?cfecdes "+;
						" and fechahoraing <  ?cfechas ", "mwktodogua41")

					select nrovale,fechahoraate,diagnostico,nombre ;
						from mwktodogua41 left join mwkMedicopg on id = codmed ;
						into cursor mwktodogua4
					if mret < 0
						=aerr(eros)
						if eros(1) = 1526 and eros(5) = 400
							messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
						else
							messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
						endif
					else

						select mwktodogua1.VAL_codvaleasist, PAC_nombrepaciente, PAC_codhce, 9, ;
							VAL_fechasolicitud,;
							padl(round(val(strtran(VAL_horasolicitud,'.', '')),0),4,"0") as VAL_horasolicituD, ;
							pia_codprest, pia_cantsolicitada, VAL_codservvale, ;
							COB_codentidad, ENT_descrient, ser_descripserv, nombre, fechahoraate,diagnostico ;
							from mwktodogua1, mwktodogua2, mwktodogua3, mwktodogua4 ;
							where mwktodogua1.VAL_codvaleasist = mwktodogua2.VAL_codvaleasist and ;
							mwktodogua1.VAL_codvaleasist = mwktodogua3.VAL_codvaleasist and ;
							mwktodogua1.VAL_codvaleasist = nrovale ;
							order by VAL_fechasolicitud, VAL_horasolicitud ;
							into cursor mwktodogua10

						select mwktodogua10.*, pre_descriprest+"     " as pre_descriprest  from mwktodogua10,mwkpres ;
							where 	pre_codprest = pia_codprest and VAL_codservvale <>5410 ;
							union 	select mwktodogua10.*, pre_descriprest from mwktodogua10,mwkinsumos ;
							where 	pre_codprest = pia_codprest and VAL_codservvale =5410 ;
							into cursor mwktodogua1

						select * from mwktodogua1 ;
							order by VAL_fechasolicitud, VAL_horasolicitud ;
							into cursor mwktodogua
*!*	msecs2 = seconds()
*!*	messagebox(transf(msecs2-msecs))

					endif
				endif
			endif
		endif
	else

		do sp_insert_tabCtrlErr with "Desde:"+transf(mfecdes)+" hasta:"+ transf(mfechas)+;
			" a las:"+ transf(datetime()),"", mwkusuario.idusuario, "Consulta sin acceso"


		mret = sqlexec(mcon1,'select TabPlanGua.*'+;
			",ser_descripserv, nombre, ENT_descrient  " + ;
			' from tabplangua , servicios, entidades '+;
			" left outer join prestadores " + ;
			" on VAL_prestador = prestadores.id " + ;
			"where COB_codentidad = ENT_codent and " + ;
			"VAL_codservvale = ser_codserv and " + ;
			"VAL_fechasolicitud between ?mfecdes and ?mfechas  " + ;
			" and VAL_prestador <9999 " + mbuscaser, 'mwktodogua10')

		if mret < 0
			=aerr(eros)
			if eros(1) = 1526 and eros(5) = 400
				messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
			else
				messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
			endif
		else

			select mwktodogua10.*, pre_descriprest+"     " as pre_descriprest  from mwktodogua10,mwkpres ;
				where 	pre_codprest = pia_codprest and VAL_codservvale <>5410 ;
				union 	select mwktodogua10.*, pre_descriprest from mwktodogua10,mwkinsumos ;
				where 	pre_codprest = pia_codprest and VAL_codservvale =5410 ;
				into cursor mwktodogua1

			select * from mwktodogua1 ;
				order by VAL_fechasolicitud, VAL_horasolicitud ;
				into cursor mwktodogua

		endif
	endif
endif
