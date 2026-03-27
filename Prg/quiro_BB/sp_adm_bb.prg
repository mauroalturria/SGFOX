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

	define window winPrint from 0, 0 to 1, 1
	activate window winPrint in screen

	mNomb = tcNomBB && alltrim(mwkquiro2.PacNombre)
	mNacio = ""
	mCober = Alltrim(mwkquiro2.ent_descrient) && ""
	mDocu = Alltrim(Nvl(mwkquiro2.reg_nrohclinica,''))
	mAdm = tcCodAdm  && alltrim(nvl(mwkquiro2.CodAdmision,''))
	mSexo = "I"
	mestado = ""
	mesquem = ""
	mlsector = "(ADMINTNEO)" && "(MMBB)"
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
	mimot = 18
	mdtF    = sp_busco_fecha_serv('DT')
	mfecnul = ctod("01/01/1900")
	musu = iif(used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
	midusu = iif(used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
	SELECT &tcCurDatMa 
	mobserva = ALLTRIM(pac_nombrepaciente)+" Hab:"+tnCodHab+"-"+tnCodCam+" Medico:"+ALLTRIM(tcNomMed)
	mpac 	= tcNomBB 
	madmis	= tcCodAdm  &&  mAdmRn
	ment 	= tnCodEnt
	mmot	= mimot 
	do sp_grabo_mesaent with mpac ,mmot,mobserva,ment,madmis
Set Step On
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