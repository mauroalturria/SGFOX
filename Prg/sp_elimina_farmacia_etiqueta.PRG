*
* Eliminación de Etiquetas Citostáticos
*
Lparameters mnropof

midusua   = mwkusuario.idusuario
mfechamov = sp_busco_fecha_serv("DT")
mmotivo   = 'ELI.ETIQ.: ' + alltrim(mnropof)
mtipo     = 'ETIQUETA'

If Used('mwknropof')
	Use in mwknropof
Endif

mret = sqlexec(mcon1,"select TCE_medidauso, TCE_insumocodigo, TCE_partida "+;
	" from TabFarmCitose" +;
	" where TCE_nropof = ?mnropof","mwknropof")

If mret < 0
	Messagebox("EN CONSULTA DE ETIQUETAS CITOSTATICOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

If used('mwknropof')
	If reccount('mwknropof') > 0

		mret = sqlexec(mcon1, "update TabFarmCitosE set TCE_fechapasiva=?mfechamov"+;
			" where TCE_nropof = ?mnropof")

		If mret < 0
			Messagebox("EN ACTUALIZACION MAESTRO ETIQUETAS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Else

			Select mwknropof
			Go Top
			Scan all

				mcodigo = mwknropof.TCE_insumocodigo
				mvalors = mwknropof.TCE_medidauso
				mpartid = mwknropof.TCE_partida

*!*             2013-04-16 Busco Emision

				Use in select("mwkemite")
				mbuscarpof  = 'EMITE '+alltrim(mnropof)

				mret = sqlexec(mcon1,"select ID as lid, TFL_vence, TFL_lote, TFL_serie, TFL_gtin, TFL_motivo"+;
					" from TabFarmlog"+;
					" where TFL_insumocodigo = ?mcodigo "+;
					" and TFL_partida  = ?mpartid" +;
					" and TFL_potencia = ?mvalors" +;
					" and TFL_motivo   = ?mbuscarpof" ,"mwkemite")

				If mret < 0
					Messagebox("EN CONSULTA DE LOG DE MOVIMIENTOS ETIQ. CITOSTATICOS"+;
						chr(10)+"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif

				Select mwkemite
				Go top

				mdat1 = mwkemite.TFL_vence
				mdat2 = mwkemite.TFL_lote
				mdat3 = mwkemite.TFL_serie
				mdat4 = mwkemite.TFL_gtin

*!*  	        2013-04-22 Busco Descarte

				Use in select("mwkemite2")
				mbuscarpof2 = 'Descarte '+alltrim(mnropof)

				mret = sqlexec(mcon1,"select ID as lid, TFL_vence, TFL_lote, TFL_serie, TFL_gtin, TFL_motivo, TFL_potencia"+;
					" from TabFarmlog"+;
					" where TFL_insumocodigo = ?mcodigo "+;
					" and TFL_partida  = ?mpartid" +;
					" and TFL_motivo   = ?mbuscarpof2"+;
					" and TFL_gtin     = ?mdat4"+;
					" and TFL_serie    = ?mdat3","mwkemite2")
					
				If mret < 0
					Messagebox("EN CONSULTA DE LOG DE MOVIMIENTOS ETIQ. CITOSTATICOS - DESCARTES"+;
						chr(10)+"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif

				mdat5 = '.' + mbuscarpof

				mlid  = mwkemite.lid

				Use in select("mwkdescarte")

				mret = sqlexec(mcon1,"select * from TabFarmlog" +;
					" where Id = ?mlid ","mwkdescarte")

				If mret < 0
					Messagebox("EN CONSULTA DE LOG DE MOVIMIENTOS ETIQ. CITOSTATICOS"+;
						chr(10)+"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif

				If used("mwkdescarte")
					If reccount("mwkdescarte")>0
						Select mwkdescarte
						Go top
						mvalors = mwkdescarte.TFL_potencia
					Endif
				Endif
				Use in select("mwkdescarte")

*!*             22-04-2013 Desacarte
				mlidb = 0
				If used("mwkemite2")
					If reccount("mwkemite2")>0
						Select mwkemite2
						Go top
						mvalors = mvalors + mwkemite2.TFL_potencia
						mdat5b = '.' + mbuscarpof2
						mlidb  = mwkemite2.lid
					Endif
				Endif
				Use in select("mwkemite2")

*!*             2013-04-16
				mret  = sqlexec(mcon1, "Update TabFarmCitosi set TCI_resto = (TCI_resto + ?mvalors), TCI_utilizado=(TCI_utilizado-?mvalors)" +;
					" where TCI_partida    = ?mpartid" +;
					" and TCI_insumocodigo = ?mcodigo" +;
					" and TCI_vence        = ?mdat1 "  +;
					" and TCI_lote         = ?mdat2 "  +;
					" and TCI_gtin         = ?mdat4 "  +;
					" and TCI_serie        = ?mdat3 ")

				If mret < 0
					Messagebox("EN ACTUALIZACION DE PRINCIPIOS ACTIVOS"+chr(10)+;
						"AVISE A SISTEMAS",0,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Else

*!*                 2013-04-16 Etiqueta
					mret = sqlexec(mcon1,"update TabFarmLog set TFL_motivo = ?mdat5 where id = ?mlid")

					If mret < 0
						Messagebox("EN MAESTRO DE REGISTRO DE MOVIMIENTOS, AVISE A SISTEMAS",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif

*!*					2013-04-22 Descarte
					If mlidb > 0
						mret = sqlexec(mcon1,"update TabFarmLog set TFL_motivo = ?mdat5b where id = ?mlidb")
						If mret < 0
							Messagebox("EN MAESTRO DE REGISTRO DE MOVIMIENTOS, AVISE A SISTEMAS",16,"ERROR")
							Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Return .F.
						Endif
					Endif

					mvalord = mvalors && 0

					mret = sqlexec(mcon1, "insert into TabFarmLog" + ;
						"(TFL_fechamov,TFL_idusuario,TFL_partida,TFL_insumocodigo,TFL_potencia,"+;
						"TFL_motivo,TFL_tipo,TFL_vence,TFL_lote)"+;
						" values (?mfechamov,?midusua,?mpartid,?mcodigo,?mvalord,?mmotivo,?mtipo,?mdat1,?mdat2)")

					If mret < 0
						Messagebox("EN MAESTRO DE REGISTRO DE MOVIMIENTOS, AVISE A SISTEMAS",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif

				Endif

				Use in select("mwkemite")

			Endscan

*!*         23-02-2011 Nuevo maestro etiquetas citostáticos pasivación
			If mret > 0

				mfecpasiva = ttod(mfechamov)

				mret = sqlexec(mcon1,"update TabFarmEtqCitos set "+;
					"TEC_fecpasiva = ?mfecpasiva,"+;
					"TEC_fecmov    = ?mfechamov,"+;
					"TEC_idusuario = ?midusua"+;
					" where TEC_nropof = ?mnropof")

				If mret < 0
					Messagebox("PASIVACION DE ETIQUETAS, MAESTRO DE ETIQUETAS CITOSTATICOS"+chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif

			Endif
		Endif
	Endif
Endif
Return .T.
