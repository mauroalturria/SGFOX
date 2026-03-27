*********************************************************************************
* BUSCA PACIENTES                                            				    *
*********************************************************************************
Parameter mbusco1, mpg, mcnombre,mwhere,mcursor

lret = .F.
If !Used('mwkusuario')
	mwhere = ' where !INLIST(nvl(TPV_Estado,0),1,3)  '
Else
	If Vartype(mwhere)#"C"
		mwhere = ' where !INLIST(nvl(TPV_Estado,0),1,3)  '
	Endif
Endif
If Vartype(mcursor )#"C"
	mcursor = "mwkbuspacie"
Endif
mcursor1 = mcursor +"1"
If mxambito >1
		Select mwktabambito
		Locate For Id = mxambito
	mccpoambreg = " ENT_codagrup in ("+ALLTRIM(mwktabambito.tipoent)+") and "
*	mccpoambreg = " ENT_tipo = 'BRISTOL'  and "
Else
	mccpoambreg = ''
Endif
*!*	use in select("mwkbuspacie0")
*!*	use in select("mwkbuspacie01")
*!*	use in select("mwkbuspacie")
*!*	use in select("mwkbuspacie1")
lsigo = .T.
If At("MCTEXTO",Upper(mbusco1))>0
	If Vartype(mctexto)="C" And Empty(mctexto)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
		lsigo = .F.
	Endif
Endif
If lsigo
	If mpg = 1

		mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, entidades.ENT_descrient, " + ;
			"REG_numdocumento, REG_fecregistra, REG_fecaltapadron, AFI_fechabaja, " + ;
			"AFI_nroafiliado, REG_fecnacimiento, REG_telefonos, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
			"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
			"REG_tipodocumento, REG_localidad, REG_sexo, " + ;
			"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
			", TPV_Audit , TPV_Observa, ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada,  "+ ;
			"REG_bloq_fecha, REG_bloq_oper,REG_tipodocumento,afi_idplan " + ;
			"FROM afiliacion, entidades, registracio left outer join bloqregist on " + ;
			" registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
			" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " +;
			mbusco1 + mccpoambreg  +;
			"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
			"afiliacion.AFI_codentidad = entidades.ENT_codent " + ;
			"", "mwkbuspacie0")

		If mret < 0

			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")

		Else

			If At("reg_numdocumento",Lower(mbusco1))>0

				qbusco = Strtran(Lower(mbusco1) ,'reg_numdocumento','TRD_NroDoc')
				mfecpas = Ctod("01/01/1900")

				mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, entidades.ENT_descrient, " + ;
					"REG_numdocumento, REG_fecregistra, REG_fecaltapadron, AFI_fechabaja, " + ;
					"AFI_nroafiliado, REG_fecnacimiento, REG_telefonos, REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
					"entidades.ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
					"REG_tipodocumento, REG_localidad, REG_sexo, " + ;
					"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
					", TPV_Audit , TPV_Observa, ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada,  "+ ;
					"REG_bloq_fecha, REG_bloq_oper,REG_tipodocumento,afi_idplan " + ;
					"FROM TabRegDocu,registracio " + ;
					" inner join afiliacion on registracio.REG_nroregistrac = afiliacion.registracio " + ;
					" inner join entidades on afiliacion.AFI_codentidad = entidades.ENT_codent  " + ;
					" left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
					" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
					qbusco +mccpoambreg  +" TRD_fechapasiva = ?mfecpas and TRD_Registracio = REG_nroregistrac ", "mwkbuspacie01")
				If mret < 0
					Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
					Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
				Else

					If Reccount('mwkbuspacie01')>0
						Select * ;
							from mwkbuspacie0 ;
							union All ;
							select * ;
							from mwkbuspacie01 Where REG_nroregistrac Not In (Select REG_nroregistrac From mwkbuspacie0 ) ;
							into Cursor &mcursor nofilter
					Else
						Select * ;
							from mwkbuspacie0 ;
							into Cursor &mcursor nofilter
					Endif
				Endif
			Else
				Select * ;
					from mwkbuspacie0 ;
					into Cursor &mcursor nofilter
			Endif

			Select REG_nroregistrac From &mcursor  Where  INLIST(nvl(TPV_Estado,0),1,3)  Into Cursor mwkpass

			If Reccount('mwkpass')>0
			
				Do Form frmpass_sec WITH mwkpass.REG_nroregistrac To lret
				mhc = Transf(mwkpass.REG_nroregistrac)
				If Type("miform") = "U"
					miform = Window()
				Endif
				Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' nombre '+ miform + '-'+mhc, '',''
			Endif

			mwhere = Iif(!lret,' where !INLIST(nvl(TPV_Estado,0),1,3)  ',' ')

			msql_reg = "select REG_nrohclinica, REG_nombrepac, REG_domicilio, ENT_descrient, " + ;
				"REG_numdocumento, REG_fecaltapadron, AFI_fechabaja, " + ;
				"AFI_nroafiliado, REG_fecnacimiento, REG_telefonos, iif(nvl(TPV_Estado,0) = 0,'  ','SI') as veri,"+;
				"left(nvl(TPV_Observa,''),250) as obser,'' as descestado,REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
				"ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
				"REG_tipodocumento, REG_localidad, REG_sexo, " + ;
				"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
				", TPV_Audit , TPV_Observa , ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada, 0 as preacre, " + ;
				"REG_bloq_fecha, REG_bloq_oper,afi_idplan  " + ;
				"from "+mcursor  + mwhere +;
				"ORDER BY REG_nombrepac, AFI_fechabaja, ENT_turnoshabilit "+;
				"into cursor "+mcursor1
			If mret < 0
				Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
			Endif
		Endif
	Else

		If mpg = 4
			mbusco1 = "where preregistra.id = ?mtexto and "
		Else
			If Upper(mbusco1) = Upper("where REG_numdocumento = ?mctexto and ")
				mbusco1 = "where preregistra.nrodocumento = ?mctexto and "
			Else
				mctexto = mcnombre
				mbusco1 = "where preregistra.nombre LIKE '&mctexto%' and "
			Endif
		Endif

		mret = SQLExec(mcon1,"select  cast('0000000000' as char(10)) as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
			"entidades.ENT_descrient, nrodocumento as REG_numdocumento, " + ;
			"fechaalta as REG_fecaltapadron, fechaalta as REG_fecregistra, fechabaja as AFI_fechabaja, afiliado as AFI_nroafiliado, fechanac as REG_fecnacimiento, " + ;
			"telefono as REG_telefonos, fechabaja as REG_fecbajapadron, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
			"ENT_fecpas, ENT_turnoshabilit, entidades.ENT_codent, preregistra.id as REG_nroregistrac, " + ;
			"codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, " + ;
			"coddocu as REG_tipodocumento, tabloca.descrip as REG_localidad, " + ;
			"sexo as REG_sexo, 0 as REG_distrito,cast(0 as integer) as TPV_Estado " + ;
			", 0 as TPV_Audit , space(300) as TPV_Observa, ENT_codagrup,email as REG_email, '' as REG_cuit,null as REG_fechaauditada ,cast(0 as integer) as afi_idplan "+;
			"from preregistra, entidades, tabpcia, tabloca " + mbusco1 + ;
			"preregistra.codloca = tabloca.id and " + ;
			"preregistra.codpcia = tabpcia.id and " + ;
			"preregistra.codent  = entidades.ENT_codent and " + mccpoambreg  +;
			"preregistra.nroregistracio is null " + ;
			"", mcursor )

		If mret < 0
			Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
		Endif
		If Reccount(mcursor)>0
			If mpg=4
				msql_reg = "select REG_nrohclinica, REG_nombrepac, REG_domicilio,  ENT_descrient, REG_numdocumento,"+;
					"REG_fecaltapadron,  REG_fecregistra, AFI_fechabaja,  AFI_nroafiliado,  REG_fecnacimiento, REG_telefonos,"+;
					"REG_fecbajapadron,ENT_fecpas,ENT_turnoshabilit,ENT_codent,REG_nroregistrac,REG_cpostal,"+;
					"REG_provincia,ENT_capita, ENT_tipo,ENT_nroprestadorexterno ,REG_tipodocumento,REG_localidad,REG_sexo,REG_email, REG_cuit,REG_fechaauditada,afi_idplan  "+;
					" from " +mcursor + mwhere +;
					" order by REG_nombrepac into cursor "+mcursor1

			Else
				msql_reg = "select REG_nrohclinica, REG_nombrepac, REG_domicilio, ENT_descrient, " + ;
					"REG_numdocumento, REG_fecaltapadron, REG_fecregistra, AFI_fechabaja, " + ;
					"AFI_nroafiliado, REG_fecnacimiento, REG_telefonos, iif(nvl(TPV_Estado,0) = 0,'  ','SI') as veri,"+;
					"left(nvl(TPV_Observa,''),250) as obser,'' as descestado,REG_fecbajapadron, ENT_fecpas, ENT_turnoshabilit, " + ;
					"ENT_codent, REG_nroregistrac, REG_cpostal, REG_provincia, ENT_capita, ENT_tipo,ENT_nroprestadorexterno , " + ;
					"REG_tipodocumento, REG_localidad, REG_sexo, " + ;
					"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
					",TPV_Audit , TPV_Observa , ENT_codagrup,REG_email, REG_cuit,REG_fechaauditada, 1 as preacre, " + ;
					"REG_bloq_fecha, REG_bloq_oper,afi_idplan  " + ;
					"from  "+mcursor  + mwhere +;
					"ORDER BY REG_nombrepac into cursor "+mcursor1

			Endif
			If mret < 0
				Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
			Endif
		Else
			msql_pre = ''
		Endif
	Endif
Endif


