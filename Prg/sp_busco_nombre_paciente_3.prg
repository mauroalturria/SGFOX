*********************************************************************************
* BUSCA PACIENTES Nueva GUARDIA
*********************************************************************************
Parameter mbusco1, mpg, mcnombre
lcErrorAnt = On("ERROR")
On Error
lret = .F.
mwhere = ' where !INLIST(nvl(TPV_Estado,0),1,3)  '
msql_pre = ''
msql_reg = ''
strBuspacie = ""

*!*	use in select("mwkbuspacie0")
*!*	use in select("mwkbuspacie01")
*!*	use in select("mwkbuspacie")
*!*	use in select("mwkbuspacie1")

If Alltrim(Mwkexe.Nomexe) = 'QUEJAS'
	If Used("mwkbuspacie")
		Use In mwkbuspacie
	Endif
Endif
lsigo = .T.
If At("MCTEXTO",Upper(mbusco1))>0
	If Vartype(mctexto)="C" And Empty(mctexto)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
		lsigo = .F.
	Endif
Endif

mbusco1 = " " + mbusco1 + " "

If lsigo

	mfecpas = Ctod("01/01/1900")
	If mpg = 1

		mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, " + ;
			"REG_numdocumento, REG_fecregistra, REG_fecnacimiento, TPV_Observa, REG_telefonos, " + ;
			"REG_nroregistrac, REG_cpostal, REG_provincia, " + ;
			"REG_tipodocumento, REG_localidad, REG_sexo,REG_email, REG_cuit,REG_fechaauditada, " + ;
			"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
			", TPV_Audit, REG_bloq_oper,Reg_bloq_fecha  "+;
			"FROM registracio " + ;
			" left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
			" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
			mbusco1 , "mwkbuspacie0")

		If mret < 0
*			=aerr(eros)
			msg = Message()
			If At("Error de conectividad",msg )>0 Or At("Connectivity error",msg ) >0
				msg = Iif(Vartype(mctexto)="U",'',Transform(mctexto))+Alltrim(mbusco1)+msg
			Endif
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
			Do log_errores With Error(), msg , Message(1), Program(), Lineno()
			On Error &lcErrorAnt

			Return .F.
		Endif

		If At("reg_numdocumento",Lower(mbusco1))>0
			qbusco = Strtran(Lower(mbusco1) ,'reg_numdocumento','TRD_NroDoc')
			mret = SQLExec(mcon1,"select REG_nrohclinica, REG_nombrepac, REG_domicilio, " + ;
				"REG_numdocumento, REG_fecregistra, REG_fecnacimiento, TPV_Observa, REG_telefonos, " + ;
				"REG_nroregistrac, REG_cpostal, REG_provincia, " + ;
				"REG_tipodocumento, REG_localidad, REG_sexo,REG_email, REG_cuit,REG_fechaauditada, " + ;
				"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
				", TPV_Audit, REG_bloq_oper,Reg_bloq_fecha   "+;
				"FROM TabRegDocu,registracio " + ;
				" left outer join bloqregist on registracio.REG_bloqueo = bloqregist.blr_codigobloqueo " + ;
				" left outer join TabPacVip on registracio.REG_nroregistrac = TabPacVip.TPV_NroReg " + ;
				qbusco +" and TRD_fechapasiva = ?mfecpas and TRD_Registracio = REG_nroregistrac ", "mwkbuspacie01")
			If mret < 0
				msg = Message()
				If At("Error de conectividad",msg )>0 Or At("Connectivity error",msg ) >0
					msg = Iif(Vartype(mctexto)="U",'',Transform(mctexto)) + Alltrim(qbusco)+msg
				Endif
				Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
				Do log_errores With Error(), msg , Message(1), Program(), Lineno()
				On Error &lcErrorAnt

				Return .F.
			Endif

			If Reccount('mwkbuspacie01')>0


				strBuspacie = "select * "
				strBuspacie = strBuspacie + "from mwkbuspacie0 "
				strBuspacie = strBuspacie + "union all "
				strBuspacie = strBuspacie + "select * "
				strBuspacie = strBuspacie + "from mwkbuspacie01 "
				strBuspacie = strBuspacie + "into cursor mwkbuspacie"

**IF ALLTRIM(Mwkexe.Nomexe) = "QUEJAS"
				If Version(5) = 900
					strBuspacie = strBuspacie + " NOFILTER READWRITE"
				Endif

				&strBuspacie

			Else

				strBuspacie = "select * "
				strBuspacie = strBuspacie + "from mwkbuspacie0 "
				strBuspacie = strBuspacie + "into cursor mwkbuspacie"

**IF ALLTRIM(Mwkexe.Nomexe) = "QUEJAS"
				If Version(5) = 900
					strBuspacie = strBuspacie + " NOFILTER READWRITE"
				Endif

				&strBuspacie

			Endif
		Else

*!*				select * ;
*!*					from mwkbuspacie0 ;
*!*					into cursor mwkbuspacie NOFILTER READWRITE

			strBuspacie = strBuspacie + "select * "
			strBuspacie = strBuspacie + "from mwkbuspacie0 "
			strBuspacie = strBuspacie + "into cursor mwkbuspacie"

**IF ALLTRIM(Mwkexe.Nomexe) = "QUEJAS"
			If Version(5) = 900
				strBuspacie = strBuspacie + " NOFILTER READWRITE"
			Endif

			&strBuspacie

		Endif

		Select REG_nroregistrac ;
			from mwkbuspacie ;
			where  INLIST(nvl(TPV_Estado,0),1,3)  ;
			into Cursor mwkpass
		SELECT * FROM mwkbuspacie INTO CURSOR mwkbuspacieobs
		If Reccount('mwkpass') > 0
			Do Form frmpass_sec With mwkpass.REG_nroregistrac To lret
			mhc = Transf(mwkpass.REG_nroregistrac)
			Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, Mwkexe.Nomexe+' nombre '+ miform + '-'+mhc, '',''
		Endif

		mwhere = Iif(!lret,' where !INLIST(nvl(TPV_Estado,0),1,3)  ',' ')

		msql_reg = "select REG_nrohclinica, REG_nombrepac, REG_domicilio,REG_numdocumento,  " + ;
			"REG_fecregistra, REG_fecnacimiento, left(TPV_Observa,250) as Obser, " + ;
			"REG_telefonos, REG_nroregistrac, REG_cpostal, REG_provincia, " + ;
			"REG_tipodocumento, REG_localidad, REG_sexo,REG_email, REG_cuit,REG_fechaauditada, " + ;
			"blr_codigobloqueo, blr_descripcion, REG_bloq_comen, REG_distrito, TPV_Estado " + ;
			", TPV_Audit,  0 as preacre, REG_bloq_oper,Reg_bloq_fecha,TPV_Observa  "+;
			" from mwkbuspacie " + mwhere +;
			"ORDER BY REG_nombrepac  group by REG_nroregistrac "+;
			"into cursor mwkbuspacie1"

		If mret < 0
*		=aerr(eros)
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			On Error &lcErrorAnt

			Return .F.
		Endif

	Else

		If Upper(mbusco1) = Upper(" where REG_numdocumento = ?mctexto and ")
			mbusco1 = " where preregistra.nrodocumento = ?mctexto and "
		Else
			mctexto = mcnombre
			mbusco1 = " where preregistra.nombre LIKE '&mctexto%' and "
		Endif

		mret = SQLExec(mcon1,"select cast('0000000000' as char(10)) as REG_nrohclinica, nombre as REG_nombrepac, direccion as REG_domicilio, " + ;
			"nrodocumento as REG_numdocumento, fechaalta as REG_fecregistra, fechanac as REG_fecnacimiento, " + ;
			"space(300) as TPV_Observa as obser,telefono as REG_telefonos, preregistra.id as REG_nroregistrac, " + ;
			"codpostal as REG_cpostal, tabpcia.descrip as REG_provincia, " + ;
			"coddocu as REG_tipodocumento, tabloca.descrip as REG_localidad, " + ;
			"sexo as REG_sexo,email as REG_email, '' as REG_cuit,null as REG_fechaauditada, 0 as REG_distrito,cast(0 as integer) as TPV_Estado " + ;
			", 0 as TPV_Audit,TPV_Observa  "+;
			"from preregistra, tabpcia, tabloca " + ;
			"&mbusco1 " + ;
			"preregistra.codloca = tabloca.id and " + ;
			"preregistra.codpcia = tabpcia.id and " + ;
			"preregistra.nroregistracio is null " + ;
			"", "mwkbuspacie")

		If mret < 0
*		=aerr(eros)
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "VALIDACION")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			On Error &lcErrorAnt
			Return .F.
		Endif
	SELECT * FROM mwkbuspacie INTO CURSOR mwkbuspacieobs
		If !Eof("mwkbuspacie") And !Bof("mwkbuspacie")
			msql_pre = 'select *, 0 as REG_bloq_oper,date() as Reg_bloq_fecha  , 1 as preacre from mwkbuspacie ORDER BY REG_nombrepac into cursor mwkbuspacie1'
		Else
			
			msql_pre = ''
		Endif

	Endif
Endif
On Error &lcErrorAnt
