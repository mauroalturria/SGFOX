parameters toForm, tcCodAdm, tnCodMed, tcNomMed, tbPrint, tcNomBB

private tcHCE, tnRegi
private tcCodSec
private tnCodHab, tnCodCam
private tcCodAdm, tnCodEnt
local lbResu
lbResu = .f.

tcHCE = ''
tnRegi = 0
*tcNomBB = ''
tcCodSec = 'NUR'
tnCodHab = 0
tnCodCam = 0
tnCodEnt = 0
*tcCodAdm = ''

do while .t.
	if !sp_busco_admision(tcCodAdm,.f.) && mwkadmi, mwkbuspaciev
		exit
	endif

	tcCurDatMa = "mwkbuspaciev"
	if reccount("mwkbuspaciev") = 0
		tcCurDatMa = "mwkadmi"
		messagebox("VERIFICAR INFORMACION DEL PACIENTE",48,"VALIDACION")
		if prg_modo_Exe()
			exit
		endif
	endif

	if !sp_NuevaReg(toForm, @tcHCE, @tnRegi, @tcNomBB, tcCurDatMa )
		exit
	endif

	if !sp_ReservoCama(toForm, tcCodSec, @tnCodHab, @tnCodCam)
		exit
	endif
	if !sp_NuevaAdm(toForm, tnRegi, tnCodHab, tnCodCam, tcCodSec, @tcCodAdm, tnCodMed, tcNomMed, tcCurDatMa, @tnCodEnt,@tcHCE  )
		exit
	endif

	if !sp_grabo_RelReg(0, mwkquiro2.Nroregistrac, mwkquiro2.CodAdmision , tnRegi, tcCodAdm , mwkusuario_sec.codigovax )
*	Return .f.
	endif


	TEXT To lcsql Textmerge Noshow Pretext 7
		Select * From Entidades Where Ent_CodEnt = ?tnCodEnt
	ENDTEXT

	If !Prg_EjecutoSql(lcSql,"mwkAuxEnt")
		Return .F.
	Endif



	define window winPrint from 0, 0 to 1, 1
	activate window winPrint in screen

	mNomb = alltrim(tcNomBB)
	mNacio = ""
	mCober = Alltrim(mwkAuxEnt.Ent_Descrient)
	mDocu = Alltrim(tcHCE)
	mAdm = alltrim(tcCodAdm)
	mSexo = 'I'
	mestado = ""
	mesquem = ""
	mlsector = "(ADMINTNEO)"
	mAdmRn = tcCodAdm  && Alltrim(Nvl(mwkquiro2.CodAdmision,''))
	mNomRn = tcNomBB && Alltrim(mwkquiro2.PacNombre)

	mid = 0
	mob = ""
	mdt = sp_busco_fecha_serv('DT')
	mForm = "frmMesa1"
	pac = ''
	mprio = 0

	mCodEnt = tnCodEnt
*actualizo socio
	mimot = 18
	mdtF    = sp_busco_fecha_serv('DT')
	mfecnul = ctod("01/01/1900")
	musu = iif(used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
	midusu = iif(used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
	SELECT &tcCurDatMa 
	mobserva = ALLTRIM(pac_nombrepaciente)+" Hab:"+tnCodHab+"-"+tnCodCam+" Medico:"+ALLTRIM(tcNomMed)
	mpac 	= tcNomBB 
	madmis	=  mAdmRn
	ment 	= tnCodEnt
	mmot	= mimot 
	do sp_grabo_mesaent with mpac ,mmot,mobserva,ment,madmis


*!*		mLabel = "! 0 100 1000 1" + Chr(10) + ;
*!*			"WIDTH 87"+ Chr(10) + ;
*!*			"TEXT 2(0,270,1,1) 10 455 " + Left(mNomb,16) + Chr(10) + ;
*!*			"TEXT 1(0,270,1,1) 40 455 " + Left(mCober,21) + Chr(10) + ;
*!*			"TEXT 1(0,270,1,1) 65 455 " + "(" + mSexo + ") - DOC " + mDocu + Chr(10) + ;
*!*			"BARCODE_FONT TEXT 1(0,0,1,1,1,1)"+ Chr(10) + ;
*!*			"BARCODER270 CODE128(2:4) 120 400 25 " + mAdm + Chr(10) + ;
*!*			"END"


	if prg_modo_exe()
		if tbPrint
			do sp_pac_pulsera with mNomb, mNacio, mCober, mDocu, mAdm, mSexo, mestado, mesquem, mlsector, mAdmRn, mNomRn
		endif
	else
		lcmsg = mAdmRn + " | " + mNomRn
		messagebox(lcmsg,64,"INFO")
	endif

	release windows winPrint

	lbResu = .t.
	exit

enddo
RETURN lbResu 