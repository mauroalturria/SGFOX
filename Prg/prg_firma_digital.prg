Parameters mcodmed,mlmed,mlmat,lbusresp,msec,mlmedjefe,mlmatjefe,lmedsinfirma,msolfirma
*mlmed = ''
*mlmat = ''
mlmedjefe = ''
mlmatjefe = ''
If mxambito>1
	Return .F.
Endif
lfirma = .T.
mfiltra = .t.
mcodmedfirma = mcodmed
If mcodmedfirma>1
	Do sp_busco_medico_dat With mcodmedfirma
	If Used("MwkDatMed")
		If Reccount("MwkDatMed")>0
			mcodmedfirma = MwkDatMed.id
			mlmed = Nvl(MwkDatMed.nombre,'')
			mlmat = Nvl(MwkDatMed.matriculas,'')
			mfiltra = !inlist(nvl(MwkDatMed.tpf_filtro,0),0,7)
		Endif
		Use In Select('MwkDatMed')
	Endif
Endif
lfirma = (mcodmedfirma>1 and !mfiltra )
lmedsinfirma = .T.
mfirma = "C:\temp\imagenes\firmas\firma"+Sys(2015)+".tif"
mhayfirma = File("X:\qepd1a1\digito\"+Alltrim(Transform(mcodmedfirma))+"_firma_ms.exe")
If mhayfirma
	msolfirma = "X:\qepd1a1\digito\"+Alltrim(Transform(mcodmedfirma))+"_firma_ms.exe"
	lmedsinfirma = .F.
Else
	prg_carga_firma(mcodmedfirma,2,lfirma )
	mfirma= "C:\temp\imagenes\firmas\firma_ms.tif"
	mfirmasol = (File(mfirma) And lfirma )
	mhayfirma = (File(mfirma) And lfirma )
	If mhayfirma
		msolfirma = mfirma
		lmedsinfirma = .F.
	Endif
Endif
If lmedsinfirma And lbusresp
* Busco Jefe en X
	mSector = msec
	mlnjefesec = sp_busco_responsable('',mSector)
	Do sp_busco_medico_dat With mlnjefesec
	mhayfirma = File("X:\qepd1a1\digito\"+Alltrim(Transform(mlnjefesec))+"_firma_ms.exe")
	If Used('mwkDatMed')
		mlmedjefe = MwkDatMed.nombre
		mlmatjefe = MwkDatMed.matriculas
	Endif
	Use In Select('mwkDatMed')
	If mhayfirma
		msolfirma = "X:\qepd1a1\digito\"+Alltrim(Transform(mlnjefesec))+"_firma_ms.exe"
		lmedsinfirma = .T.
		mhayfirma = .F.
		lfirma = .T.
	Else
* Busco la firma del jefe en la tabla
		lfirma = .T.
		prg_carga_firma(mlnjefesec,2,lfirma)
		mhayfirma = (File(mfirma) And lfirma )
		If mhayfirma
			msolfirma = mfirma
			lmedsinfirma = .T.
			mhayfirma = .F.
		Else
			msolfirma = ""
			lmedsinfirma = .T.
			mhayfirma = .F.
		Endif

	Endif
* Busco Jefe Tabla
Else
	lmedsinfirma = .F.
Endif
Return lfirma
