* Busco Firma del Profesional (Informes)
* 2018/07/25 - Fabián
* ------------------------------------------
Parameters lnIDdoc

* Busco Datos de Prestador para la firma

lcSQL = "SELECT * FROM PRESTADORES WHERE ID = ?lnIDdoc"

mret = SQLExec(mcon1,lcSQL,"mwkMedicoFirma")

If mret < 1
	Messagebox(Upper("Error en la conexión. No se obtuvieron los datos de la firma."),48,"Firma de Reporte de Informes")
	Return .F.
Endif

* Busco la firma:

lcSQL = "SELECT IMAGEN FROM TABMEDFOTO WHERE IDMEDICO = ?lnIDdoc AND TIPO = 3 and fechabaja = '1900-01-01'"

mret = SQLExec(mcon1,lcSQL,"mwkImagenFirma")

If mret < 1
	Messagebox(Upper("Error en la conexión. No se obtuvo la firma."),48,"Firma de Reporte de Informes")
	Return .F.
Endif

* Busco Imágen de Firmas

Public mlcfirma

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif

Select mwkImagenFirma

If Reccount("mwkImagenFirma")>0
	m1=.F.
	m2=.F.
	m3=.F.
	mSigo = .F.
	mdbf=''
	mfpt=''
	mjpg=''
	Do While !mSigo
		mSub = Alltrim(Str(Seconds()))
		mdbf = "C:\temp\imagenes\firmas\firm_"+mSub+".dbf"
		If !File(mdbf)
			m1=.T.
		Endif
		mfpt = "C:\temp\imagenes\firmas\firm_"+mSub+".fpt"
		If !File(mfpt)
			m2=.T.
		Endif
		mjpg = "C:\temp\imagenes\firmas\frep_"+mSub+".jpg"
		If !File(mjpg)
			m3=.T.
		Endif
		If m1 And m2 And m3
			mSigo = .T.
		Else
			mSigo = .F.
		Endif
	Enddo
	
	Copy To (mdbf)
	Use In mwkImagenFirma
	imagen = Fopen(mdbf,12)
	Fseek(imagen,43)
	Fwrite(imagen,'M')
	Fclose(imagen)
	Use (mdbf)
	lcRun = "Select firm_"+mSub
	&lcRun
	lcImagen = imagen
	Strtofile(lcImagen,mjpg)
	lcRun = "Use In firm_"+mSub
	&lcRun
	If Used("mwkBorrar")
		Insert Into mwkBorrar (archivo) Values (mdbf)
		Insert Into mwkBorrar (archivo) Values (mfpt)
		Insert Into mwkBorrar (archivo) Values (mjpg)
	Endif
	mlcfirma = mjpg
Else
	mlcfirma = ""
Endif

Return mlcfirma
