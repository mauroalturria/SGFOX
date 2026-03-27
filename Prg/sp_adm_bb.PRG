Parameters toForm, tcCodAdm, tnCodMed, tcNomMed, tbPrint, tcNomBB, mFHRN,tncanthijos,tdhorareal

Private tcHCE, tnRegi
Private tcCodSec
Private tnCodHab, tnCodCam
Private tcCodAdm, tnCodEnt
Local lbResu
lbResu = .F.
If Vartype(tncanthijos)<>"N"
	tncanthijos=0
Endif
tcHCE = ''
tnRegi = 0
*tcNomBB = ''
tcCodSec = 'NUR'
tnCodHab = 0
tnCodCam = 0
tnCodEnt = 0
*tcCodAdm = ''
*	Set Step On
Do While .T.
	If !sp_busco_admision(tcCodAdm,.F.) && mwkadmi, mwkbuspaciev
		Exit
	Endif

*!*	****************************
*!*	****************************

	tcCurDatMa = "mwkbuspaciev"
	If Reccount("mwkbuspaciev") = 0
		tcCurDatMa = "mwkadmi"
		Messagebox("VERIFICAR INFORMACION DEL PACIENTE",48,"VALIDACION")
		If prg_modo_Exe()
			Exit
		Endif
	Endif

	If !sp_NuevaReg(toForm, @tcHCE, @tnRegi, @tcNomBB, tcCurDatMa,tncanthijos)
		Exit
	Endif

	If !sp_ReservoCama(toForm, tcCodSec, @tnCodHab, @tnCodCam)

		Exit
	Endif
	If !sp_NuevaAdm(toForm, tnRegi, tnCodHab, tnCodCam, tcCodSec, @tcCodAdm, tnCodMed, tcNomMed, tcCurDatMa, @tnCodEnt,@tcHCE  )
		Exit
	Endif
	mtFHRN  = tdhorareal

	If !sp_grabo_RelReg(0, mwkquiro2.Nroregistrac, mwkquiro2.CodAdmision , tnRegi, tcCodAdm , mwkusuario_sec.codigovax,mtFHRN )
*	Return .f.
	Endif
	mfec = sp_busco_fecha_serv("DD")
	Do sp_grabo_tabregCond_item With mwkquiro2.Nroregistrac,1,"RN",0,mfec+30,mwkusuario_sec.Id
	Do sp_grabo_tabregCond_item With tnRegi,1,"RN",0,mfec+365,mwkusuario_sec.Id
	Define Window winPrint From 0, 0 To 1, 1
	Activate Window winPrint In Screen

	mNomb = tcNomBB && alltrim(mwkquiro2.PacNombre)
	mNacio = ""
	mCober = Alltrim(mwkquiro2.ent_descrient) && ""
	mDocu = Alltrim(Nvl(mwkquiro2.reg_nrohclinica,''))
	mAdm = tcCodAdm  && alltrim(nvl(mwkquiro2.CodAdmision,''))
	mSexo = "I"
	mestado = ""
	mesquem = ""
	mlsector = "(ADMINTNEOFH)" && "(ADMINTNEO)" && "(MMBB)"
	mAdmRn = "" && tcCodAdm  && Alltrim(Nvl(mwkquiro2.CodAdmision,''))
	mNomRn = "" && tcNomBB && Alltrim(mwkquiro2.PacNombre)

	mid = 0
	mob = ""
	mdt = sp_busco_fecha_serv('DT')
	mForm = "frmMesa1"
	pac = ''
	mprio = 0

	mCodEnt = tnCodEnt
*actualizo socio
	mimot = 38
	mdtF    = sp_busco_fecha_serv('DT')
	mfecnul = Ctod("01/01/1900")
	musu = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
	midusu = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
	Select &tcCurDatMa
	mdiagno		= 'NACIDO VIVO NEOM'
	mobserva 	= Left("De: IQB "+Alltrim(tnCodHab)+"-";
		+Alltrim(tnCodCam)+" A: "+tcCodSec +" Prof:"+Transform( tnCodMed)+" Dx: "+ Alltrim(mdiagno)+" Obs: ",250)
	mpac 	= tcNomBB
	madmis	= tcCodAdm  &&  mAdmRn
	ment 	= tnCodEnt
	mmot	= mimot
	mret=SQLExec(mcon1,"SELECT HoraLLegada, HoraFinalizacion FROM SOCIOaux where id = 1","mwksocaux")
	If !(Between(mdtF,mwksocaux.HoraLLegada ,mwksocaux.HoraFinalizacion ) And mwksocaux.idmotivo = 1)
		Do sp_busco_estados With 57,' and tipo = 20 and subestado = '+Transform(mxcentromedico),'mwkHabSQL'&&
		If mwkHabSQL.estado = 2
			Do sp_grabo_mesaentsql   With mpac ,mmot,mobserva,ment,madmis
		Else
			Do sp_grabo_mesaent  With mpac ,mmot,mobserva,ment,madmis

		Endif
	Endif
	Do sp_grabo_mesaentaux  With mpac ,mmot,mobserva,ment,madmis

	If prg_modo_Exe()
		If tbPrint
			mSecu = ''
			Do sp_pac_pulsera With mNomb, mNacio, mCober, mDocu, mAdm, mSexo, mestado, mesquem, mlsector, mAdmRn, mNomRn, mSecu, mFHRN
		Endif
	Else
		lcmsg = mAdmRn + " | " + mNomRn
		Messagebox(lcmsg,64,"INFO")
	Endif

	Release Windows winPrint

	lbResu = .T.
	Exit

Enddo
Return lbResu
