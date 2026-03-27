*
* Grabo plan de tratamientos
*
Lparameters mthisform

With mthisform
	With .PGDatos.Page1

		Dimension vadtos[15]
		Dimension vdatos2[13]

		vadtos[01] = mwkinst.id
		vadtos[02] = mthisform.pnroRegistrac
		vadtos[03] = .cboubica.listindex
		vadtos[04] = .txttalla.value
		vadtos[05] = .txtpeso.value
		vadtos[06] = .txtsc.value
		vadtos[07] = .txtdiagnostico.value
		vadtos[08] = .txtmedico.value
		vadtos[09] = .txtmatricula.value
		vadtos[10] = mwkusuario.idusuario
		vadtos[11] = sp_busco_fecha_serv('DT')
		vadtos[12] = myip
		vadtos[13] = .txtpisocama.value
		vadtos[14] = mwkformulas.subestado &&.cboformula.listindex
		vadtos[15] = mwkesquemas.id        &&.cboesquema.value

		If mthisform.qtipo = 1

*!*
*!*             03/05/2011 libere ctrl de planilla de tratamiento cargada y vigente
*!*
*!*				Do sp_busca_farmacia_plantrat with vadtos[02] && Registracion de Paciente
*!*				If used("mwkctrla")
*!*					If reccount("mwkctrla")>0
*!*						Messagebox("EL PACIENTE PRESENTA UNA PLANILLA VIGENTE "+chr(10)+;
*!*							"VERIFIQUE ESTA SITUACION - INGRESO ANULADO",48,"Validación")
*!*						Use in mwkctrla
*!*						Return .F.
*!*					Endif
*!*				Else
*!*					Return
*!*				Endif

			mret = sqlexec(mcon1,"insert into TabFarmPlan "+;
				"(TFP_institucion,TFP_registracio,TFP_ubicacion,TFP_talla,TFP_peso,TFP_supcor,"+;
				"TFP_diagnos,TFP_medico,TFP_matricula,TFP_usuario,TFP_fecmov,TFP_ipuesto,TFP_pisocama,"+;
				"TFP_formula,TFP_esquema,TFP_estado) "+;
				"values "+;
				"(?vadtos[01],?vadtos[02],?vadtos[03],?vadtos[04],?vadtos[05],?vadtos[06],"+;
				"?vadtos[07],?vadtos[08],?vadtos[09],?vadtos[10],?vadtos[11],?vadtos[12],?vadtos[13],"+;
				"?vadtos[14],?vadtos[15],1)")

			If mret < 0
				Messagebox("EN INGRESO DE PLAN DE TRATAMIENTO"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Else
				If used("mwkplan")
					Use in mwkplan
				Endif
				mret = sqlexec(mcon1,"select id as lid from TabFarmPlan"+;
					" where TFP_usuario=?vadtos[10] and TFP_fecmov=?vadtos[11] and TFP_ipuesto=?vadtos[12]","mwkplan")
				If mret < 0
					Messagebox("EN BUSQUEDA DE DATOS, DEL PLAN DE TRATAMIENTO"+chr(10)+;
						"INGRESADO - AVISE A SISTEMAS -",16,"ERROR")
					Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Else
					mlid = mwkplan.lid
				Endif

			Endif

			Select mwkdatos
			Go top
			Scan all

				If mwkdatos.TFI_fecpasiva = dtot({//})
				
					vdatos2[01] = mwkdatos.fecha
					vdatos2[02] = mwkdatos.elegir
					vdatos2[03] = mwkdatos.TCI_insumocodigo
					vdatos2[04] = mwkdatos.dosis
					vdatos2[05] = mwkdatos.unidadosis
					vdatos2[06] = mwkdatos.volumen
					vdatos2[07] = mwkdatos.unidadvol
					vdatos2[08] = mwkdatos.solucion
					vdatos2[09] = mwkdatos.viasadm
					vdatos2[10] = mwkdatos.tiempo
					vdatos2[11] = mwkdatos.unidadtiempo
					vdatos2[12] = mwkdatos.hora
					vdatos2[13] = mwkdatos.TCI_insumodescrip

					mret = sqlexec(mcon1,"insert into TabFarmPlanI "+;
						"(TFI_idplan,TFI_feciclo,TFI_hora,TFI_agrupa,TFI_insumocodig,TFI_dosis,"+;
						"TFI_udosis,TFI_volumen,TFI_uvolumen,TFI_solucion,TFI_viasadm,"+;
						"TFI_tiempo,TFI_utiempo,TFI_pactivo) "+;
						"values "+;
						"(?mlid,?vdatos2[01],?vdatos2[12],?vdatos2[02],?vdatos2[03],?vdatos2[04],?vdatos2[05],?vdatos2[06],"+;
						"?vdatos2[07],?vdatos2[08],?vdatos2[09],?vdatos2[10],?vdatos2[11],?vdatos2[13])")

					If mret < 0
						Messagebox("EN INGRESO DE INSUMO EN"+chr(10)+;
							"PLAN DE TRATAMIENTO - AVISE A SISTEMAS -",16,"ERROR")
						Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
						Return .F.
					Endif
					
				Endif

			Endscan

		Else

			mlid = mwkdetplan.lid
			mret = sqlexec(mcon1,"update TabFarmPlan set "+;
				"TFP_institucion= ?vadtos[01],"+;
				"TFP_ubicacion  = ?vadtos[03],"+;
				"TFP_talla      = ?vadtos[04],"+;
				"TFP_peso       = ?vadtos[05],"+;
				"TFP_supcor     = ?vadtos[06],"+;
				"TFP_diagnos    = ?vadtos[07],"+;
				"TFP_medico     = ?vadtos[08],"+;
				"TFP_matricula  = ?vadtos[09],"+;
				"TFP_usuario    = ?vadtos[10],"+;
				"TFP_fecmov     = ?vadtos[11],"+;
				"TFP_ipuesto    = ?vadtos[12],"+;
				"TFP_pisocama   = ?vadtos[13],"+;
				"TFP_formula    = ?vadtos[14],"+;
				"TFP_esquema    = ?vadtos[15]"+;
				" where id = ?mlid")

			If mret < 0
				Messagebox("EN ACTUALIZACION DEL PLAN DE TRATAMIENTO"+chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Else

				Set deleted off
				Use in select("mwkpasiva")
				Select * from mwkdatos where lidplani > 0 and deleted() into cursor mwkpasiva
				If used("mwkpasiva")
					If reccount("mwkpasiva")>0
						mfbaja = vadtos[11] &&sp_busco_fecha_serv('DT')
						Select mwkpasiva
						Go top
						Scan all
							mbusid = mwkpasiva.lidplani
							mret = sqlexec(mcon1,"update tabfarmplani set TFI_fecpasiva = ?mfbaja where id = ?mbusid")
							If mret < 0
								Messagebox("EN ACTUALIZACION DEL PLAN DE TRATAMIENTO"+chr(10)+;
									"AVISE A SISTEMAS",16,"ERROR")
								Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
								Return .F.
							Endif
						Endscan
					Endif
				Endif
				Set deleted on
				Use in select("mwkpasiva")

				Select mwkdatos
				Go top
				Scan all

					If mwkdatos.TFI_fecpasiva = dtot({//})

						mbusid      = mwkdatos.lidplani
						vdatos2[01] = mwkdatos.fecha
						vdatos2[02] = mwkdatos.elegir
						vdatos2[03] = mwkdatos.TCI_insumocodigo
						vdatos2[04] = mwkdatos.dosis
						vdatos2[05] = mwkdatos.unidadosis
						vdatos2[06] = mwkdatos.volumen
						vdatos2[07] = mwkdatos.unidadvol
						vdatos2[08] = mwkdatos.solucion
						vdatos2[09] = mwkdatos.viasadm
						vdatos2[10] = mwkdatos.tiempo
						vdatos2[11] = mwkdatos.unidadtiempo
						vdatos2[12] = mwkdatos.hora
						vdatos2[13] = mwkdatos.TCI_insumodescrip

						If mbusid = 0
							mret = sqlexec(mcon1,"insert into TabFarmPlanI "+;
								"(TFI_idplan,TFI_feciclo,TFI_hora,TFI_agrupa,TFI_insumocodig,TFI_dosis,"+;
								"TFI_udosis,TFI_volumen,TFI_uvolumen,TFI_solucion,TFI_viasadm,"+;
								"TFI_tiempo,TFI_utiempo,TFI_pactivo) "+;
								"values "+;
								"(?mlid,?vdatos2[01],?vdatos2[12],?vdatos2[02],?vdatos2[03],?vdatos2[04],?vdatos2[05],"+;
								"?vdatos2[06],?vdatos2[07],?vdatos2[08],?vdatos2[09],?vdatos2[10],?vdatos2[11],"+;
								"?vdatos2[13])")
						Else
							mret = sqlexec(mcon1,"update tabfarmplani set "+;
								"TFI_idplan      = ?mlid,"+;
								"TFI_feciclo     = ?vdatos2[01],"+;
								"TFI_hora        = ?vdatos2[12],"+;
								"TFI_agrupa      = ?vdatos2[02],"+;
								"TFI_insumocodig = ?vdatos2[03],"+;
								"TFI_dosis       = ?vdatos2[04],"+;
								"TFI_udosis      = ?vdatos2[05],"+;
								"TFI_volumen     = ?vdatos2[06],"+;
								"TFI_uvolumen    = ?vdatos2[07],"+;
								"TFI_solucion    = ?vdatos2[08],"+;
								"TFI_viasadm     = ?vdatos2[09],"+;
								"TFI_tiempo      = ?vdatos2[10],"+;
								"TFI_utiempo     = ?vdatos2[11],"+;
								"TFI_pactivo     = ?vdatos2[13],"+;
								"TFI_fecpasiva   = null"+;
								" where id = ?mbusid")
						Endif

						If mret < 0
							Messagebox("EN ACTUALIZACION DE INSUMOS PLAN DE TRATAMIENTO"+chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
							Return .F.
						Endif

					Endif
				Endscan
			Endif
		Endif
	Endwith
	If used('mwkplan')
		Use in mwkplan
	Endif
	Release vadtos, vdatos2
Endwith
Return .T.
