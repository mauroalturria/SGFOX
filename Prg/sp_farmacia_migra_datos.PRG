*
* Mirgacion de Datos ( correspondiente a Medicamentos citostáticos ), provenientes de un XLS
*
Lparameters mpaso, marchivo, mopcion

* mopcion = 1 : Novedades
* mopcion = 2 : Base Gral
* mpaso   = 0 : Carga de Archivo excel
* mpaso   = 1 : Normalización de Maestros
*
* La lectura del EXCEL comienza desde la fila 10
*

muser = mwkusuario.idusuario
mfech = sp_busco_fecha_serv('DT')

If Vartype(mopcion) # "N"
	mopcion = 1
Endif
If Vartype(marchivo) # "C"
	marchivo = ""
Endif

If mpaso = 1 && Normalización

	Use In Select("mwkbase")
	mret = SQLExec(mcon1,"select id as lidbase, TBC_pvias, TBC_psolucr, TBC_psolucd, TBC_inscod"+;
		" from TabFarmBaseCo","mwkbase")

	If mret < 0
		=Aerror(merror)
		Messagebox("EN BUSQUEDA DE INSUMOS EN BASE DE CONOCIMIENTO"+Chr(10)+;
			merror(3)+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		mpasop = .F.
		Return .F.
	Endif

	Select mwkbase
	Go Top
	Scan All
		mlid     = mwkbase.lidbase
		mcadenaV = Alltrim(mwkbase.TBC_pvias)
		mcadenaR = Alltrim(mwkbase.TBC_psolucr)
		mcadenaD = Alltrim(mwkbase.TBC_psolucd)
		If Len(mcadenaV)>0
			mdes = 1
			If ';' $ mcadenaV
				mpas = .F.
				For mi2 = 1 To Len(mcadenaV)
					If Substr(mcadenaV,mi2,1)=";"
						mhas = mi2 - mdes  &&mi2-1
						mcodigo = Alltrim(Substr(mcadenaV,mdes,mhas))
						If Len(mcodigo)>0
							Do AltaRelvia
							mdes = mi2 + 1
						Endif
					Endif
				Endfor
			Else
				mpas = .T.
			Endif
			If mpas
				mcodigo = Alltrim(Substr(mcadenaV,mdes))
				If Len(mcodigo)>0
					Do AltaRelvia
				Endif
			Endif
		Endif

		If Len(mcadenaR)>0
			mdes = 1
			If ';' $ mcadenaR
				mpas = .F.
				For mi2 = 1 To Len(mcadenaR)
					If Substr(mcadenaR,mi2,1)=";"
						mhas = mi2 - mdes  &&mi2-1
						mcodigo = Alltrim(Substr(mcadenaR,mdes,mhas))
						If Len(mcodigo)>0
							Do AltaSolu With 'RECONSTITUCION'
						Endif
						mdes = mi2+1
					Endif
				Endfor
			Else
				mpas = .T.
			Endif
			If mpas
				mcodigo = Alltrim(Substr(mcadenaR,mdes))
				If Len(mcodigo)>0
					Do AltaSolu With 'RECONSTITUCION'
				Endif
			Endif
		Endif

		If Len(mcadenaD)>0
			mdes = 1
			If ';' $ mcadenaD
				mpas = .F.
				For mi2 = 1 To Len(mcadenaD)
					If Substr(mcadenaD,mi2,1)=";"
						mhas = mi2 - mdes  &&mi2-1
						mcodigo = Alltrim(Substr(mcadenaD,mdes,mhas))
						If Len(mcodigo)>0
							Do AltaSolu With 'DILUCION'
						Endif
						mdes = mi2+1
					Endif
				Endfor
			Else
				mpas = .T.
			Endif
			If mpas
				If Len(Alltrim(mcodigo))>0
					mcodigo = Alltrim(Substr(mcadenaD,mdes))
					Do AltaSolu With 'DILUCION'
				Endif
			Endif
		Endif

	Endscan
	Use In Select("mwkbase")

Else && Carga desde el archivo Excel

	If mopcion = 2 && Base Gral.

*!*     TabFarmBaseCoBak
		mret = SQLExec(mcon1,"insert into TabFarmBaseCoBak "+;
			"(TBC_Inscod       ,TBC_formafarm     ,TBC_estado       ,TBC_dosis       ,TBC_udosis      ,TBC_volum     ,TBC_uvolum,"+;
			"TBC_uconcen      ,TBC_excipiente    ,TBC_refrigera    ,TBC_protluz     ,TBC_volreco     ,TBC_uvolreco  ,TBC_dosisrecon,"+;
			"TBC_udosisrecon  ,TBC_recotmptpo    ,TBC_urecotmptpo  ,TBC_recofriotmp ,TBC_urecofriotmp,TBC_protecluz ,TBC_concen,"+;
			"TBC_dilutmptpo   ,TBC_udilutmptpo   ,TBC_dilufriotmp  ,TBC_udilufriotmp,TBC_diluprotluz ,TBC_voldilumin,TBC_psolucd,"+;
			"TBC_uvoldilumin  ,TBC_voldilumax    ,TBC_uvoldilumax  ,TBC_concdilu    ,TBC_uconcdilu   ,TBC_tmpadmmin ,TBC_apldosismax,"+;
			"TBC_utmpmin      ,TBC_ccmaxdilu     ,TBC_uccmaxdilu   ,TBC_filtracion  ,TBC_dosismax    ,TBC_udosismax ,"+;
			"TBC_dosisacutotal,TBC_udosisacutotal,TBC_obspreparador,TBC_obsenfermera,TBC_dmaxnenes   ,TBC_identifica,"+;
			"TBC_udnene       ,TBC_indpriline    ,TBC_otrasind     ,TBC_obsetq      ,TBC_pvias       ,TBC_psolucr,"+;
			"TBC_usuario      ,TBC_fechora       ,TBC_idbaseco)"+;
			" select "+;
			"TBC_Inscod       ,TBC_formafarm     ,TBC_estado       ,TBC_dosis       ,TBC_udosis      ,TBC_volum     ,TBC_uvolum,"+;
			"TBC_uconcen      ,TBC_excipiente    ,TBC_refrigera    ,TBC_protluz     ,TBC_volreco     ,TBC_uvolreco  ,TBC_dosisrecon,"+;
			"TBC_udosisrecon  ,TBC_recotmptpo    ,TBC_urecotmptpo  ,TBC_recofriotmp ,TBC_urecofriotmp,TBC_protecluz ,TBC_concen,"+;
			"TBC_dilutmptpo   ,TBC_udilutmptpo   ,TBC_dilufriotmp  ,TBC_udilufriotmp,TBC_diluprotluz ,TBC_voldilumin,TBC_psolucd,"+;
			"TBC_uvoldilumin  ,TBC_voldilumax    ,TBC_uvoldilumax  ,TBC_concdilu    ,TBC_uconcdilu   ,TBC_tmpadmmin ,TBC_apldosismax,"+;
			"TBC_utmpmin      ,TBC_ccmaxdilu     ,TBC_uccmaxdilu   ,TBC_filtracion  ,TBC_dosismax    ,TBC_udosismax ,"+;
			"TBC_dosisacutotal,TBC_udosisacutotal,TBC_obspreparador,TBC_obsenfermera,TBC_dmaxnenes   ,TBC_identifica,"+;
			"TBC_udnene       ,TBC_indpriline    ,TBC_otrasind     ,TBC_obsetq      ,TBC_pvias       ,TBC_psolucr,"+;
			"?muser           ,?mfech            ,TabFarmBaseCo.id from TabFarmBaseCo")

		If mret < 0
			=Aerror(merror)
			Messagebox("EN BAK MAESTRO BASE DE CONOCIMIENTOS"+Chr(10)+;
				merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

*!*     TabFarmBaseCoBak

		mret = SQLExec(mcon1,"delete from TabFarmBaseCo")
		If mret < 0
			=Aerror(merror)
			Messagebox("EN INICIALIZACION MAESTRO DE CONOCIMIENTOS"+Chr(10)+;
				merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"delete from TabFarmPactivo")
		If mret < 0
			=Aerror(merror)
			Messagebox("EN INICIALIZACION MAESTRO DE P.ACTIVOS"+Chr(10)+;
				merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"delete from TabFarmSoluc")
		If mret < 0
			=Aerror(merror)
			Messagebox("EN INICIALIZACION MAESTRO DE SOLUCIONES"+Chr(10)+;
				merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"delete from TabFarmViaAdm")
		If mret < 0
			=Aerror(merror)
			Messagebox("EN INICIALIZACION MAESTRO DE VIAS ADM."+Chr(10)+;
				merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

	mret = SQLExec(mcon1,"delete from TabFarmViaAdm2")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN INICIALIZACION MAESTRO DE VIAS ADM."+Chr(10)+;
			merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		mpasop = .F.
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mret = SQLExec(mcon1,"delete from TabFarmSoluc2")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN INICIALIZACION MAESTRO DE SOLUCIONES"+Chr(10)+;
			merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		mpasop = .F.
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mret = SQLExec(mcon1,"delete from TabFarmEstab")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN INICIALIZACION MAESTRO DE ESTABILIDAD"+Chr(10)+;
			merror(3)+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		mpasop = .F.
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	mlenvt = 49
	Dimension vdat[ mlenvt ]
	Do sp_control_aplicacion With "Microsoft Excel"

	oleapp = Createobject("excel.application")

	oleapp.Application.displayalerts = .F.
	oleapp.workbooks.Open(marchivo)

&&  Insumos contemplo 3era opción
	oleapp.Worksheets("PRINCIPAL").Activate

	mfil = 10
	Do While .T.
		Wait "LEYENDO PLANILLA EXCEL - PRINCIPAL"  + Str(mfil, 5) Windows Nowait

		Store '' To vdat
		vdat[01] = oleapp.cells(mfil,03).Value && Codigo

		If Empty(vdat[01]) Or Isnull(vdat[01])
*!*			If len(alltrim(vdat[01])) = 0
*!*				Exit
*!*			Endif
			Exit
		Endif

		momite = oleapp.cells(mfil,02).Value && Marca de omisión de registro "X", procesa igual cualquier caracter

		If Len(Alltrim(momite)) = 0 Or Empty(momite) Or Isnull(momite)

			midentifica = Nvl(oleapp.cells(mfil,59).Value,'')
			vdat[02]=Nvl(oleapp.cells(mfil,05).Value,'') && Forma Farm
			vdat[03]=Nvl(oleapp.cells(mfil,06).Value,'') && Estado
			vdat[04]=Nvl(oleapp.cells(mfil,07).Value,'') && Dosis *
			vdat[05]=Nvl(oleapp.cells(mfil,08).Value,'') && Unidad
			vdat[06]=Nvl(oleapp.cells(mfil,09).Value,'') && Volumen *
			vdat[07]=Nvl(oleapp.cells(mfil,10).Value,'') && Unidad
			vdat[08]=Nvl(oleapp.cells(mfil,11).Value,'') && Concentracion *
			vdat[09]=Nvl(oleapp.cells(mfil,12).Value,'') && unidad
			vdat[10]=Nvl(oleapp.cells(mfil,13).Value,'') && excipiente
			vdat[11]=Nvl(oleapp.cells(mfil,14).Value,'') && refrigeracion
			vdat[12]=Nvl(oleapp.cells(mfil,15).Value,'') && proteccion luz
			vdat[13]=Nvl(oleapp.cells(mfil,17).Value,'') && volumen reconst.
			vdat[14]=Nvl(oleapp.cells(mfil,18).Value,'') && unidad
			vdat[15]=Nvl(oleapp.cells(mfil,21).Value,'') && dosis
			vdat[16]=Nvl(oleapp.cells(mfil,22).Value,'') && unidad
			vdat[17]=Nvl(oleapp.cells(mfil,23).Value,'') && tmp amb tpo *
			vdat[18]=Nvl(oleapp.cells(mfil,24).Value,'') && unidad
			vdat[19]=Nvl(oleapp.cells(mfil,25).Value,'') && reconst. refrigera *
			vdat[20]=Nvl(oleapp.cells(mfil,26).Value,'') && unidad
			vdat[21]=Nvl(oleapp.cells(mfil,27).Value,'') && proteccion luz
			vdat[22]=Nvl(oleapp.cells(mfil,30).Value,'') && diluc. temp. amb. tpo. *
			vdat[23]=Nvl(oleapp.cells(mfil,31).Value,'') && unidad
			vdat[24]=Nvl(oleapp.cells(mfil,32).Value,'') && diluc. refrigeracion *
			vdat[25]=Nvl(oleapp.cells(mfil,33).Value,'') && unidad
			vdat[26]=Nvl(oleapp.cells(mfil,34).Value,'') && diluc. proteg. luz
			vdat[27]=Nvl(oleapp.cells(mfil,35).Value,'') && volumen diluc. *
			vdat[28]=Nvl(oleapp.cells(mfil,36).Value,'') && unidad
			vdat[29]=Nvl(oleapp.cells(mfil,37).Value,'') && vol. diluc. max. *
			vdat[30]=Nvl(oleapp.cells(mfil,38).Value,'') && unidad
			vdat[31]=Nvl(oleapp.cells(mfil,39).Value,'') && diluc. concentrac.
			vdat[32]=Nvl(oleapp.cells(mfil,40).Value,'') && unidad
			vdat[33]=Nvl(oleapp.cells(mfil,41).Value,'') && tpo. adm. min.
			vdat[34]=Nvl(oleapp.cells(mfil,42).Value,'') && unidad
			vdat[35]=Nvl(oleapp.cells(mfil,43).Value,'') && CC max. diluc. *
			vdat[36]=Nvl(oleapp.cells(mfil,44).Value,'') && unidad
			vdat[37]=Nvl(oleapp.cells(mfil,45).Value,'') && filtracion
			vdat[38]=Nvl(oleapp.cells(mfil,46).Value,'') && dosis max. *
			vdat[39]=Nvl(oleapp.cells(mfil,47).Value,'') && unidad
			vdat[40]=Nvl(oleapp.cells(mfil,50).Value,'') && apl. dosis max.
			vdat[41]=Nvl(oleapp.cells(mfil,51).Value,'') && dosis acum. total max. *
			vdat[42]=Nvl(oleapp.cells(mfil,52).Value,'') && unidad
			vdat[43]=Nvl(oleapp.cells(mfil,55).Value,'') && obs. operador.
			vdat[44]=Nvl(oleapp.cells(mfil,56).Value,'') && obs. enfermera *!*         5 columnas mas +
			vdat[45]=Nvl(oleapp.cells(mfil,48).Value,'') && Dosis máxima niños               Columna: 48, Campo: 47
			vdat[46]=Nvl(oleapp.cells(mfil,49).Value,'') && Unidad de dósis                  Columna: 49, Campo: 48
			vdat[47]=Nvl(oleapp.cells(mfil,53).Value,'') && Indicaciones de Primera Línea    Columna: 53, Campo: 52
			vdat[48]=Nvl(oleapp.cells(mfil,54).Value,'') && Otras Indicaciones               Columna: 54, Campo: 53
			vdat[49]=Nvl(oleapp.cells(mfil,57).Value,'') && Observaciones para la etiqueta   Columna: 57, Campo: 56

			mpvia = Nvl(oleapp.cells(mfil,16).Value,'')
			mpsor = Nvl(oleapp.cells(mfil,20).Value,'')
			mpsod = Nvl(oleapp.cells(mfil,29).Value,'')

			If Vartype(vdat[04])="C"
				vdat[04]=0
			Endif
			If Vartype(vdat[06])="C"
				vdat[06]=0
			Endif
			If Vartype(vdat[08])="C"
				vdat[08]=0
			Endif
			If Vartype(vdat[17])="C"
				vdat[17]=0
			Endif
			If Vartype(vdat[19])="C"
				vdat[19]=0
			Endif
			If Vartype(vdat[22])="C"
				vdat[22]=0
			Endif
			If Vartype(vdat[24])="C"
				vdat[24]=0
			Endif
			If Vartype(vdat[27])="C"
				vdat[27]=0
			Endif
			If Vartype(vdat[29])="C"
				vdat[29]=0
			Endif
			If Vartype(vdat[35])="C"
				vdat[35]=0
			Endif
			If Vartype(vdat[38])="C"
				vdat[38]=0
			Endif
			If Vartype(vdat[41])="C"
				vdat[41]=0
			Endif
			If Vartype(vdat[45])="C"
				vdat[45]=0
			Endif

			mins1 = ''
			For mi = 1 To mlenvt
				mins1 = mins1 + "?vdat["+Alltrim(Str(mi))+"],"
			Next mi

			mins2  = Alltrim(mins1)
			mins1  = "("+Left(mins2,Len(mins2)-1)+",?mpvia,?mpsor,?mpsod,?midentifica)"

			If mopcion = 3 && Sólo actualiza Insumos "A" ó "B"

				minser = .F.
				mtarea = oleapp.cells(mfil,61).Value && p/Actualizar

				If Len(Alltrim(mtarea))>0

					maccol = .F.
					Do Case
					Case mtarea = "A"
						minser = .T.
						maccol = .T.

					Case mtarea = "B"
						maccol = .T.
						If !cargoBak()
							Return .F.
						Endif

					Endcase

					If maccol
						mret = SQLExec(mcon1,"delete from TabFarmBaseCo"+;
							" where TBC_identifica = ?midentifica")

						If mret < 0
							=Aerror(merror)
							Messagebox("EN ELIMINACION DE INSUMO EN BASE DE CONOCIMIENTO"+Chr(10)+;
								merror(3)+Chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							mpasop = .F.
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
							Return .F.
						Endif

						oleapp.cells(mfil,61).Value = ""
						oleapp.cells(mfil,62).Value = "MODIFICACION TIPO: "+mtarea+", "+Ttoc(sp_busco_fecha_serv('DT'))
					Endif

				Endif

			Else

				minser = .T.

				If mopcion = 1
					Use In Select("mwkctrl")
					mret = SQLExec(mcon1,"select * from TabFarmBaseCo where TBC_identifica = ?midentifica","mwkctrl")
					If mret < 0
						=Aerror(merror)
						Messagebox("EN BUSQUEDA DE INSUMOS EN BASE DE CONOCIMIENTO"+Chr(10)+;
							merror(3)+Chr(10)+;
							"AVISE A SISTEMAS",16,"ERROR")
						mpasop = .F.
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Return .F.
					Else
						If Used('mwkctrl')
							If Reccount('mwkctrl')>0
								minser = .F.
								If !cargoBak()
									Return .F.
								Endif
*!*                        		TabFarmBaseCoBak
								mret = SQLExec(mcon1,"update TabFarmBaseCo set "+;
									"TBC_Inscod    = ?vdat[1],"+;
									"TBC_formafarm = ?vdat[2],"+;
									"TBC_estado  = ?vdat[3],"+;
									"TBC_dosis   = ?vdat[4],"+;
									"TBC_udosis  = ?vdat[5],"+;
									"TBC_volum   = ?vdat[6],"+;
									"TBC_uvolum  = ?vdat[7],"+;
									"TBC_concen  = ?vdat[8],"+;
									"TBC_uconcen = ?vdat[9],"+;
									"TBC_excipiente  = ?vdat[10],"+;
									"TBC_refrigera   = ?vdat[11],"+;
									"TBC_protluz     = ?vdat[12],"+;
									"TBC_volreco     = ?vdat[13],"+;
									"TBC_uvolreco    = ?vdat[14],"+;
									"TBC_dosisrecon  = ?vdat[15],"+;
									"TBC_udosisrecon = ?vdat[16],"+;
									"TBC_recotmptpo  = ?vdat[17],"+;
									"TBC_urecotmptpo = ?vdat[18],"+;
									"TBC_recofriotmp = ?vdat[19],"+;
									"TBC_urecofriotmp= ?vdat[20],"+;
									"TBC_protecluz   = ?vdat[21],"+;
									"TBC_dilutmptpo  = ?vdat[22],"+;
									"TBC_udilutmptpo = ?vdat[23],"+;
									"TBC_dilufriotmp = ?vdat[24],"+;
									"TBC_udilufriotmp= ?vdat[25],"+;
									"TBC_diluprotluz = ?vdat[26],"+;
									"TBC_voldilumin  = ?vdat[27],"+;
									"TBC_uvoldilumin = ?vdat[28],"+;
									"TBC_voldilumax  = ?vdat[29],"+;
									"TBC_uvoldilumax = ?vdat[30],"+;
									"TBC_concdilu    = ?vdat[31],"+;
									"TBC_uconcdilu   = ?vdat[32],"+;
									"TBC_tmpadmmin   = ?vdat[33],"+;
									"TBC_utmpmin     = ?vdat[34],"+;
									"TBC_ccmaxdilu   = ?vdat[35],"+;
									"TBC_uccmaxdilu  = ?vdat[36],"+;
									"TBC_filtracion  = ?vdat[37],"+;
									"TBC_dosismax    = ?vdat[38],"+;
									"TBC_udosismax   = ?vdat[39],"+;
									"TBC_apldosismax = ?vdat[40],"+;
									"TBC_dosisacutotal = ?vdat[41],"+;
									"TBC_udosisacutotal= ?vdat[42],"+;
									"TBC_obspreparador = ?vdat[43],"+;
									"TBC_obsenfermera  = ?vdat[44],"+;
									"TBC_dmaxnenes     = ?vdat[45],"+;
									"TBC_udnene        = ?vdat[46],"+;
									"TBC_indpriline = ?vdat[47],"+;
									"TBC_otrasind   = ?vdat[48],"+;
									"TBC_obsetq     = ?vdat[49],"+;
									"TBC_pvias      = ?mpvia,"+;
									"TBC_psolucr    = ?mpsor,"+;
									"TBC_psolucd    = ?mpsod"+;
									" where TBC_identifica = ?midentifica")
								If mret < 0
									=Aerror(merror)
									Messagebox("EN ACTUALIZACION DE INSUMOS EN BASE DE CONOCIMIENTO"+Chr(10)+;
										merror(3)+Chr(10)+;
										"AVISE A SISTEMAS",16,"ERROR")
									mpasop = .F.
									Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
									Return .F.
								Endif
							Endif
						Endif
					Endif
				Endif

			Endif

			If minser
				mret  = SQLExec(mcon1,"insert into TabFarmBaseCo "+;
					"(TBC_Inscod, TBC_formafarm, TBC_estado, TBC_dosis, TBC_udosis,"+;
					"TBC_volum,TBC_uvolum,TBC_concen,TBC_uconcen,TBC_excipiente ,TBC_refrigera,"+;
					"TBC_protluz,TBC_volreco,TBC_uvolreco,TBC_dosisrecon,TBC_udosisrecon,TBC_recotmptpo,"+;
					"TBC_urecotmptpo,TBC_recofriotmp,TBC_urecofriotmp,TBC_protecluz,TBC_dilutmptpo,"+;
					"TBC_udilutmptpo,TBC_dilufriotmp,TBC_udilufriotmp,TBC_diluprotluz,TBC_voldilumin,"+;
					"TBC_uvoldilumin,TBC_voldilumax,TBC_uvoldilumax,TBC_concdilu,TBC_uconcdilu,TBC_tmpadmmin,"+;
					"TBC_utmpmin,TBC_ccmaxdilu,TBC_uccmaxdilu,TBC_filtracion,TBC_dosismax,TBC_udosismax,"+;
					"TBC_apldosismax,TBC_dosisacutotal,TBC_udosisacutotal,TBC_obspreparador,TBC_obsenfermera,"+;
					"TBC_dmaxnenes,TBC_udnene,TBC_indpriline,TBC_otrasind,TBC_obsetq,"+;
					"TBC_pvias,TBC_psolucr,TBC_psolucd,TBC_identifica)"+;
					" values " + mins1 )
				If mret < 0
					=Aerror(merror)
					Messagebox("EN ALTA DE NUEVO INSUMO EN BASE DE CONOCIMIENTO"+Chr(10)+;
						merror(3)+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					mpasop = .F.
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif

		Endif
		mfil = mfil + 1
	Enddo

	Release vdat

	Dimension vdat2[4]
	oleapp.Worksheets("SOLUCIONES").Activate
	mfil = 3
	Do While .T.
		Wait "LEYENDO PLANILLA EXCEL - SOLUCIONES"  + Str(mfil, 5) Windows Nowait
		Store '' To vdat2
		vdat2[01]=oleapp.cells(mfil,02).Value && Codigo

*!*			If len(alltrim(vdat2[01]))=0
*!*				Exit
*!*			ENDIF

		If Empty(vdat2[01]) Or Isnull(vdat2[01])
			Exit
		Endif

		momite = oleapp.cells(mfil,01).Value
		If Len(Alltrim(momite)) = 0 Or Len(Alltrim(momite)) = 0 Or Empty(momite) Or Isnull(momite)
			vdat2[02]=oleapp.cells(mfil,03).Value && Desc1
			vdat2[03]=oleapp.cells(mfil,04).Value && Desc2
			vdat2[04]=oleapp.cells(mfil,05).Value && Abreviatura
			minser = .T.
			If mopcion = 1
				If Used('mwkctrl')
					Use In mwkctrl
				Endif
				mret = SQLExec(mcon1,"select * from TabFarmSoluc where TFS_inscod = ?vdat2[01]","mwkctrl")
				If mret < 0
					=Aerror(merror)
					Messagebox("EN BUSQUEDA DE SOLUCIONES"+Chr(10)+;
						merror(3)+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					mpasop = .F.
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Else
					If Used('mwkctrl')
						If Reccount('mwkctrl')>0
							minser = .F.
							mret = SQLExec(mcon1,"update TabFarmSoluc set "+;
								"TFS_desc1 = ?vdat2[02],"+;
								"TFS_desc2 = ?vdat2[03],"+;
								"TFS_codabrev = ?vdat2[04]"+;
								" where TFS_inscod = ?vdat2[01]")
							If mret < 0
								=Aerror(merror)
								Messagebox("EN ACTUALIZACION DE SOLUCIONES"+Chr(10)+;
									merror(3)+Chr(10)+;
									"AVISE A SISTEMAS",16,"ERROR")
								mpasop = .F.
								Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
								Return .F.
							Endif
						Endif
					Endif
				Endif
			Endif
			If minser
				mret = SQLExec(mcon1,"insert into TabFarmSoluc "+;
					"(TFS_inscod,TFS_desc1,TFS_desc2,TFS_codabrev)"+;
					" values "+;
					"(?vdat2[1],?vdat2[2],?vdat2[3],?vdat2[4])")
				If mret < 0
					=Aerror(merror)
					Messagebox("EN ALTA DE NUEVAS SOLUCIONES"+Chr(10)+;
						merror(3)+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					mpasop = .F.
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif
		Endif
		mfil = mfil + 1
	Enddo
	Release vdat2

&&  Principios Activos contemplo 3era opción
	Dimension vdat2[3]
	oleapp.Worksheets("PRINCIPIOS").Activate

	mfil = 3
	Do While .T.

		Wait "LEYENDO PLANILLA EXCEL - PRINCIPIOS" + Str(mfil, 5) Windows Nowait
		Store '' To vdat2
		vdat2[01] = oleapp.cells(mfil,02).Value && Código x vacio finalizo proceso

*!*			If len(alltrim(vdat2[01])) = 0
*!*				Exit
*!*			Endif

		If Empty(vdat2[01]) Or Isnull(vdat2[01])
			Exit
		Endif

		momite = oleapp.cells(mfil,01).Value && "X" No procesa, pero valoro cualquier caracter que pongan
		If Len(Alltrim(momite)) = 0 Or  Len(Alltrim(momite)) = 0 Or Empty(momite) Or Isnull(momite)

			vdat2[02] = oleapp.cells(mfil,03).Value && Producto
			vdat2[03] = oleapp.cells(mfil,04).Value && Principio

			If mopcion = 3 && Actulizar P.Activos sólo como "A" ó "B"

				minser = .F.
				mtarea = oleapp.cells(mfil,05).Value && p/Actualizar
				If Len(Alltrim(mtarea))>0
					maccol = .F.
					Do Case
					Case mtarea = "A"
						minser = .T.
						maccol = .T.
					Case mtarea = "B"
						maccol = .T.
					Endcase

					If maccol

						mret = SQLExec(mcon1,"delete from TabFarmPActivo "+;
							" where TFP_inscod = ?vdat2[1]"+;
							" and TFP_insdes   = ?vdat2[2]"+;
							" and TFP_pactivo  = ?vdat2[3]")
						If mret < 0
							=Aerror(merror)
							Messagebox("EN INGRESO DE NUEVO PRINCIPIO ACTIVO"+Chr(10)+;
								merror(3)+Chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							mpasop = .F.
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
							Return .F.
						Endif

						oleapp.cells(mfil,05).Value = ""
						oleapp.cells(mfil,06).Value = "MODIFICACION TIPO: "+mtarea+", "+Ttoc(sp_busco_fecha_serv('DT'))
					Endif

				Endif

			Else

				minser = .T.

				If mopcion = 1 && Tablas Satélites
					Use In Select("mwkctrl")
					mret = SQLExec(mcon1,"select * from TabFarmPActivo where TFP_inscod = ?vdat2[01]","mwkctrl")
					If mret < 0
						=Aerror(merror)
						Messagebox("EN BUSQUEDA DE PRINCIPIOS ACTIVOS"+Chr(10)+;
							merror(3)+Chr(10)+;
							"AVISE A SISTEMAS",16,"ERROR")
						mpasop = .F.
						Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Return .F.
					Else
						If Used('mwkctrl')
							If Reccount('mwkctrl')>0
								minser = .F.
								mret = SQLExec(mcon1,"update TabFarmPActivo set "+;
									"TFP_insdes  = ?vdat2[2],"+;
									"TFP_pactivo = ?vdat2[3] "+;
									"where TFP_inscod = ?vdat2[1]")
								If mret < 0
									=Aerror(merror)
									Messagebox("EN ACTUALIZACION DE PRINCIPIO ACTIVO"+Chr(10)+;
										merror(3)+Chr(10)+;
										"AVISE A SISTEMAS",16,"ERROR")
									mpasop = .F.
									Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
									Return .F.
								Endif
							Endif
						Endif
					Endif
				Endif

			Endif

			If minser
				mret = SQLExec(mcon1,"insert into TabFarmPActivo "+;
					"(TFP_inscod,TFP_insdes,TFP_pactivo)"+;
					" values "+;
					"(?vdat2[1],?vdat2[2],?vdat2[3])")

				If mret < 0
					=Aerror(merror)
					Messagebox("EN INGRESO DE NUEVO PRINCIPIO ACTIVO"+Chr(10)+;
						merror(3)+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
					mpasop = .F.
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return .F.
				Endif
			Endif

		Endif
		mfil = mfil + 1
	Enddo

	Release vdat2

	Dimension vdat2[2]
	oleapp.Worksheets("Via de administración").Activate
	mfil = 4
	Do While .T.
		Wait "LEYENDO PLANILLA EXCEL - Vías de Administración"  + Str(mfil, 5) Windows Nowait
		Store '' To vdat2
		msalir = oleapp.cells(mfil,02).Value

*!*			If len(alltrim(msalir)) = 0
*!*				Exit
*!*			Endif

		If Empty(msalir) Or Isnull(msalir)
			Exit
		Endif

		vdat2[01] = oleapp.cells(mfil,02).Value && Codigo
		vdat2[02] = oleapp.cells(mfil,03).Value && Descripción
		minser = .T.
		If mopcion = 1
			If Used('mwkctrl')
				Use In mwkctrl
			Endif
			mret = SQLExec(mcon1,"select * from TabFarmViaAdm where TFV_viacod = ?vdat2[1]","mwkctrl")
			If mret < 0
				=Aerror(merror)
				Messagebox("EN BUSQUEDA DE VIAS DE ADMINISTRACION"+Chr(10)+;
					merror(3)+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				mpasop = .F.
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Else
				If Used('mwkctrl')
					If Reccount('mwkctrl')>0
						minser = .F.
						mret = SQLExec(mcon1,"update TabFarmViaAdm set "+;
							"TFV_viades = ?vdat2[2] "+;
							"where TFV_viacod = ?vdat2[1]")
						If mret < 0
							=Aerror(merror)
							Messagebox("EN ACTUALIZACION DE VIAS DE ADMINISTRACION"+Chr(10)+;
								merror(3)+Chr(10)+;
								"AVISE A SISTEMAS",16,"ERROR")
							mpasop = .F.
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
							Return .F.
						Endif
					Endif
				Endif
			Endif
		Endif
		If minser
			mret = SQLExec(mcon1,"insert into TabFarmViaAdm "+;
				"(TFV_viacod,TFV_viades)"+;
				" values "+;
				"(?vdat2[1],?vdat2[2])")
			If mret < 0
				=Aerror(merror)
				Messagebox("EN INCORPORACION DE VIAS DE ADMINISTRACION"+Chr(10)+;
					merror(3)+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				mpasop = .F.
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif
		Endif
		mfil = mfil + 1
	Enddo

	Dimension vdat2[8]
	oleapp.Worksheets("TABLA ESTABILIDAD").Activate
	mfil = 3
	mreg = 1
	Do While .T.
		Wait "LEYENDO PLANILLA EXCEL - Tabla Estabilidad"  + Str(mreg, 5) Windows Nowait
		mreg = mreg + 1

		Store '' To vdat2
		msalir = oleapp.cells(mfil,01).Value

*!*			If Len(Alltrim(msalir))=0
*!*				Exit
*!*			ENDIF

		If Empty(msalir) Or Isnull(msalir)
			Exit
		Endif

		vdat2[01]=oleapp.cells(mfil,01).Value && Código
		vdat2[02]=oleapp.cells(mfil,03).Value && solución
		vdat2[03]=oleapp.cells(mfil,04).Value && concentración
		vdat2[04]=oleapp.cells(mfil,05).Value && unidades de concentración
		vdat2[05]=oleapp.cells(mfil,06).Value && conservación
		vdat2[06]=oleapp.cells(mfil,07).Value && envase
		vdat2[07]=oleapp.cells(mfil,08).Value && estabilidad
		vdat2[08]=oleapp.cells(mfil,09).Value && unidad de estabilidad

		mret = SQLExec(mcon1,"insert into TabFarmEstab "+;
			"(TFE_inscod,TFE_solucion,TFE_concentra,TFE_uconcon,TFE_conserva,TFE_envase,"+;
			"TFE_estabilidad,TFE_uestab)"+;
			" values "+;
			"(?vdat2[1],?vdat2[2],?vdat2[3],?vdat2[4],?vdat2[5],?vdat2[6],?vdat2[7],?vdat2[8])")

		If mret < 0
			=Aerror(merror)
			Messagebox("EN INCORPORACION DE DATOS ESTABILIADAD"+Chr(10)+;
				merror(3)+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			mpasop = .F.
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
		mfil = mfil + 1

	Enddo

	If mopcion = 3
		Wait "ACTUALIZANDO ARCHIVO BASE DE CONOCIMIENTO..." Window Timeout 2
		oleapp.Visible = .T.
		oleapp.Save
		oleapp.Visible = .F.
		oleapp.Quit
	Endif

	oleapp.Quit
	Release vdat2
	Release oleapp

Endif

Return .T.


Procedure AltaRelvia
mret = SQLExec(mcon1,"select id as lvid from TabFarmViaAdm"+;
	" where TFV_viacod=?mcodigo","mwkcodigo")
If mret > 0
	mpas = .T.
	If Used('mwkcodigo')
		If Reccount('mwkcodigo')>0
			Select mwkcodigo
			Go Top
			mlcodigo = mwkcodigo.lvid
			mret = SQLExec(mcon1,"insert into TabFarmViaAdm2"+;
				" (TVA_idbasecos,TVA_idviadmin)"+;
				" values (?mlid,?mlcodigo)")
			If mret < 0
				=Aerror(merror)
				Messagebox("EN INGRESO RELACION VIA ADMINISTRACION"+Chr(10)+;
					merror(3)+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
				mpasop = .F.
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif
		Endif
	Endif
Else
	=Aerror(merror)
	Messagebox("EN BUSQUEDA DE RELACION VIA ADMINISTRACION"+Chr(10)+;
		merror(3)+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	mpasop = .F.
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
Use In Select("mwkcodigo")
Return .T.
Endproc

Procedure AltaSolu(mltiposolu)
mpas = .T.
mret = SQLExec(mcon1,"insert into TabFarmSoluc2"+;
	" (TFC_idbasecos,TFC_inscod,TFC_tipo)"+;
	" values (?mlid,?mcodigo,?mltiposolu)")
If mret < 0
	=Aerror(merror)
	Messagebox("EN INGRESO RELACION SOLUCIONES"+Chr(10)+;
		merror(3)+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	mpasop = .F.
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
Return .T.
Endproc

Procedure cargoBak()
*!*	TabFarmBaseCoBak
mret = SQLExec(mcon1,"insert into TabFarmBaseCoBak "+;
	"(TBC_Inscod       ,TBC_formafarm     ,TBC_estado       ,TBC_dosis       ,TBC_udosis      ,TBC_volum     ,TBC_uvolum,"+;
	"TBC_uconcen      ,TBC_excipiente    ,TBC_refrigera    ,TBC_protluz     ,TBC_volreco     ,TBC_uvolreco  ,TBC_dosisrecon,"+;
	"TBC_udosisrecon  ,TBC_recotmptpo    ,TBC_urecotmptpo  ,TBC_recofriotmp ,TBC_urecofriotmp,TBC_protecluz ,TBC_concen,"+;
	"TBC_dilutmptpo   ,TBC_udilutmptpo   ,TBC_dilufriotmp  ,TBC_udilufriotmp,TBC_diluprotluz ,TBC_voldilumin,TBC_psolucd,"+;
	"TBC_uvoldilumin  ,TBC_voldilumax    ,TBC_uvoldilumax  ,TBC_concdilu    ,TBC_uconcdilu   ,TBC_tmpadmmin ,TBC_apldosismax,"+;
	"TBC_utmpmin      ,TBC_ccmaxdilu     ,TBC_uccmaxdilu   ,TBC_filtracion  ,TBC_dosismax    ,TBC_udosismax ,"+;
	"TBC_dosisacutotal,TBC_udosisacutotal,TBC_obspreparador,TBC_obsenfermera,TBC_dmaxnenes   ,TBC_identifica,"+;
	"TBC_udnene       ,TBC_indpriline    ,TBC_otrasind     ,TBC_obsetq      ,TBC_pvias       ,TBC_psolucr,"+;
	"TBC_usuario      ,TBC_fechora       ,TBC_idbaseco  )"+;
	" select "+;
	"TBC_Inscod       ,TBC_formafarm     ,TBC_estado       ,TBC_dosis       ,TBC_udosis      ,TBC_volum     ,TBC_uvolum,"+;
	"TBC_uconcen      ,TBC_excipiente    ,TBC_refrigera    ,TBC_protluz     ,TBC_volreco     ,TBC_uvolreco  ,TBC_dosisrecon,"+;
	"TBC_udosisrecon  ,TBC_recotmptpo    ,TBC_urecotmptpo  ,TBC_recofriotmp ,TBC_urecofriotmp,TBC_protecluz ,TBC_concen,"+;
	"TBC_dilutmptpo   ,TBC_udilutmptpo   ,TBC_dilufriotmp  ,TBC_udilufriotmp,TBC_diluprotluz ,TBC_voldilumin,TBC_psolucd,"+;
	"TBC_uvoldilumin  ,TBC_voldilumax    ,TBC_uvoldilumax  ,TBC_concdilu    ,TBC_uconcdilu   ,TBC_tmpadmmin ,TBC_apldosismax,"+;
	"TBC_utmpmin      ,TBC_ccmaxdilu     ,TBC_uccmaxdilu   ,TBC_filtracion  ,TBC_dosismax    ,TBC_udosismax ,"+;
	"TBC_dosisacutotal,TBC_udosisacutotal,TBC_obspreparador,TBC_obsenfermera,TBC_dmaxnenes   ,TBC_identifica,"+;
	"TBC_udnene       ,TBC_indpriline    ,TBC_otrasind     ,TBC_obsetq      ,TBC_pvias       ,TBC_psolucr,"+;
	"?muser           , ?mfech           ,TabFarmBaseCo.id from TabFarmBaseCo where TBC_identifica = ?midentifica")

If mret < 0
	=Aerror(merror)
	Messagebox("EN ACTUALIZACION DE INSUMOS EN BASE DE CONOCIMIENTO"+Chr(10)+;
		merror(3)+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	mpasop = .F.
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
Return .T.
Endproc
** Eof() **

