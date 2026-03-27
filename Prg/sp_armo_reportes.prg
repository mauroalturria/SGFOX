Parameters mHisCli, mNroAdmin, mFAdmin, mFAlta, mFDesde, mFHasta, mReImpre, mEntidad, mNEntidad, lnOrigen, mPDF,cRuta

Local nPregRep, nPregPreview, nPregVFP6

nPregRep = 0
nPregPreview = 0

* Variables Cabecera (Fechas)
Public dFechaInforme, dFechaTranInicio, dFechaTranFinal, cEntidad


If Vartype(mEntidad)="N"
	cEntidad = "Cód: " + Alltrim(Str(mEntidad))
Else
	cEntidad = "---"
Endif

If Vartype(mNEntidad)="C"
	cEntidad = cEntidad + " " + mNEntidad
Else
	cEntidad = "---"
Endif

If Empty(mNEntidad)
	cEntidad = "---"
Endif


dFechaInforme = Dtoc(sp_busco_fecha_serv("DT"))

If mReImpre = 0

	Select mwkhttransf
	Go Bottom
	dFechaTranInicio = mwkhttransf.htt_fecha
	Go Top
	dFechaTranFinal = mwkhttransf.htt_fecha

Else

	dFechaTranInicio = mFDesde
	dFechaTranFinal = mFHasta

Endif


* Variables Cabecera (Paciente)

Public cNAdmisionPAC, cNAfiliadoPAC, cFAdmin, cFAlta, cNombrePAC, cSExoPAC, cNHClinicaPAC, cEdadPAC

Select mwkbuspacie_ht

If Vartype(mNroAdmin)="C"
	cNAdmisionPAC = mNroAdmin
Else
	cNAdmisionPAC = "---"
Endif

cNAfiliadoPAC = Alltrim(mwkbuspacie_ht.Afi_nroafiliado)

If Vartype(mFAdmin)="D"
	cFAdmin = Dtoc(mFAdmin)
Else
	cFAdmin = "---"
Endif

If Vartype(mFAlta)="D"
	cFAlta = Dtoc(mFAlta)
Else
	cFAlta = "---"
Endif


cNombrePAC = Alltrim(mwkbuspacie_ht.reg_nombrepac)
cSExoPAC = mwkbuspacie_ht.reg_sexo
cNHClinicaPAC = Alltrim(mwkbuspacie_ht.reg_nrohclinica)
cEdadPAC = prg_edad(mwkbuspacie_ht.reg_fecnacimiento)

* Variables Cabecera (Grupo Sanguineo)

Public cGS, cGF, cGGeno, cGDU, cGKell
Select mwkhtgrupo
cGS = Alltrim(mwkhtgrupo.htg_grupo)
cGF = Iif(Alltrim(mwkhtgrupo.htg_rh) = "+","+ (POSITIVO)","- (NEGATIVO)")
cGGeno = mwkhtgrupo.htg_genotipo
cGDU = Iif(Empty(Alltrim(mwkhtgrupo.htg_du)),'',Iif(Alltrim(mwkhtgrupo.htg_du) = '-','Neg','Pos'))
cGKell = mwkhtgrupo.htg_genotipokell


**************************
* Agregado 2016-10-28
* Fabián
* Firma Profesional Hemato
**************************

lnFirma = sp_busco_firma_hemoterapia(lnOrigen) && 1 = fecha del servidor / 2 = fecha de reimpresión

Public mcAclaracion

If lnFirma = 0
*!*	cSexo = ""
*!*	cNombre = ""
*!*	cMatricula = ""
	mcAclaracion = ""
Else
	Select mwkMedicoFirma
	cSexo = Iif(Alltrim(Upper(mwkMedicoFirma.sexo))="F","Dra. ","Dr. ")
	cNombre = Alltrim(Proper(mwkMedicoFirma.nombre))
	cMatricula = Alltrim(Transform(mwkMedicoFirma.matriculas))
	mcAclaracion = cSexo + cNombre + Chr(13) + "Matrícula Nº " + cMatricula
Endif

*********************


If mReImpre = 0


* Armo Cursor de Transfusiones para reporte de 1 solo registro.

	Select * From mwkhttransf_temp Where mwkhttransf_temp.HTT_Verif = 1 Into Cursor mwkTmpRep


Else

* Acá va si viene del form pisos 11 (Desde - Hasta)
* Fecha: 19/02/2016
* Modificado: 02/03/2016


	Select * From mwkhttransf Where mwkhttransf.htt_fecha Between dFechaTranInicio And dFechaTranFinal Order By mwkhttransf.htt_fecha Desc Into Cursor mwkTmpRep


Endif


Select mwkTmpRep

* 28/03/2016 = Si no hay registros, no imprime.
* 08/03/2018 = Opción para PDF.

If !Vartype(mPDF) = "N"
	mPDF = 0
Endif

mRetorno = 0

Do Case

Case mPDF = 1

	If Reccount("mwkTmpRep") > 0
		Go Top
* Exporta reporte a PDF usando Foxypreviewer
		Do Locfile("FoxyPreviewer.App")
		cFILE = cRuta + "\HEMO_" + Alltrim(mNroAdmin) + ".PDF"
*		Report Form ("C:\DESAGUEMES\REP\rephemato01.frx") Object Type 10 To File &cFILE
		Report Form rephemato01 Object Type 10 To File &cFILE
		mRetorno = 1
	Endif

Otherwise

	If Reccount("mwkTmpRep") > 0
		Go Top
		nPregPreview = 0
		nPregPreview = Messagebox("¿ Desea visualizar el informe antes de imprimir ?",4,"Impresión de Informes")

		If nPregPreview = 6
			Report Form rephemato01 Preview In Screen
		Else
			Report Form rephemato01 To Printer Prompt
		Endif
	Else
		Messagebox("No hay información de éste paciente para imprimir",48,"Impresión de Informes")
	Endif
Endcase


Use In Select("mwkTmpRep")

Release dFechaInforme, dFechaTranInicio, dFechaTranFinal
Release cNAdmision, cNAfiliado, cFAdmin, cFAlta, cNombre, cSexo, cNHClinica, cEdad
Release cGS, cGF, cGGeno, cGDU, cGKell

Return mRetorno