
lparameters mMotivo

*!*	mMotivo = 'PUESTO NO REGISTRADO 5'

mfecprev   = sp_busco_fecha_srv2('DT')
mInterno   = 0
mnumero    = seconds()*1000
mPriorid   = 2
mSector    = mwkusuario.Sector
mUsuario   = mwkusuario.Idusuario
mAsignadoA = 'OPERADOR'
mtmotivo   = 26 && SIN DEFINIR
mFecActi   = mfecprev
mOpti      = 1 && CORRECTIVO
mfecnull   = ctod('01/01/1900')
mCodSector = 0
mEstado    = 0

mbusco = "Where IDPuesto = ?MyIp and internoTE = 0 "
mactivar = 'N'

do sp_busco_reclamos with 2, mbusco, mactivar

if reccount("mwkrecla") = 0
	mipc = ALLTRIM(myip)+"-"+SYS(0)
	do sp_grabo_reclamos with 1, 'AUTOMATICO', mCodSector, mEstado, ;
		mfecprev, mipc , mInterno, mnumero, ;
		mPriorid, mMotivo, mSector,;
		mUsuario,"",mfecnull,"", mAsignadoA,mtmotivo,mfecnull,;
		mFecActi,mOpti

endif

use in mwkrecla
