Lparameters valeinforme

Public mFechaEstudio,mServ,mProto,mPaciente,mEntidad,mValeN,mSecConforme,mHisClin,mFecVale,mFechaInforme,mLineas,mdoc,mdonde,mMn,mnuminf,mlcfirma,mhayfirma


* Activo el foxypreview
Do foxypreviewer.App

mVale = valeinforme && mwkgrilla.vale
*mvale = 47137645
cfile = ''
nsec = 0

TEXT To lcSql Textmerge Noshow Pretext 7
	Select informes.id as informeid, PAC_nombrepaciente,
		Ent_CodEnt, ENT_descrient,
		TabEstados.Descrip,
		STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS NOMBRE,
		STRING(NVL(Prestadores.Matriculas,''), NVL(TabMedExterno.Matricula,' ')) AS matriculas,
		STRING(NVL(Prestadores.Sexo,'')) AS Sexo,
		VALESASIST.val_fechasolicitud, VALESASIST.val_codservvale, VALESASIST.Val_CodPun,VALESASIST.Val_CodAdmision,
		VALESASIST.val_verficasolicit,VALESASIST.val_codsector,VALESASIST.val_habitacion,VALESASIST.val_cama,INFORMES.*
		From INFORMES
		left join VALESASIST ON INFORMES.NROVALE = VALESASIST.VAL_CODVALEASIST
		left join TabEstados ON INFORMES.EstadoInforme = TabEstados.Estado and Propietario = 10 and Tipo = 1
		Left join Prestadores on Prestadores.Id = INFORMES.CodMedFirma
		Left join TabMedExterno on TabMedExterno.ID = INFORMES.CodMedFirma
		Left Join pacientes on valesasist.val_CodAdmision = pacientes.Pac_CodAdmision
		left join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes
		left join entidades on coberturas.COB_codentidad = entidades.ENT_codent
		where informes.NroVale = ?mVale and informes.estadoinforme = 3
ENDTEXT

If !prg_EjecutoSql(lcSQL,"mwkvalpro",.F.)
	Return .F.
Endif

If Reccount('mwkvalpro')>0 && 2
	Select mwkvalpro
	Go Top In mwkvalpro
*	Scan All && scan 2
	nsec = nsec + 1
* Acá van todos los informes
	If !sp_busco_presinsuvas_prest(mwkvalpro.Val_CodPun) && mwkpresinpre
		Return .F.
	Endif
* Variables de encabezado
	mdoc = ""
	mFecVale = Alltrim(Dtoc(mwkvalpro.val_fechasolicitud)) && alltrim(DAT_VALE(4))
	mSecConforme = Alltrim(Str(mwkvalpro.val_verficasolicit))
*!*			If Thisform.origen = 2
*!*				Do sp_busco_npac With mwkvalpro.Val_CodAdmision, 0 && mwkpacnom
*!*				Thisform.nrohc = Alltrim(mwkpacnom.pac_codhce)
*!*				Thisform.label8.Caption = Alltrim(mwkpacnom.pac_nombrepaciente)
*!*				Thisform.label9.Caption = 'Nro HC: ' + Alltrim(Thisform.nrohc)
*!*			Endif
*mbusco = " where REG_nrohclinica = '" + mwkpacnom.PAC_codhce + "' and "
*Do sp_busco_nombre_paciente With mbusco, 1 && mwkbuspacie
*mPaciente = Upper(Alltrim(thisform.label3.Caption))
*mEntidad =  Upper(Alltrim(thisform.txtnomEnt.Value))
	mnuminf = Alltrim(Str(mwkvalpro.informeid))
	mValeN = Alltrim(Str(mwkvalpro.nrovale))
	mHisClin = Alltrim(mwkpamipacreg.reg_nrohclinica)
	mfechaes = Iif(Isnull(Alltrim(Substr(Ttoc(mwkvalpro.fechahoraestudio),1,10))),"",Alltrim(Substr(Ttoc(mwkvalpro.fechahoraestudio),1,10)))
	mFechaEstudio = Iif(Empty(mfechaes),"  /  /   ",mfechaes)
	mFechaInforme = prg_busco_fecinfolog(mwkvalpro.informeid)
	mProto = Alltrim(Str(mwkvalpro.nroprotocolo,16,0))
	mPaciente = Upper(Strtran(Alltrim(mwkvalpro.pac_nombrepaciente),",",", "))
	mEntidad =  Upper(Alltrim(mwkvalpro.ent_descrient))
	mdonde = Alltrim(mwkvalpro.val_codsector) + Iif(Len(Nvl(mwkvalpro.val_habitacion,''))>0,"- Hab.: " + Alltrim(mwkvalpro.val_habitacion),"") + Iif(Len(mwkvalpro.val_cama)>0," - Cama: " + Alltrim(Nvl(mwkvalpro.val_cama,'')),"")
* Busco Servicio
	mServ = ""
	If !SP_Busco_Tabla_Id("Servicios", " SER_codserv = " + Transform(mwkvalpro.val_codservvale), "mwkServicio")
		Return .F.
	Endif
	mServ = Alltrim(Nvl(mwkServicio.SER_descripserv,''))
	Use In Select("mwkServicio")
* Fin Variables

* Cuerpo
	Create Cursor mwkElInforme (Lineas m, Negrita l(1))

	Insert Into mwkElInforme (Lineas, Negrita) Values (Alltrim(Nvl(mwkvalpro.informesolotexto,' ')),.F.)
	Insert Into mwkElInforme (Lineas, Negrita) Values (" ",.F.)

	mLineas = Alltrim(mwkvalpro.informesolotexto)
	mTitulo  = ""
*--------------------------------------------------------
	mdoc = Iif(Empty(mwkvalpro.Sexo),"",Iif(mwkvalpro.Sexo = 'F', "Dra. ", "Dr. "))
	mdoc = mdoc + Proper(mwkvalpro.Nombre)
	mMn = Iif(Empty(mwkvalpro.matriculas),"","M.N. " + Alltrim(mwkvalpro.matriculas))
	
	* Médico
*!*		Do sp_busco_medico_dat With mwkvalpro.CodMedFirma
*!*		mdoc = Iif(Empty(mwkdatmed.Sexo),"Dr. ",Iif(mwkdatmed.Sexo = 'F', "Dra. ", "Dr. "))
*!*		mdoc = mdoc + Proper(Alltrim(mwkdatmed.Nombre))
*!*		mMn = "M.N. " + Alltrim(mwkdatmed.matriculas)
	
	* Firma del profesional


	mCodFirmaMed = mwkvalpro.CodMedFirma
	mhayfirma = File("X:\qepd1a1\digito\"+Alltrim(Transform(mCodFirmaMed))+"_firma_ms.exe")
	If mhayfirma
		mlcfirma = "X:\qepd1a1\digito\"+Alltrim(Transform(mCodFirmaMed))+"_firma_ms.exe"
	Else
		mlfirmaOk = sp_busco_firma_informe (mCodFirmaMed)
		If Empty(mlfirmaOk)
		mlcfirma = "C:\tempdoc\firmaenblanco.jpg"
		else
		mlcfirma = mlfirmaOk
		endif
	Endif
	
	* Cuerpo informe

	lnResu = Alines(MaLineas,Alltrim(mwkvalpro.informesolotexto))

	Create Cursor cdat2 (Descrip m, bold l(1), titulo l(1), Firma l(1))

	Select mwkpresinpre.pre_descriprest As Descrip ;
		From mwkpresinpre ;
		Into Cursor mwkPrestaVal

	Use In Select("mwkpresinpre")

	Select mwkPrestaVal
	Scan All
		Insert Into cdat2 (Descrip, bold, titulo) Values (mwkPrestaVal.Descrip, .T., .T.)
		Select mwkPrestaVal
	Endscan

	Insert Into cdat2 (Descrip, bold) Values ("", .F.)
	Insert Into cdat2 (Descrip, bold) Values ("INFORME:", .T.)
	Insert Into cdat2 (Descrip, bold) Values ("", .F.)

	For I = 1 To lnResu
		Insert Into cdat2 (Descrip) Values (MaLineas(I))
	Next
	Select cdat2
	Replace bold With .T. For At(":",Descrip)>0
	Replace Firma With .F. All
	Go Top In cdat2

	Insert Into cdat2 (Descrip, bold, titulo) Values ("", .F., .F.)
	Insert Into cdat2 (Descrip, bold, titulo, Firma) Values (mdoc, .T., .T., .T.)
	Insert Into cdat2 (Descrip, bold, titulo, Firma) Values (mMn , .T., .T., .T.)



* Exporta reporte a PDF usando Foxypreviewer
	If !Directory('C:\TEMPDOC\VALPRINT\')
		Md C:\TEMPDOC\VALPRINT
	Endif
	cfile = 'C:\TEMPDOC\VALPRINT\'+Alltrim(Str(mVale))+'_INFO'+Alltrim(Str(nsec))+'.pdf'
	If File(cfile)
		Delete File (cfile)
	Endif

	If !Empty(mfechaes)
		Select mwkvalpro
		Do Case
		Case Inlist(mwkvalpro.val_codservvale,7700,6300) && TOMO Y RESO -- DERECHA
			Select cdat2
			Report Form repinfo07 Object Type 10 To File &cfile

		Case Inlist(mwkvalpro.val_codservvale, 5163, 7900, 7400 ) && 5163/7900 Ecografía -- 7400 Ecocardiograma
			Select mwkPrestaVal
			Report Form repinfo08 Object Type 10 To File &cfile

		Case Inlist(mwkvalpro.val_codservvale, 7100 ) && 7100 Rayos
			Select mwkPrestaVal
			Report Form repinfo08apami Object Type 10 To File &cfile

* Case Inlist(mwkvalpro.val_codservvale,5180,7200)

		Otherwise
			Select mwkPrestaVal
			Report Form repinfo08pami Object Type 10 To File &cfile
		Endcase
	Endif

	Use In Select('cdat2')
	Use In Select("mwkPrestaVal")
	Use In Select("mwkElInforme")

* Verifico si armó el archivo pdf y lo informo en el estado.

	mnestado = 0
	If !Empty(cfile)
		If File(cfile)
			mnestado = 1
		Endif
	Endif

*	Endscan && fin scan 2
	Select mwkvalpro
Endif && fin 2

Use In Select('mwkVales')
Use In Select('mwkValpro')


hayfila = ''
If File(cfile)
	hayfila = cfile
Endif

Release mlcfirma,cfile,mhayfirma

Do foxypreviewer.App With 'Release' && Desactiva Foxypreviewer

Return hayfila
