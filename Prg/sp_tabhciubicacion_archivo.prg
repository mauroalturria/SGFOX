************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 20/06/2003
************************
*Fecha Ultima Modif: 20/06/2003
*******************************

Parameters  mNroregistrac, mAnaquel, mCaja ,mSector,mFichero,mnro_adm



			 
	mret = sqlexec(mcon1,'Insert Into TabhciUbicacion (hca_registrac, Anaquel, NroCaja, Sector, Fichero, hci_nroAdm )'+ ;
' values ( ?mNroregistrac,?mAnaquel ,?mCaja ,?mSector , ?mFichero ,?mnro_adm)' )


if mret < 0
	messagebox('No se Pudo agregar datos a ' + vr_tabla ,16,'Valiacion')
	mret = 0
endif	
return mret