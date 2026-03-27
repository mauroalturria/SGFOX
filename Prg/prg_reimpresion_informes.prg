Lparameters tnIdInforme

mProto = Alltrim(Str(mwkvaleinfo.nroprotocolo,16,0))
mValeN = Alltrim(Str(mwkvaleinfo.nrovale))
mnuminf = Alltrim(Str(mwkvaleinfo.Id))

*-- Agrego 2017
mCodFirmaMed = mwkvaleinfo.codmedfirma
*--

*!*	tnIdInforme = 748978
*!*	tnIdInforme = 748936

*!*	INICIO DE DATOS
TEXT To lcSql Textmerge Noshow Pretext 7

	Select PAC_nombrepaciente,
		Ent_CodEnt, ENT_descrient,ENT_nroprestadorexterno,
		TabEstados.Descrip,
		STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS NOMBRE,
		STRING(NVL(Prestadores.Matriculas,''), NVL(TabMedExterno.Matricula,' ')) AS matriculas,
		STRING(NVL(Prestadores.Sexo,'')) AS Sexo,
		VALESASIST.val_fechasolicitud, VALESASIST.val_codservvale, VALESASIST.Val_CodPun,VALESASIST.Val_CodAdmision,
		VALESASIST.val_verficasolicit,VAL_codsector,VAL_codvaleasist,VAL_tipopaciente,pac_centromedico,INFORMES.*
		From INFORMES
		left join VALESASIST ON INFORMES.NROVALE = VALESASIST.VAL_CODVALEASIST
		left join TabEstados ON INFORMES.EstadoInforme = TabEstados.Estado and Propietario = 10 and Tipo = 1
		Left join Prestadores on Prestadores.Id = INFORMES.CodMedFirma
		Left join TabMedExterno on TabMedExterno.ID = INFORMES.CodMedFirma
		Left Join pacientes on valesasist.val_CodAdmision = pacientes.Pac_CodAdmision
		left join coberturas on pacientes.PAC_codadmision = coberturas.COB_pacientes
		left join entidades on coberturas.COB_codentidad = entidades.ENT_codent
		Where INFORMES.ID = ?tnIdInforme

ENDTEXT
mRet = SQLExec(mcon1,lcSql,"mwkvalpro")
If mRet <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif

*!* CODIGO AGREGADO PARA QUE SE PASEN LAS VARIABLES AL REPORTE

mFecVale = Alltrim(Dtoc(mwkvalpro.val_fechasolicitud)) && alltrim(DAT_VALE(4))
mSecconforme = Alltrim(Str(mwkvalpro.val_verficasolicit))
Do sp_busco_npac With mwkvalpro.Val_CodAdmision, 0 && mwkpacnom
mbusco = " where REG_nrohclinica = '" + mwkpacnom.PAC_codhce + "' and "
Do sp_busco_nombre_paciente With mbusco, 1 && mwkbuspacie
mPaciente = Upper(Strtran(Alltrim(mwkbuspacie.reg_nombrepac),",",", "))
mEntidad =  Upper(Alltrim(mwkbuspacie.ent_descrient))
mHisClin = Upper(Alltrim(mwkbuspacie.reg_nrohclinica))

*!*----------------FIN DE CODIGO AGREGADO--------------------


If !sp_busco_presinsuvas_prest(mwkvalpro.Val_CodPun) && mwkpresinpre
	Return .F.
Endif

mfechaes = Iif(Isnull(Alltrim(Substr(Ttoc(mwkvalpro.fechahoraestudio),1,10))),"",Alltrim(Substr(Ttoc(mwkvalpro.fechahoraestudio),1,10)))
mfechaestudio = Iif(Empty(mfechaes),"  /  /   ",mfechaes)

* 2017/11
mfechainforme = prg_busco_fecinfolog(tnIdInforme)
* -------

mProto = Alltrim(Str(mwkvalpro.nroprotocolo,16,0))
mPaciente = Upper(Strtran(Alltrim(mwkvalpro.PAC_nombrepaciente),",",", "))
mEntidad =  Upper(Alltrim(mwkvalpro.ent_descrient))
mDonde = ''
mServ = ""
If !SP_Busco_Tabla_Id("Servicios", " SER_codserv = " + Transform(mwkvalpro.val_codservvale), "mwkServicio")
	Return .F.
Endif
mServ = Alltrim(Nvl(mwkServicio.SER_descripserv,''))
Use In Select("mwkServicio")
*---------------------------------------------
*!*	FIN DE DATOS
*--------------------------------------------------------
Create Cursor mwkElInforme (Lineas m, Negrita l(1))

Insert Into mwkElInforme (Lineas, Negrita) Values (Alltrim(mwkvalpro.informesolotexto),.F.)
Insert Into mwkElInforme (Lineas, Negrita) Values (" ",.F.)

MLineas = Alltrim(mwkvalpro.informesolotexto)
mTitulo  = ""
*--------------------------------------------------------
mdoc = Iif(Empty(mwkvalpro.Sexo),"Dr. ",Iif(mwkvalpro.Sexo = 'F', "Dra. ", "Dr. "))
mdoc = mdoc + Proper(mwkvalpro.Nombre)
mMN = "M.N. " + Alltrim(mwkvalpro.matriculas)

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
Insert Into cdat2 (Descrip, bold, titulo, Firma) Values (mMN , .T., .T., .T.)

*!*	*----- Agregado 2017/04
*!*	lnfirma = sp_busco_firma_informe (mCodFirmaMed)
*!*	If lnfirma = 0 And Empty(mCodFirmaMed) Or Isnull(mCodFirmaMed)
*!*		Messagebox("NO ELIGIO PROFESIONAL",0,"Impresión de Informe")
*!*		Return
*!*	Endif

*!*	If lnfirma = 0 And !Empty(mCodFirmaMed) Or !Isnull(mCodFirmaMed)
*!*		If !Messagebox("ESTE PROFESIONAL NO POSEE FIRMA ELECTRONICA." + Chr(13) + "IMPRIME EL INFORME IGUAL ?",4,"Impresión de Informe")=6
*!*			Return
*!*		Endif
*!*	Endif
*!*	*-----

* 2020/08 Se busca firma del profesional
mhayfirma = .T.
lcfirma = ""
If Isnull(mCodFirmaMed)
	mhayfirma = .F.
Else
	If !mCodFirmaMed>0
		mhayfirma = .F.
	Else
		lcfirma = sp_busco_firma_informe (mCodFirmaMed)
		If !File(lcfirma)
			mhayfirma = .F.
		Endif
	Endif
Endif
nresp = 0
If !mhayfirma
	nresp = Messagebox("ESTE PROFESIONAL NO POSEE FIRMA ELECTRONICA." + Chr(13) + "IMPRIME EL INFORME IGUAL ?",4,"Impresión de Informe")=6
Endif
If nresp = 7
	Return .F.
Endif
* ------

Do Case
Case Inlist(mwkvalpro.val_codservvale,7700,6300) && TOMO Y RESO -- DERECHA
	Select cdat2
	Report Form repinfo07 Preview

Case Inlist(mwkvalpro.val_codservvale, 5163, 7900 ) && ECO
	Sele mwkPrestaVal
	Report Form repinfo08 Preview

Case Inlist(mwkvalpro.val_codservvale, 7400 ) && ECOCARDIOGRAMA
	Sele mwkPrestaVal
	Report Form repinfo08 Preview

Case Inlist(mwkvalpro.val_codservvale, 7100 ) && RAYOS
	Select mwkPrestaVal
	Report Form repinfo08a Preview

Otherwise
	Select mwkPrestaVal
	Report Form repinfo08 Preview
Endcase



Use In Select("mwkvalpro")
Use In cdat2
Use In Select("mwkPrestaVal")
Use In Select("mwkElInforme")
Use In Select("mwkbuspacie")
Use In Select("mwkpacnom")

Return .T.



