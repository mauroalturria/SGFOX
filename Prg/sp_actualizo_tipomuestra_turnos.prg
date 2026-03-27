* mVale viene en formato character

Lparameters mVale

Local mInsumo
Local mTipoMuestra

mInsumo = 0
mTipoMuestra = ""

mret = SQLExec(mcon1,"select valesasist,val_codvaleasist " +;
	"from ValesAsist " +;
	"where val_codvaleasist = ?mVale","mwkValeAsistPlx")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DEL VALE " + mVale,26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Else


	Select mwkValeAsistPlx
	Go Top

	mValeAsist = mwkValeAsistPlx.valesasist

*!*		mret = SQLExec(mcon1,"select * from Presinsuvas where PIA_valesasist = ?mValeAsist","mwkPresinplx")

*!*		If mret<=0
*!*			Messagebox("ERROR EN LA LECTURA DE PRESINSUVAS - VALE " + mVale,26,"ERROR")
*!*			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Else

*!*			Select mwkPresinplx
*!*			Go Top

	Select mwkTmpPrest  && creado en frmturno08b.actualizatipomuestra()
	Scan All

*			mInsumo = mwkPresinplx.PI_codprest

		If mwkTmpPrest.codserv = 6400
			mInsumo = mwkTmpPrest.codprest

*!*				Select * From mwksep_presta Where codprest = mInsumo And codserv = 6400 Into Cursor mwkTmpPlx
*!*				Select mwkTmpPlx
*!*				Go Top

*!*				If Reccount() > 0
*!*					mTipoMuestra = CodTipoMuestra
			*mTipoMuestra = mwkTmpPrest.codtipomuestra
			mTipoMuestra = NVL(mwkTmpPrest.IdTipoMuestra,'')
			
			IF !EMPTY(mTipoMuestra)
			   ActualizaTipoMuestra(mValeAsist,mInsumo,mTipoMuestra)
			ENDIF
			
*!*				Endif

*!*				Select mwkPresinplx
		Endif

		Select mwkTmpPrest

	Endscan

Endif


Use In Select("mwkValeAsistPlx")
Use In Select("mwkPresinplx")
Use In Select("mwkTmpPlx")


* -----------------------------------------------
Function ActualizaTipoMuestra(mValeAsist,mInsumo,mTipoMuestra)
* -----------------------------------------------

Local lResult

lResult = .T.
mret = SQLExec(mcon1,"update Presinsuvas set " +;
	"Pia_CodMuestraPx = ?mTipoMuestra " +;
	"where Pia_ValesAsist = ?mValeAsist and Pia_codprest = ?mInsumo ")

If mret<=0
	Messagebox("ERROR AL ACTUALIZAR TIPO DE MUESTRA EN PRESINSUVAS" + Chr(10) +;
		"VALEASIST : " + Transform(mValeAsist) + Chr(10)+ ;
		"INSUMO : " + Transform(mInsumo) + Chr(10) + ;
		"TIPO DE MUESTRA : " + TRANSFORM(mTipoMuestra)	,26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

	lResult = .F.
Endif


Return lResult
