*
* Actualización GTINs
*
Local oExcel, I, lcFile

mfecha = sp_busco_fecha_serv('DD')
mnew   = 0

mfechamov = sp_busco_fecha_serv("DT")
midusua   = mwkusuario.idusuario

Create cursor mwkgtinew(lGTIN C(14))
lcFile = Getfile("xls", 'GTIN' , 'Procesar' ,0 , 'Planilla de GTIN a procesar')
If empty(lcFile)
	Return .F.
Endif
oExcel = Createobject("Excel.Application")
oExcel.Workbooks.Open(lcFile)

I = 2
Do While .T.
	Wait windows 'Leyendo XLS de GTINs, fila nro.:'+transform(I,'999999') nowait
	mIdMed = Val(Nvl(oExcel.Cells(I,1).Value,"0"))
	If mIdMed = 0
		Exit
	Endif

	mgTin   = Nvl(oExcel.Cells(I,2).Value         ,"")
	mdes    = Alltrim(Nvl(oExcel.Cells(I,3).Value ,""))
	munid   = Val(Nvl(oExcel.Cells(I,4).Value     ,"0"))
	mFrma   = Alltrim(Nvl(oExcel.Cells(I,5).Value ,""))
	mPres   = Alltrim(Nvl(oExcel.Cells(I,6).Value ,""))
	
	mdispo  = Alltrim(Nvl(oExcel.Cells(I,7).Value,""))  && Nuevo Campo comunicado por Mariana Briola 07/08/2015 
	                                                    && DISPOSICION DE TRAZABILIDAD
	                                                    && me reubica subsiguientes campos GRACIAS ANMAT !!!!
	
	mGLN    = Alltrim(Nvl(oExcel.Cells(I,8).Value ,""))
	mRsoc   = Alltrim(Nvl(oExcel.Cells(I,9).Value ,""))
	mTipoA  = Alltrim(Nvl(oExcel.Cells(I,10).Value,""))
	mCuit   = Alltrim(Nvl(oExcel.Cells(I,11).Value,""))
	mProvin = Alltrim(Nvl(oExcel.Cells(I,12).Value,""))

	mMonodr = Alltrim(Nvl(oExcel.Cells(I,13).Value,"")) && Nuevo Campo comunicado por Mariana Briola 07/08/2015 (MONODROGAS)

	Use in select("mwkctrl")
	mret = sqlexec(mCon1,"SELECT * from TabTraGTIN where TGT_gtin = ?mgTin","mwkctrl")
	If mret < 0
		=aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Exit
	Endif




	If used("mwkctrl")
		If reccount("mwkctrl")>0
			mlid = mwkctrl.id
			mret = sqlexec(mCon1, "update TabTraGTIN set "+;
				"TGT_IdMed  = ?mIdMed, "+;
				"TGT_des    = ?mdes, "+;
				"TGT_unid   = ?munid, "+;
				"TGT_Frma   = ?mFrma, "+;
				"TGT_Pres   = ?mPres, "+;
				"TGT_GLN    = ?mGLN, "+;
				"TGT_Rsoc   = ?mRsoc, "+;
				"TGT_TipoA  = ?mTipoA, "+;
				"TGT_Cuit   = ?mCuit, "+;
				"TGT_Provin = ?mProvin,"+;
				"TGT_disposicion = ?mdispo,"+;
				"TGT_monodrogra  = ?mMonodr,"+;
				"TGT_usuario = ?midusua,"+;
				"TGT_fecmov  = ?mfechamov"+;
				" where id = ?mlid ")
		Else
			mnew = mnew + 1
			Insert into  mwkgtinew(lGTIN) values (mgTin)
			mret = sqlexec(mCon1, "Insert into TabTraGTIN (" + ;
				"TGT_IdMed, TGT_gTin, TGT_des, TGT_unid, " + ;
				"TGT_Frma, TGT_Pres, TGT_GLN, TGT_Rsoc, " + ;
				"TGT_TipoA, TGT_Cuit, TGT_Provin, TGT_usuario, TGT_fecmov, TGT_disposicion, TGT_monodrogra) Values " + ;
				"("+ ;
				"?mIdMed, ?mgTin, ?mdes, ?munid, " + ;
				"?mFrma, ?mPres, ?mGLN, ?mRsoc, " + ;
				"?mTipoA, ?mCuit, ?mProvin, ?midusua, ?mfechamov, ?mdispo, ?mMonodr)" )
		Endif
	Endif
	If mret < 0
		=aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Exit
	Endif
	I = I + 1
Enddo

oExcel.Quit
*oExcel = null
Release oExcel

If mret < 0
	Return .F.
Endif

If mnew > 0
	Messagebox("SE HAN INCORPORADO "+alltrim(str(mnew))+", GTINs",48,"Atención")
	Use in select("mwkgtinew2")
	Use in select("mwkgtinew3")
	mret = sqlexec(mCon1, "select * from TabTraGTIN","mwkgtinew2" )
	If mret < 0
		=aerror(merror)
		Messagebox(merror(3))
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Else
		Select * from mwkgtinew2;
			join mwkgtinew on mwkgtinew.lGTIN = mwkgtinew2.TGT_Gtin;
			into cursor mwkgtinew3
		Select mwkgtinew3
		Go top
		marchi = 'C:\TEMP\INFORMES\GTIN'+Dtos(mfecha)
		Copy to (marchi) type xl5
		Messagebox("SE GENERO "+alltrim(marchi),48,"Atención")
	Endif
Endif

*!*	ID MEDICAMENTO	NUMERO
*!*	GTIN	        TEXTO
*!*	DESCRIPCION		TEXTO
*!*	UNIDADES		NUMERO
*!*	FORMA			TEXTO
*!*	PRESENTACION	TEXTO
*!*	GLN				TEXTO
*!*	RAZON SOCIAL	TEXTO
*!*	TIPO AGENTE		TEXTO
*!*	CUIT			TEXTO
*!*	PROVINCIA		TEXTO

*!* NUEVOS 12/08/2015

*!* DISPOSICION     TEXTO
*!* MONODROGA       TEXTO


Use in select("mwkglnew")
Use in select("mwkctrl")
Use in select("mwkglnew2")
Use in select("mwkglnew3")

Return .T.
