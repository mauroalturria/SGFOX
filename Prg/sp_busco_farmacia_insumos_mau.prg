*
* Busqueda de Insumos, medicamentos x codigo de insumo
*
Lparameters mabuscar, mtipo, mlaprox, mlesSolu, mTipoExe, mSector, mdesxbol

Local cTablas
Local lResult
Local nEstado

mTipoExe = Iif(Vartype(mTipoExe) <> "N",0,mTipoExe)
mSector = Iif(Vartype(mSector) <> "C","",mSector)

cTablas = "INSUMOS"
lResult = .T.

*!* 2015-03-19
*!* A raiz de inconvenientes en la tabla base de conocimiento de farmacia (las soluciones se informaron con un misma leyenda sin especificar volumen - tomamos la desc de Insumos
*!*

If Vartype(mdesxbol ) <> "C"
	mdesxbol = "N"
Endif

If Vartype(mlesSolu) <> "C"
	mlesSolu = "N"
Endif

If Vartype(mlaprox) <> "C"
	mlaprox = "N"
Endif

If Used("mwkinsumos")
	Use In mwkInsumos
Endif

*!* Consultar invertir el orden de busqueda considerando como Maestro principal
*!* TabFarmPActivo, ahora prioriza insumos porque tengo registros que no estan registrados en TabFar....
*!* y por su utilización podría ser necesario

Do Case


Case mtipo = 1 && x Codigo

*   INS_descriinsumo

	mret = SQLExec(mcon1, "select INS_codinsumo,TFP_pactivo,TFP_insdes,TBC_pvias,insumos,"+;
		"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_psolucd,"+;
		"TabFarmbaseCo.TBC_obspreparador,insumos.INS_descriinsumo,TBC_formafarm,"+;
		"TBC_dosismax,TBC_dmaxnenes,TBC_udosismax,TBC_udnene,TBC_ccmaxdilu "+;
		" from TabFarmPActivo " + ;
		" join insumos on INS_codinsumo = TFP_inscod "+;
		" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
		" and INS_fechapasivo is null "+;
		" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
		" where TFP_inscod = ?mabuscar" , "mwkinsumos")

	If mlaprox = "S"
		If Used('mwkinsumos')
			If Reccount('mwkinsumos') = 0
				mret = SQLExec(mcon1, "select INS_codinsumo,TFP_pactivo,TFP_insdes,TBC_pvias,insumos,"+;
					"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_psolucd,"+;
					"TabFarmbaseCo.TBC_obspreparador,insumos.INS_descriinsumo,TBC_formafarm,"+;
					"TBC_dosismax,TBC_dmaxnenes,TBC_udosismax,TBC_udnene,TBC_ccmaxdilu "+;
					" from TabFarmPActivo " + ;
					" join insumos on INS_codinsumo = TFP_inscod "+;
					" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
					" and INS_fechapasivo is null "+;
					" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
					" where TFP_inscod like '%"+mabuscar+"%'" , "mwkinsumos")
			Endif
		Endif
	Endif

	If Used('mwkinsumos')
		If Reccount('mwkinsumos') = 0
			mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
				"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias,"+;
				"insumos,cast(0 as int) as lid,"+;
				"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
				" from insumos " + ;
				" where INS_fechapasivo is null and "+;
				" INS_grupo in('M', 'U', 'W') and "+;
				" INS_codinsumo = ?mabuscar" , "mwkinsumos")
		Endif
	Endif

*!* 20/09/2013 Busqueda del Insumo verificacion de si es Trazable
	Use In Select("mwkinstra")
	mret = SQLExec(mcon1,"select TGT_Gtin from TabTraGTIN where TGT_InsCod = ?mabuscar","mwkinstra")

Case mtipo = 2 && x Descripcion

*   INS_descriinsumo

	If mdesxbol = "N"

		mret = SQLExec(mcon1, "select INS_codinsumo, TFP_pactivo, TFP_insdes, TBC_pvias,insumos,TabFarmbaseCo.id as lid,"+;
			" TBC_formafarm, TBC_dosis, TBC_udosis"+;
			" from TabFarmPActivo " + ;
			" join insumos on INS_codinsumo = TFP_inscod "+;
			" and INS_fechapasivo is null "+;
			" and INS_grupo in('M', 'U', 'W','A', 'D') "+;
			" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
			" where TFP_insdes LIKE '%&mabuscar%' " , "mwkinsumos")

		If Used('mwkinsumos')
			If Reccount('mwkinsumos')=0

*!*             Actualización 19/10/2012

				mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo," + ;
					"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias," + ;
					"insumos, cast(0 as int) as lid,"+;
					"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
					" from insumos " + ;
					" where INS_fechapasivo is null and "+;
					" INS_grupo in('M', 'U', 'W','A', 'D') and "+;
					" ins_descriinsumo LIKE '%&mabuscar%' " , "mwkinsumos")


			Endif
		Endif

	Else && 2017-02-02

		mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo," + ;
			"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias," + ;
			"insumos, cast(0 as int) as lid,"+;
			"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
			" from insumos " + ;
			" where INS_fechapasivo is null and "+;
			" INS_grupo in('M', 'U', 'W','A', 'D') and "+;
			" ins_descriinsumo LIKE '%"+Alltrim(Upper(mabuscar))+"%' " , "mwkinsumos")

	Endif


Case mtipo = 3 && x Principio Activo

*   INS_descriinsumo

	mret = SQLExec(mcon1, "select INS_codinsumo, TFP_pactivo, TFP_insdes, TBC_pvias,insumos,TabFarmbaseCo.id as lid "+;
		" from TabFarmPActivo " + ;
		" join insumos on INS_codinsumo = TFP_inscod "+;
		" and INS_fechapasivo is null "+;
		" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
		" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
		" where TFP_pactivo LIKE '%&mabuscar%' " , "mwkinsumos")

Case mtipo = 4 && x ID maestro BaseCo

	mret = SQLExec(mcon1, "select INS_codinsumo,TFP_pactivo,TFP_insdes,TBC_pvias,insumos,"+;
		"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_psolucd,"+;
		"TabFarmbaseCo.TBC_obspreparador,"+;
		"insumos.INS_descriinsumo,TBC_formafarm,"+;
		"TBC_dosismax,TBC_dmaxnenes,TBC_udosismax,TBC_udnene,TBC_ccmaxdilu "+;
		" from TabFarmPActivo " + ;
		" join insumos on INS_codinsumo = TFP_inscod "+;
		" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
		" and INS_fechapasivo is null "+;
		" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
		" where TabFarmbaseCo.ID = ?mabuscar" , "mwkinsumos")

Case mtipo = 5 && Para Cuidados Domiciliarios / Pisos

	mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
		"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias,"+;
		"insumos,cast(0 as int) as lid,"+;
		"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
		" from insumos " + ;
		" where INS_fechapasivo is null and "+;
		" INS_grupo in('M', 'U', 'W','A', 'D') and "+;
		" INS_codinsumo = ?mabuscar" , "mwkinsumos")

Case mtipo = 6 && Insumos por ATC

	mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
		"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias," + ;
		"insumos,cast(0 as int) as lid," + ;
		"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis" + ;
		" from insumos " + ;
		" where INS_fechapasivo is null and " + mabuscar + " order by INS_descriinsumo", "mwkinsumos")

Case mtipo = 7 && Busqueda en TabMedicamentos

*!*		mret = SQLExec(mcon1, "select b.INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
*!*			"a.tm_descripcion as INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias,"+;
*!*			"insumos,cast(0 as int) as lid,"+;
*!*			"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
*!*			" from tabMedicamentos as a " + ;
*!*			" inner join insumos as b " + ;
*!*			" where b.INS_fechapasivo is null and " + mabuscar + " order by INS_descriinsumo", "mwkinsumos")

**a.INS_fechapasivo is null and
** SELECT INS_codinsumo, TFP_pactivo, NVL(tm_descripcion,INS_descriinsumo) as INS_descriinsumo, TBC_pvias, insumos,lid, TBC_formafarm, ;
**        TBC_dosis, TBC_udosis, Ins_codpuntero, TM_insumo INTO CURSOR mwkinsumos

*!* Org. 2015-01-06
*!*		mret = SQLExec(mcon1, "select a.INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, nvl(b.tm_descripcion,a.INS_descriinsumo) as INS_descriinsumo," + ;
*!*			"  NVL(b.TM_via,'') as TBC_pvias,"+;
*!*			" a.insumos,cast(0 as int) as lid,"+;
*!*			" cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis," + ;
*!*			" a.Ins_codpuntero, b.TM_insumo,NVL(b.TM_volumen,0) as TM_volumen,NVL(b.TM_Dosis,'') as TM_dosis,NVL(c.TUV_desabreviada,'') as TUV_desabreviada, "+;
*!*			"  NVL(b.TM_infcontinua,'') as TM_infcontinua,a.INS_fechapasivo, a.INS_Vademecum " +;
*!*			" from Insumos as a " + ;
*!*			" left join TabMedicamentos as b on a.Ins_codpuntero = b.TM_insumo" + ;
*!*			" left join TabUniVolumen as c on b.TM_univolumen = c.ID " + ;
*!*			" where " + mabuscar  + " AND a.INS_fechapasivo is null", "mwkinsumos")

*!*		Select INS_codinsumo, TFP_pactivo, INS_descriinsumo, TBC_pvias, lid, TBC_formafarm,;
*!*			TBC_dosis, TBC_udosis, Ins_codpuntero, TM_insumo, TM_volumen, TM_dosis,;
*!*			TUV_desabreviada, TM_infcontinua, INS_fechapasivo,;
*!*			f_AltaComp(INS_codinsumo) As esAC, Iif(Nvl(INS_Vademecum,.F.),'S','N') As enVade ;
*!*			From mwkInsumos;
*!*			WHERE INS_fechapasivo Is Null Order By INS_descriinsumo Asc Into Cursor mwkInsumos

**SET STEP ON

	mret = SQLExec(mcon1, "select a.INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, "+;
		Iif(mlesSolu = "N", "nvl(b.tm_descripcion,a.INS_descriinsumo) as INS_descriinsumo", "a.INS_descriinsumo") + ;
		" ,NVL(b.TM_via,'') as TBC_pvias," + ;
		" a.insumos,cast(0 as int) as lid," + ;
		" cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis," + ;
		" a.Ins_codpuntero, b.TM_insumo,NVL(b.TM_volumen,0) as TM_volumen,NVL(b.TM_Dosis,'') as TM_dosis,NVL(c.TUV_desabreviada,'') as TUV_desabreviada,TM_presentacion, " + ;
		" NVL(b.TM_infcontinua,'') as TM_infcontinua,a.INS_fechapasivo, " + ;
		" NVL(d.ID,0) as TMP_ID, NVL(d.TMP_desabreviada,'          ') as TMP_desabreviada, " + ;
		" NVL(a.INS_Vademecum,0) as INS_Vademecum, ac.inscodpuntero as esAC, UPPER(E.TUPR_codigo) as tupr_codigo,NVL(TM_via,'') as TM_via " + ;
		" from Insumos as a " + ;
		" left join TabMedicamentos as b on a.Ins_codpuntero = b.TM_insumo " + ;
		" left join TabUniVolumen as c on b.TM_univolumen = c.ID " + ;
		" left join tabMediPresentacion as D on b.TM_Presentacion = d.ID " + ;
		" left join TabUniPrescripcion as E on b.TM_UniPrescripcion = E.Id " + ;
		" left join (select * from Inscriteriosolic where Inscriteriosolic.Agru = 29 and Inscriteriosolic.criterio in (9,12,13,14,16,17)) as ac " + ;
		" on a.INS_codpuntero = ac.INSCodPuntero " + ;
		IIF(mTipoExe = 16, " join insumospermisos as innut on inp_perfil = 16 and innut.ins_codpuntero = a.ins_codpuntero ", "")+;
		" where " + mabuscar  + " AND a.INS_fechapasivo is null", "mwkinsumos")

	If mret > 0
		Select INS_codinsumo, TFP_pactivo, INS_descriinsumo, TBC_pvias, lid, TBC_formafarm,;
			TBC_dosis, TBC_udosis, Ins_codpuntero, TM_insumo, TM_volumen, TM_dosis,;
			TUV_desabreviada, TM_infcontinua, INS_fechapasivo, TMP_desabreviada, TMP_ID, ;
			IIF(Nvl(esAC,0)>0,'S','N') As esAC, Iif(INS_Vademecum,'S','N') As enVade, TM_presentacion, TUPR_codigo, TM_via ;
			From mwkInsumos;
			WHERE INS_fechapasivo Is Null Order By INS_descriinsumo Asc  Into Cursor mwkInsumos

**Set Step On

** -----------Excluimos los medicamentos del sector.
		If !Empty(mSector)

			mret = SQLExec(mcon1,"select * from TabEstados where propietario = 7 and tipo = 22 ","mwkTabSecRestric")

			If mret <= 0

				Messagebox("ERROR EN LA LECTURA DE TABESTADOS",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.

			Endif

			nEstado = 0

			Select mwkTabSecRestric
			Go Top
			Scan All

				If At(mSector,mwkTabSecRestric.Descrip) > 0
					nEstado = mwkTabSecRestric.Estado
				Endif

			Endscan

			If nEstado = 0
				mret = SQLExec(mcon1,"select * from TabInsRestriccion where TIR_fecpasiva = '1900-01-01'","mwkTabInsRestriccion")
				Select * From mwkInsumos Where mwkInsumos.Ins_codpuntero Not In (Select TIR_codpuntero From mwkTabInsRestriccion Where TIR_codpuntero = mwkInsumos.Ins_codpuntero) Into Cursor mwkInsumos
			Else
				mret = SQLExec(mcon1,"select * from TabInsRestriccion where tir_tipo <> ?nEstado and TIR_fecpasiva = '1900-01-01'","mwkTabInsRestriccion")
				Select * From mwkInsumos Where mwkInsumos.Ins_codpuntero Not In (Select TIR_codpuntero From mwkTabInsRestriccion Where TIR_codpuntero = mwkInsumos.Ins_codpuntero) Into Cursor mwkInsumos
			Endif


		Endif

		Use In Select("mwkTabSecRestric")
		Use In Select("mwkTabInsRestriccion")

**------------Para que aparezca ordenado por Descripcion - INS_Vademecum (enVade es el campo INS_Vademecun con los null casteados a .f.)
		Select * From mwkInsumos Order By enVade Desc Into Cursor mwkInsumos


**INS_descriinsumo
	Endif

	cTablas = "INSUMOS - TABMEDICAMENTOS - TABUNIVOLUMEN"

Case mtipo = 8 && Buscar la droga en TabMediDrogas


*!*		mret = SQLExec(mcon1,"select a.*,UPPER(b.TUP_codigo) as TUP_codigo " +;
*!*			"from TabMedidrogas as a " + ;
*!*			"left join TabUniPotencia as b on a.TMD_unipotencia = b.ID " + ;
*!*			"where TMD_insumo = ?mabuscar","mwkMediDrogas")

*!*     2015-02-13

	mret = SQLExec(mcon1,"select TabMedidrogas.*, UPPER(TabUniPotencia.TUP_codigo) as TUP_codigo, TabMediPresentacion.TMP_DesAbreviada, TabMedicamentos.tm_presentacion"+;
		" from TabMedidrogas"+;
		" join TabMedicamentos on TabMedicamentos.TM_insumo = TabMedidrogas.TMD_insumo"+;
		" left join TabUniPotencia on TabMedidrogas.TMD_unipotencia = TabUniPotencia.ID"+;
		" left join TabMediPresentacion on TabMediPresentacion.ID = TabMedicamentos.TM_Presentacion"+;
		" where TabMedidrogas.TMD_insumo =?mabuscar","mwkMediDrogas")

	cTablas = "TABMEDIDROGAS"

*!*		mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
*!*			"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias,"+;
*!*			"insumos,cast(0 as int) as lid,"+;
*!*			"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis"+;
*!*			" from insumos " + ;
*!*			" where INS_fechapasivo is null and "+;
*!*			" INS_grupo in('M', 'U', 'W','A', 'D') and "+;
*!*			" INS_codinsumo = ?mabuscar" , "mwkinsumos")

Case mtipo = 9 && Bolsas de Cirugia  // 2016-06-16

	mret = SQLExec(mcon1, "select INS_codinsumo,TFP_pactivo,TFP_insdes,TBC_pvias,insumos,"+;
		"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_psolucd,"+;
		"TabFarmbaseCo.TBC_obspreparador,insumos.INS_descriinsumo,TBC_formafarm,"+;
		"TBC_dosismax,TBC_dmaxnenes,TBC_udosismax,TBC_udnene,TBC_ccmaxdilu,INS_codpuntero "+;
		" from TabFarmPActivo " + ;
		" join insumos on INS_codinsumo = TFP_inscod "+;
		" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
		" and INS_fechapasivo is null "+;
		" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
		" where TFP_inscod = ?mabuscar" , "mwkinsumos")

	If mlaprox = "S"
		If Used('mwkinsumos')
			If Reccount('mwkinsumos') = 0
				mret = SQLExec(mcon1, "select INS_codinsumo,TFP_pactivo,TFP_insdes,TBC_pvias,insumos,"+;
					"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_psolucd,"+;
					"TabFarmbaseCo.TBC_obspreparador,insumos.INS_descriinsumo,TBC_formafarm,"+;
					"TBC_dosismax,TBC_dmaxnenes,TBC_udosismax,TBC_udnene,TBC_ccmaxdilu,INS_codpuntero "+;
					" from TabFarmPActivo " + ;
					" join insumos on INS_codinsumo = TFP_inscod "+;
					" join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
					" and INS_fechapasivo is null "+;
					" and INS_grupo in('M', 'U', 'W', 'A', 'D') "+;
					" where TFP_inscod like '%"+mabuscar+"%'" , "mwkinsumos")
			Endif
		Endif
	Endif

	If Used('mwkinsumos')
		If Reccount('mwkinsumos') = 0
			mret = SQLExec(mcon1, "select INS_codinsumo, cast('...' as char(50)) as TFP_pactivo, " + ;
				"INS_descriinsumo, cast(' ' as char(150)) as TBC_pvias,"+;
				"insumos,cast(0 as int) as lid,"+;
				"cast(' ' as char(20)) as TBC_formafarm, cast(0 as int) as TBC_dosis, cast(' ' as char(2)) as TBC_udosis, INS_codpuntero"+;
				" from insumos" + ;
				" where INS_fechapasivo is null and"+;
				" INS_grupo in('M', 'U', 'W', 'A', 'D') and"+;
				" INS_codinsumo = ?mabuscar" , "mwkinsumos")
		Endif
	Endif

Endcase

*!* D : CT no
*!* M : MEDICAMENTOS
*!* U : MEDICAMENTOS MONODROGAS 1
*!* W : MEDICAMENTOS MONODROGAS 2
*!* A : ACCESORIOS ASISTENCIALES ??? no

If mret < 0
	lResult = .F.
	=Aerror(merror)
	Messagebox("EN CONSULTA DE "+ cTablas +Chr(10)+;
		merror(3)+Chr(10)+"AVISE A SISTEMAS",16, "ERROR")
Else
	If Used("mwkinsumos")
		If Reccount("mwkinsumos")>0
			If mtipo < 6
				Select * From mwkInsumos Group By INS_codinsumo,TBC_pvias Order By lid Into Cursor mwkInsumos
			Endif
		Endif
	Endif
Endif

Return lResult

*!*	Function f_AltaComp(mbusca)
*!*		mretorno = "N"
*!*		If sp_busco_ac_insumo(mbusca) && Busco el Cod.Insumo en criterios de AC
*!*			If Used("mwkinsumoac")
*!*				If Reccount("mwkinsumoac") > 0
*!*					mretorno = 'S'
*!*				Endif
*!*				Use In Select("mwkinsumoac")
*!*			Endif
*!*		Endif
*!*	Return mretorno


*!*		mret = sqlexec(mcon1, "select INS_codinsumo, TFP_pactivo, INS_descriinsumo, insumos "+;
*!*			"from insumos " + ;
*!*			"join TabFarmPActivo on TFP_inscod=INS_codinsumo "+;
*!*			"where INS_fechapasivo is null and "+;
*!*			"INS_grupo in('M', 'U', 'W') and "+;
*!*			"ins_descriinsumo LIKE '%&mabuscar%' " , "mwkinsumos")
