*
* Actualizacion maestro Legales Incidentes Adversos ( Nuevo, Modifica )
*
Lparameters mform

mtipo   = Iif(mform.ltipo=1,'ALTA','MODIFICA')
mpage1  = mform.PagPrin.Page1
mpage2  = mform.PagPrin.Page2
mpage3  = mform.PagPrin.Page3
mpage4  = mform.PagPrin.Page4
mfecinf = mpage1.txtfinf.Value
mllenaf = mpage1.txtprofe.Value
mregist = mform.nregistro
mfhrinc = mpage1.txtfinc.Value
mpp = Alltrim(Dtoc(mpage1.txtfincd.Value))+" "+;
	Transform(mpage1.txthorad.Value,"99:99") + ":00"
mpage1.txtfinc.Value = mpp
mfhrinc = Ctot(mpage1.txtfinc.Value)
myip = Left(myip,15)
marea   = mpage1.cboserv.ListIndex
mdescbr = mpage1.txtdes.Value
mchecho = Iif(mpage3.chkcomunico.Value = 0,"NO","SI")

If mchecho = "SI"
	maquien = mpage3.txtaquien.Value
	mquedij = mpage3.txtseledijo.Value
	mreacci = mpage3.txtreaccion.Value
Else
	maquien = ""
	mquedij = ""
	mreacci = ""
Endif

*If mwkexe.nomexe = "LEGALES"
mservicio  = mpage4.cboservicio.Value
mservicio2 = mpage4.cboservicio2.Value
mhechogen  = mpage4.cbohecho.Value
*mwkhechosg.TLH_idcod &&mpage4.cbohecho.value &&listindex &&value
mriesgoni  = mpage4.cboriesgo.ListIndex &&value
mconentid  = mpage4.chkentidad.Value

micerrado  = Iif(mpage4.chknocorresponde.Value=1,4,mpage4.chkcerrado.Value)
mcomentar  = mpage4.txtcomentarios.Value
msigue     = mpage4.chksigue.Value
*Endif

musuario  = mwkusuario.idusuario
mlfecham  = sp_busco_fecha_serv("DT")

mevoles = .F.
If Type('m' + Alltrim(mform.Name) + 'cmdlegales') <> 'U'
	mevoles = .T.
Endif

medicoinv = mform.cbomedicoinv.Value

mlsector  = mwksectores1.SEC_codsector

If mtipo = 'ALTA'
	
	mestado = Iif(micerrado=4,4,Iif(micerrado=1,3,Iif(mevoles,2,1)))
	
	mret = SQLExec(mcon1,"insert into TabLGIncAdP"+;
		"(TIP_fecinf,TIP_estado,TIP_llenaform,TIP_nroregistrac,TIP_fechorainc,"+;
		"TIP_area,TIP_brevedesc,TIP_comhecho,TIP_aquien, TIP_qseledijo,"    +;
		"TIP_creacciono,TIP_idservicio,TIP_idhecho,TIP_idriesgo,TIP_centidad,"+;
		"TIP_comentario,TIP_ipadress,TIP_idusuario,TIP_fechamov,TIP_idservicio2,TIP_seguimiento,TIP_medicoinv,TIP_sector)"+;
		" values "+;
		"(?mfecinf,?mestado,?mllenaf,?mregist,?mfhrinc,?marea,?mdescbr,?mchecho,?maquien,"+;
		"?mquedij,?mreacci,?mservicio,?mhechogen,?mriesgoni,?mconentid,?mcomentar,"+;
		"?myip,?musuario,?mlfecham,?mservicio2,?msigue,?medicoinv,?mlsector)")
	
	If mret > 0
		mret = SQLExec(mcon1,"select id as lid from TabLGIncAdP"+;
			" where TIP_ipadress = ?myip and TIP_idusuario=?musuario and TIP_fechamov=?mlfecham","mwkincadp")
		If mret > 0
			If Reccount('mwkincadp') > 0
				mlid = mwkincadp.lid
				mret = SQLExec(mcon1,"update TabLGIncAdP set TIP_ipadress='' where ID=?mlid")
				If mret > 0
					RegIncAd()
				Else
					Messagebox("EN CONSULTA DE Incidentes de Seguridad"+Chr(10)+;
						"INICIALIZA, AVISE A SISTEMAS",16,"ERROR")
					Return
				Endif

			Endif
		Else
			Messagebox("EN CONSULTA DE Incidentes de Seguridad"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
			Return
		Endif
	Else
		Messagebox("EN INCORPORACION DE Incidentes de Seguridad"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		Return
	Endif

	mbusca = mlid

Else

	mbusca  = mwkincadp.Id
	mlid    = mbusca
	
*	mestado = iif(micerrado=1,3,iif(mevoles,2,1))
	mestado = Iif(micerrado=4,4,Iif(micerrado=1,3,Iif(mevoles,2,1)))

	mret = SQLExec(mcon1,"update TabLGIncAdP"+;
		" set TIP_fecinf=?mfecinf,TIP_estado=?mestado,TIP_llenaform=?mllenaf,"+;
		"TIP_nroregistrac=?mregist,TIP_fechorainc=?mfhrinc,"+;
		"TIP_area=?marea,TIP_brevedesc=?mdescbr,TIP_comhecho=?mchecho,"+;
		"TIP_aquien=?maquien,TIP_qseledijo=?mquedij," +;
		"TIP_creacciono=?mreacci,TIP_idservicio=?mservicio,TIP_idhecho=?mhechogen,"+;
		"TIP_idriesgo=?mriesgoni,TIP_centidad=?mconentid,"+;
		"TIP_comentario=?mcomentar,TIP_ipadress='',TIP_idusuario=?musuario,"+;
		"TIP_fechamov=?mlfecham,TIP_idservicio2=?mservicio2,TIP_seguimiento=?msigue,TIP_medicoinv=?medicoinv, TIP_sector = ?mlsector"+;
		" where ID=?mbusca")
	
	If mret < 0
		Messagebox("EN ACTUALIZACION DE Incidentes de Seguridad"+Chr(10)+;
			"PRINCIPAL 1, AVISE A SISTEMAS",16,"ERROR")
		Return
	Else
		mret = SQLExec(mcon1,"delete from TabLGIncAdD where TID_idincidente=?mbusca")
		If mret > 0
			RegIncAd()
		Else
			Messagebox("EN ACTUALIZACION DE Incidentes de Seguridad"+Chr(10)+;
				"PRINCIPAL 2, AVISE A SISTEMAS",16,"ERROR")
			Return
		Endif
	Endif
Endif

*
* Armado de Log Incidentes de Seguridad campo TLE_idestant=99,
* comparte tabla log Legales Demandas (Resp.Civil, Mala Praxis)
*
mret = SQLExec(mcon1,"insert into TabLGEvo"+;
	" (TLE_iddemanda,TLE_idusuario,TLE_fechamov,TLE_idestant,TLE_idesact)"+;
	" values (?mbusca,?musuario,?mlfecham,99,0)")

If mret < 0
	Messagebox("EN ACTUALIZACION DE MAESTRO DE EVOLUCION"+Chr(10)+;
		"Incidentes de Seguridad - AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
*
*
*
If Reccount('mwkmedgrid')>0
	mret = SQLExec(mcon1,"delete from TabLGIncAdMed where TIM_idincidente = ?mbusca")
	If mret > 0
		Select mwkmedgrid
		Go Top
		Scan
			mnombr = mwkmedgrid.nombre
			mcodig = mwkmedgrid.codigo
			mtipo  = mwkmedgrid.tipo
			mret = SQLExec(mcon1,"insert into TabLGIncAdMed (TIM_idincidente,TIM_codmed,TIM_nombremed,TIM_tipo) "+;
				"values (?mbusca,?mcodig,?mnombr,?mtipo)")
			If mret < 0
				Messagebox("EN Incidentes de Seguridad, REGISTRO DE MEDICOS",16,"ERROR")
				Return
			Endif
		Endscan
	Else
		Messagebox("EN Incidentes de Seguridad, ACTUALIZACION DE MEDICOS",16,"ERROR")
		Return
	Endif
Endif
Return
*
Procedure RegIncAd
With mpage1
	For mi = 1 To 5
		mpreg = ".chk" + Alltrim(Str(mi)) + ".value"
		If &mpreg = 1
			mcampo = ".chk"+Alltrim(Str(mi))
			mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
				" values (?mlid,?mcampo,'')")
			If mret < 0
				Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
					"DATOS 1, AVISE A SISTEMAS",16,"ERROR")
				Exit
			Endif
		Endif
	Next mi
Endwith

With mpage2.PagRel
	With .Page1
		For mi = 1 To 11
			mpreg = ".chka"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chka"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 2, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
		For mi = 1 To 10
			mpreg = ".chkb"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkb"+Alltrim(Str(mi))
				If mi = 10
					mtxtotraobs = .txtotrob.Value
				Else
					mtxtotraobs = ''
				Endif
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,?mtxtotraobs)")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 3, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page2
		For mi = 1 To 4
			mpreg = ".chkc"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkc"+Alltrim(Str(mi))
				If mi = 4
					mtxtotraobs = .txtotroc.Value
				Else
					mtxtotraobs = ''
				Endif
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,?mtxtotraobs)")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 4, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
		For mi = 1 To 2
			mpreg = ".chkd"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkd"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 5, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page3
		For mi = 1 To 2
			mpreg = ".chke"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chke"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 6, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
		For mi = 1 To 3
			mpreg = ".chkf"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkf"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 7, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
		For mi = 1 To 4
			mpreg = ".chkg"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkg"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 8, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page4
		For mi = 1 To 8
			mpreg = ".chkh"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkh"+Alltrim(Str(mi))
				If mi = 8
					mtxtotraobs = .txtotroh.Value
				Else
					mtxtotraobs = ''
				Endif
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,?mtxtotraobs)")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 9, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page5
		For mi = 1 To 5
			mpreg = ".chki"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chki"+Alltrim(Str(mi))
				If mi = 5
					mtxtotraobs = .txtotroi.Value
				Else
					mtxtotraobs = ''
				Endif
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,?mtxtotraobs)")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 10, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page6
		For mi = 1 To 5
			mpreg = ".chkj"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkj"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 11, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
		For mi = 1 To 3
			mpreg = ".chkk"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkk"+Alltrim(Str(mi))
				If mi = 3
					mtxtotraobs = .txtotrok.Value
				Else
					mtxtotraobs = ''
				Endif
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,?mtxtotraobs)")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 12, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith

	With .Page7
		For mi = 1 To 10
			mpreg = ".chkl"+Alltrim(Str(mi))+".value"
			If &mpreg = 1
				mcampo = ".chkl"+Alltrim(Str(mi))
				mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
					" values (?mlid,?mcampo,'')")
				If mret < 0
					Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
						"DATOS 13, AVISE A SISTEMAS",16,"ERROR")
					Exit
				Endif
			Endif
		Next mi
	Endwith
	
	With .Page8 && Caida / 2017-02-06

		Dimension mvdat[12]

		mvdat[01] = mwksectores.SEC_codsector
		mvdat[02] = .opt1.Value
		mvdat[03] = .opt2.Value
		mvdat[04] = .opt3.Value
		mvdat[05] = .opt4.Value
		mvdat[06] = .opt5.Value

		mvdat[07] = .opt6.Value
		mvdat[08] = .opt7.Value
		mvdat[09] = .opt8.Value

		mvdat[10] = .txtcaidaotros.Value
		mvdat[11] = .txtproblemas.Value
		mvdat[12] = .txtmecanismo.Value

		Use In Select("mwkctrl")

		mret = SQLExec(mcon1,"select id as lid from TabLGIncAdCa where TIC_idincad = ?mlid","mwkctrl")

		If mret < 0
			Messagebox("EN CONSULTA DEL Incidentes de Seguridad - CAIDAS"+Chr(10)+", AVISE A SISTEMAS",16,"ERROR")
			Exit
		Endif

		If Used("mwkctrl")

			If Reccount("mwkctrl") = 0

				mret = SQLExec(mcon1,"Insert Into TabLGIncAdCa (TIC_idincad, TIC_sector, TIC_pacomp, TIC_sujecion, TIC_riesgo, TIC_riesgov, TIC_mecanis,"+;
					"TIC_mecanisdes, TIC_mecanisbaj, TIC_mecanisban, TIC_otros, TIC_problemas, TIC_mecanismo)"+;
					" values "+;
					"(?mlid, ?mvdat[01], ?mvdat[02], ?mvdat[03], ?mvdat[04], ?mvdat[05], ?mvdat[06], ?mvdat[07], ?mvdat[08], ?mvdat[09], ?mvdat[10], ?mvdat[11], ?mvdat[12])")

			Else

				mret = SQLExec(mcon1,"update TabLGIncAdCa set "+;
					"TIC_sector     = ?mvdat[01],"+;
					"TIC_pacomp     = ?mvdat[02],"+;
					"TIC_sujecion   = ?mvdat[03],"+;
					"TIC_riesgo     = ?mvdat[04],"+;
					"TIC_riesgov    = ?mvdat[05],"+;
					"TIC_mecanis    = ?mvdat[06],"+;
					"TIC_mecanisdes = ?mvdat[07],"+;
					"TIC_mecanisbaj = ?mvdat[08],"+;
					"TIC_mecanisban = ?mvdat[09],"+;
					"TIC_otros      = ?mvdat[10],"+;
					"TIC_problemas  = ?mvdat[11],"+;
					"TIC_mecanismo  = ?mvdat[12]"+;
					" where TIC_idincad = ?mbusca")

			Endif

			If mret < 0
				Messagebox("EN ACTUALIZACION DEL Incidentes de Seguridad - CAIDAS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Exit
			Endif

		Endif

	Endwith

Endwith

With mpage3
	For mi = 1 To 6
		mpreg = ".chkcon"+Alltrim(Str(mi))+".value"
		If &mpreg = 1
			mcampo = ".chkcon"+Alltrim(Str(mi))

			If mi = 6
				mtxtotraobs = .txtotraconse.Value
			Else
				mtxtotraobs = ''
			Endif

			mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
				" values (?mlid,?mcampo,?mtxtotraobs)")
			If mret < 0
				Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
					"DATOS 14, AVISE A SISTEMAS",16,"ERROR")
				Exit
			Endif
		Endif
	Next mi

	For mi = 1 To 6
		mpreg = ".chkconst"+Alltrim(Str(mi))+".value"
		If &mpreg = 1
			mcampo = ".chkconst"+Alltrim(Str(mi))
			If mi = 6
				mtxtotraobs = .txtotroconsta.Value
			Else
				mtxtotraobs = ''
			Endif
			mret = SQLExec(mcon1,"insert into TabLGIncAdD (TID_idincidente,TID_tipochk,TID_obsotros)"+;
				" values (?mlid,?mcampo,?mtxtotraobs)")
			If mret < 0
				Messagebox("EN REGISTRO DEL Incidentes de Seguridad"+Chr(10)+;
					"DATOS 15, AVISE A SISTEMAS",16,"ERROR")
				Exit
			Endif
		Endif
	Next mi
Endwith


Return
