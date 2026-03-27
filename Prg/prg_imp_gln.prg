*
* Actualización GLNs
*
Local oExcel, I, lcFile

mfecha = sp_busco_fecha_serv('DD')

mnew   = 0
mnewm  = 0

Use In Select("mwkglnew")
Create Cursor mwkglnew(lGLN C(13))

*!* For mi = 1 To 2

*!*		If mi = 1
*!*			mdestina = 'GLNs de BS.AS.'
*!*		Else
*!*			mdestina = 'GLNs de C.A.B.A.'
*!*		Endif

oExcel = Createobject("Excel.Application")

*!* lcFile = Getfile("xls", 'GLN' , 'Procesar' ,0 , 'Planilla de ' + mdestina + ' a procesar')

lcFile = Getfile("xls", 'GLN', 'Procesar', 0, 'Planilla a procesar')

If Empty(lcFile)
	Return .F.
Endif
oExcel.Workbooks.Open(lcFile)

I = 2
Do While .T.

*!*	Wait Windows 'Leyendo XLS de ' + mdestina + ' fila nro.:'+Transform(I,'999999') Nowait

	Wait Windows 'Leyendo XLS, fila nro.:'+Transform(I,'999999') Nowait

	mRsoc = Nvl(oExcel.Cells(I,1).Text,"")
	If Empty(mRsoc)
		Exit
	Endif

	mTipoA     = Alltrim(Nvl(oExcel.Cells(I,3).Text,""))
	mGLNP      = Alltrim(Nvl(oExcel.Cells(I,4).Text,""))
	mRsocGlnP  = Alltrim(Nvl(oExcel.Cells(I,5).Text,""))
	mGLN       = Alltrim(Nvl(oExcel.Cells(I,6).Text,""))
	mCuit      = Alltrim(Nvl(oExcel.Cells(I,7).Text,""))
	mDir       = Alltrim(Nvl(oExcel.Cells(I,8).Text,""))
	mNum       = Val(Nvl(oExcel.Cells(I,9).Text,"0"))
	mECalle    = Alltrim(Nvl(oExcel.Cells(I,10).Text,""))
	mPiso      = Alltrim(Nvl(oExcel.Cells(I,11).Text,""))
	mDpto      = Alltrim(Nvl(oExcel.Cells(I,12).Text,""))
	mTel       = Alltrim(Nvl(oExcel.Cells(I,13).Text,""))
	mEmail     = Alltrim(Nvl(oExcel.Cells(I,14).Text,""))
	mProvin    = Alltrim(Nvl(oExcel.Cells(I,15).Text,""))
	mLocalidad = Alltrim(Nvl(oExcel.Cells(I,16).Text,""))
	mCodPost   = Val(Nvl(oExcel.Cells(I,17).Text,""))

	Use In Select("mwkctrl")
	mret = SQLExec(mCon1,"SELECT * from TabTraGLN where TGL_gln = ?mGLN","mwkctrl")

	If mret < 0
		=Aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Exit
	Endif

	If Used("mwkctrl")
		If Reccount("mwkctrl")>0
			mlid = mwkctrl.Id
			mnewm = mnewm + 1
			mret = SQLExec(mCon1, "update TabTraGLN set " + ;
				"TGL_Rsoc      = ?mRsoc,"+;
				"TGL_TipoA     = ?mTipoA,"+;
				"TGL_GLNP      = ?mGLNP,"+;
				"TGL_RsocGlnP  = ?mRsocGlnP,"+;
				"TGL_Cuit      = ?mCuit,"+;
				"TGL_Dir       = ?mDir,"+;
				"TGL_Num       = ?mNum,"+;
				"TGL_ECalle    = ?mECalle,"+;
				"TGL_Piso      = ?mPiso,"+;
				"TGL_Dpto      = ?mDpto,"+;
				"TGL_Tel       = ?mTel,"+;
				"TGL_Email     = ?mEmail,"+;
				"TGL_Provin    = ?mProvin,"+;
				"TGL_Localidad = ?mLocalidad,"+;
				"TGL_CodPost   = ?mCodPost "+;
				"where id = ?mlid")
		Else
			mnew = mnew + 1
			Insert Into mwkglnew(lGLN) Values (mGLN)
			mret = SQLExec(mCon1, "Insert into TabTraGLN (" + ;
				"TGL_Rsoc, TGL_TipoA, TGL_GLNP, " + ;
				"TGL_RsocGlnP, TGL_GLN, TGL_Cuit, " + ;
				"TGL_Dir, TGL_Num, TGL_ECalle, " + ;
				"TGL_Piso, TGL_Dpto, TGL_Tel, " + ;
				"TGL_Email, TGL_Provin, TGL_Localidad," + ;
				"TGL_CodPost ) Values " + ;
				"("+ ;
				"?mRsoc, ?mTipoA, ?mGLNP, " + ;
				"?mRsocGlnP, ?mGLN, ?mCuit, " + ;
				"?mDir, ?mNum, ?mECalle, " + ;
				"?mPiso, ?mDpto, ?mTel, " + ;
				"?mEmail, ?mProvin, ?mLocalidad, " + ;
				"?mCodPost ) " )
		Endif
	Endif
	If mret < 0
		=Aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Exit
	Endif
	I = I + 1

Enddo

oExcel.Quit
Release oExcel

*!* Endfor

If mret < 0
	Return .F.
Endif

*!* *If mnew > 0

Messagebox("SE HAN INCORPORADO : "+Alltrim(Str(mnew)) + ", GLNs" + Chr(10) + Chr(10) + "SE HAN MODIFICADO  : "+Alltrim(Str(mnewm))+ ", GLNs",48,"Proceso Finalizado")

If Used("mwkglnew")
	If Reccount("mwkglnew")>0
		Use In Select("mwkglnew2")
		Use In Select("mwkglnew3")
		mret = SQLExec(mCon1, "select * from TabTraGLN","mwkglnew2" )
		If mret < 0
			=Aerror(merror)
			Messagebox(merror(3))
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Else
			Select * From mwkglnew2;
				join mwkglnew On mwkglnew.lGLN = mwkglnew2.TGL_GLN;
				into Cursor mwkglnew3
			Select mwkglnew3
			Go Top
			marchi = 'C:\TEMP\INFORMES\GLN'+Dtos(mfecha)
			Copy To (marchi) Type Xl5

			Messagebox("Se genero el archivo " + marchi + ", con detalle de nuevos registros","Reporte")
		Endif
	Endif
Endif

*!* *Endif


*Public oExcel as Excel.Application
*!*	RAZON SOCIAL				TEXTO
*!*	TIPO AGENTE					TEXTO
*!*	GLN PRINCIPAL				TEXTO
*!*	RAZON SOCIAL GLN PRINCIPAL	TEXTO
*!*	GLN							TEXTO
*!*	CUIT						TEXTO
*!*	DIRECCION					TEXTO
*!*	NUMERO						NUMERO
*!*	ENTRE CALLES				TEXTO
*!*	PISO						TEXTO
*!*	DEPARTAMENTO				TEXTO
*!*	TELEFONO					TEXTO
*!*	EMAIL						TEXTO
*!*	PROVINCIA					TEXTO
*!*	LOCALIDAD					TEXTO
*!*	CODIGO POSTAL				NUMERO

Use In Select("mwkglnew")
Use In Select("mwkctrl")
Use In Select("mwkglnew2")
Use In Select("mwkglnew3")

Return .T.
