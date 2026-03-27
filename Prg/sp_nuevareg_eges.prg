Parameters toForm, tcHCE, tnRegi, tcNomBB, tcCurDatMa,tncanthijos

Local mresp1, mresp2
mresp1 = 0
mresp2 = ''
If Vartype(tncanthijos)<>"N"
	tncanthijos=0
Endif
Private tipodoc(10)
Dimension tipodoc(10)
For itx = 1 To 9
	tipodoc(itx) = itx-1
Next
tipodoc(9) = 9
Do sp_busco_estados With 57,' and Tipo = 3 ','mwkbloqueaplan'
nbloqueoplan = mwkbloqueaplan.estado


With toForm
	If prg_modo_exe()
		Set Escape Off
	Endif

	.olevism.mserver 	= Allt(mwktabcfg.OLEServer)
	.olevism.namespace 	= Allt(mwktabcfg.olespaces)

	mgraba	= '1'
	mhce 	= ""
	mfechoy = sp_busco_fecha_serv('DD')
	mfec	= Dtoc(mfechoy) && Fecha de Nacimiento
	msex	= 'I' && Iif('' = 'MASCULINO', 'M','F') && Sexo del Recién Nacido

* Busco datos de la madre en Registracio
	mNroRegMadre = Alltrim(Str(&tcCurDatMa..pac_codhci))
	Set Step On

	lcSQL = "select * from registracio where reg_nroregistrac = ?mNroRegMadre"
	If !Prg_EjecutoSql(lcSQL,"mwkRegMadre")
		Return .F.
	Endif
	nnrodoc = Val(Transform(mwkRegMadre.reg_numdocumento))
 	ntipoDoc =  Val(Transform(mwkRegMadre.reg_tipodocumento)) &&10

	mfecpas = Ctod("01/01/1900")
	mret = SQLExec(mcon1, "select * from TabRegDocu where TRD_Registracio <> ?mNroRegMadre "+;
	" and TRD_NroDoc=?nnrodoc and TRD_TipoDoc = ?ntipoDoc and TRD_fechapasiva = ?mfecpas","mwkctrlhijos")
	If Reccount("mwkctrlhijos")>tncanthijos
		tncanthijos = Reccount("mwkctrlhijos")
	Endif
	Select mwkRegMadre
	If Empty(tcNomBB)
		mnom 	= Substr(mwkRegMadre.reg_nombrepac,1, At(",",mwkRegMadre.reg_nombrepac)) + ;
		"BEBE DE " + Alltrim(Substr(mwkRegMadre.reg_nombrepac, 1+At(",",mwkRegMadre.reg_nombrepac))) && Nombre del Recién Nacido
	Else
		mnom 	= Substr(mwkRegMadre.reg_nombrepac,1, At(",",mwkRegMadre.reg_nombrepac)) + tcNomBB && Nombre del Recién Nacido

	Endif
* Busco Tipo Doc
	ntdmadre = 10&& mwkRegMadre.reg_tipodocumento &&10
	nproximohijo =Transform(tncanthijos+1,"@L 9") &&"@L 9"
	mnrodocu = Alltrim(Transform(mwkRegMadre.reg_numdocumento))+nproximohijo
	mbusco1  = "reg_numdocumento = ?mnrodocu and reg_nombrepac = ?mnom and reg_tipodocumento = ?ntdmadre and "
	mbuscop1  = " Documento = ?mnrodocu "
	Do sp_busco_por_tipynro_new With mbusco1,0,mbuscop1
	If Reccount('mwkbuscopa1')> 0
		If Messagebox("YA TENEMOS REGISTRADO UN PACIENTE CON ESTE NOMBRE:"+Alltrim(mnom)+"EL DIA:"+Dtoc(mwkbuscopa1.REG_fechamod)+Chr(13)+;
			"¿SE TRATA DEL RECIEN NACIDO QUE ESTA TRATANDO DE CARGAR?",4+32	,"Control de admisiones de RN")=6
			If Reccount('mwkbuscopa1')>0
				Select mwkbuscopa1
			Else
				Select mwkbuspacie01
			Endif
			Go Top
			tcHCE  = REG_nrohclinica
			tnRegi = REG_nroregistrac
			tcNomBB = mnom
			Return(.T.)
		Endif
	Else

		mctexto = Round(Val(Transform(mwkRegMadre.reg_numdocumento)), 0)
		mbusco1 = "where reg_numdocumento = ?mctexto and  "
		Do sp_busco_nombre_paciente_1 With mbusco1, 1, '','','mwkctrolnombre'
		Select * From mwkctrolnombre Where  REG_nroregistrac<>Val(mNroRegMadre) And mnom= reg_nombrepac Into Cursor mwkyaregistro
		If Reccount('mwkyaregistro')>0
*!*				If Messagebox("VA A CARGAR DOS RECIEN NACIDOS CON EL MISMO NOMBRE!!!!! "+Chr(13)+"ESTO NO ES ALGO RAZONABLE!!!"+Chr(13);
*!*					+"¿   TOMAMOS COMO VALIDO EL QUE REGISTRÓ RECIÉN...? "+Chr(13)+"ES LO CORRECTO",4+32;
*!*					,"Control de admisiones de RN")=6
				Select mwkyaregistro
				tcHCE  = REG_nrohclinica
				tnRegi = REG_nroregistrac
				tcNomBB = mnom
				Return(.T.)
*!*				Endif
		Endif
	Endif


	mtdo	=   '10' &&Allt(Transform(mwkRegMadre.reg_tipodocumento)) && Tipo Docu de la madre (Provisorio) '10'
	mdoc	=  Alltrim(Transform(mwkRegMadre.reg_numdocumento))+nproximohijo && Nro Docu de la madre + Nro de hijo(Provisorio)
	mdom	= Allt(Nvl(mwkRegMadre.reg_domicilio,'')) && Domicilio de la madre
	mdom = IIF(EMPTY(mdom),"PEDIR",mdom)
	mloc	= Allt(Nvl(mwkRegMadre.reg_localidad,'')) && Localidad
	mloc = IIF(EMPTY(mloc ),"CAPITAL FEDERAL",mloc)
	mpci	= Allt(Nvl(mwkRegMadre.reg_provincia,'')) && Provincia
	mpci = IIF(EMPTY(mpci),"CAPITAL FEDERAL",mpci)
	mcpo	= Allt(Str(NVL(mwkRegMadre.reg_cpostal,1001), 4)) && Código Postal
	mtel	= Allt(Nvl(mwkRegMadre.reg_telefonos,'')) && Teléfono
	mopera	= Allt(Str(Iif(mwkusuario_sec.codigovax = 0, 99999, mwkusuario_sec.codigovax), 5)) && Código Vax del usuario
	mstrent = ''
	mmail = Allt(Nvl(mwkRegMadre.reg_email,'')) && Email

* Busco la entidad del paciente (madre)
	Do sp_busco_entidad_afiliado1 With mNroRegMadre
	mContAfi = 0

	If !Used('mwkafient')
		Return .F.
	Endif

	mcodent = &tcCurDatMa..cob_codentidad

	Select mwkafient
	Locate For Isnull(mwkafient.ent_fecpas) And mwkafient.afi_codentidad = mcodent
	If !Found()
		Return .F.
	Endif
	nelplan = Iif(!Used("mwkafient"),'',Iif(Empty(Fields('AFI_idplan',"mwkafient")),Val(mwkRegMadre.reg_distrito),mwkafient.AFI_idplan ) )

&& paso a fuera de padron
	If mcodent = 948
		mcodent = 945
	Endif
	If mcodent = 100
		mcodent = 101
	Endif

	If mcodent = 80
		mcodent = 66
	Endif

	If nbloqueoplan  =1
		mafi = 	' Chr(1)'
	Else
		mafi = ' Chr(9)+Allt(Str(NVL(nelplan,0) ,6,0))  + Chr(1)'
	Endif
	For nVar = 0 To 99

		mstrent = ""
		mafibebe = Substr(Alltrim(mwkafient.afi_nroafiliado),1,Len(Alltrim(mwkafient.afi_nroafiliado))-2) ;
		+ Padl(Alltrim(Str(nVar)),2,"00")
		mstrent = mstrent + Allt(Str(mcodent,6,0)) + Chr(9) + ;
		mafibebe + &mafi

		Wait Window "Buscando afiliación: " + mafibebe Nowait

		toForm.olevism.Code = "D REGISHC^RTN003(" + mgraba + ',"'+ mhce + '","'+ ;
		mnom +'","' + mfec + '","' + msex + '",' + mtdo + ',' + ;
		mdoc + ',"' + mdom + '","' + mloc + '","' + mpci + '",' + ;
		mcpo + ',"' + mtel + '","' + mstrent + '",' + mopera + ',"","' + mmail + '")'

		toForm.olevism.execflag = 1

		mmsgerr = toForm.olevism.errorname

		mok		= .olevism.p0					&& Codigo de error
		mresp1	= Round(Val(.olevism.P1), 0)	&& Registracio
		mresp2	= .olevism.P2					&& H. Clinica

		If Val(.olevism.p0) = 88 && Error 88 = No coincide el número de afiliado && paso a numerico ... + chr(9)
			Wait Window "Buscando otra afiliación..... "  Nowait
			Loop
		Endif
		Wait Clear

		If mok <> ''
			mcoderr = Round(Val(.olevism.p0), 0)
			Do sp_busco_texto_error With mcoderr
			Do sp_insert_tabCtrlErr With toForm.olevism.Code, mmsgerr , mwkusuario.idusuario, toForm.Name

			Messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!" + Chr(13) + ;
			alltrim(mwktaberror.textoerror), 48, 'Validacion')
			Exit && error
		Endif

		If !Empty(mresp2)
			mnroreghijo = Val(Transform(mresp1))
&&& asocio con el documento de la madre
			mfecpas = Ctod("01/01/1900")
			mret    = SQLExec(mcon1, "select * from TabRegDocu "+;
			"where TRD_Registracio = ?mnroreghijo and TRD_TipoDoc = ?mtdo and TRD_fechapasiva = ?mfecpas", "mwkcontrol")
			nnrodoc = Val(Transform(mwkRegMadre.reg_numdocumento))
			ntipoDoc = Val(Transform(mtdo))
			If nnrodoc > 0
				If Reccount("mwkcontrol") = 0
					mret = SQLExec(mcon1, "insert into TabRegDocu(TRD_NroDoc,TRD_fechapasiva,TRD_Registracio,TRD_TipoDoc) " + ;
					"values(?nnrodoc,?mfecpas,?mnroreghijo,?ntipoDoc)")
				Endif
			Endif

			Exit && OK
		Endif
	Endfor
	.olevism.mserver = ""

	If Empty(mresp2) And !Empty(mok)
		Return .F.

	Endif

	tnRegi = mresp1
	tcHCE  = mresp2
	tcNomBB = mnom

Endwith
