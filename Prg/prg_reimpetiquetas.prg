**********************************************************************
* Program....: _PRG_REIMPETIQUETAS.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 27 December 2021, 19:27:38
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 27 December 2021 / 19:27:38
* Purpose....: 		Impresión de Etiquetas invocadas como clase - Codig copiado de Formulario frmadmision07.scx
**********************************************************************
*

*!*	* Close Tables All
*!*	* Release All
*!*	*
*!*	oEtiquetas = Newobject("cEtiquetas","...\prg\prg_ReImpEtiquetas.prg")
*!*	oEtiquetas.PreparoAmbiente('613234-5')
*!*	oEtiquetas.cmdetiquetas()
*!*	*-- Matamos el objeto creado
*!*	oEtiquetas = .Null.

*//////////////////////////////////////////////////////////////
Define Class cEtiquetas As Custom

	oAbc = '' 							&& Contiene el objeto ABC instanciado

	NroAdmision = '' 					&& Contiene el Nro de Admision
	lfirma = .F. 						&& Si lleva Firma o no
	cpredeter = ''						&& Impresora Predeterminada
	lmetiqueta = ''						&& Tiquetera
	NroEti = 30 							&& Cantidad de Etiquetas a Imprimir (Valor por defecto DOS )
	mNroHClin = ''						&& Nro de Historia Clinica
	nprinthojas = 0 						&& Contiene la cantidad de Hojas a Imprimir
	optvista = 1 			            && Indica : 1 = A4 , 2 = Tiquetera
	NombrePaciente = '' 					&& Contiene nombre Paciente
	Lmprinter = ''						&& Contiene nombre de impresora
	NroCuenta = 0


***************************************************************************************************
*  Procedure : Init
***************************************************************************************************
*  Parameters  :
*  Description :   Inicio de Procedimiento
***************************************************************************************************
*
	Procedure Init()
	Public lmeconecto
	lmeconecto = .F.
*-- Parece que la conexion no se realiza
	If !Used("mwkserver1")
		lmeconecto = .T.
		DO sp_desconexion
		Do sp_conexion
	Endif

*-- Instanciamo sla clase ABC en una propiedad de la clase
	This.oAbc = Newobject("abc","..\lib\lib_custom.vcx")

	Endproc

***************************************************************************************************
*  Procedure : PreparoAmbiente
***************************************************************************************************
*  Parameters  :
*  Description :   Prepara los datos  la configuracion para la impresion (Emula Init del Formulario frmadmision07.scx )
***************************************************************************************************
*
	Procedure PreparoAmbiente( tcNroAdmision As Character ) HelpString "Preparo el inicio de la impresion de Etiquetas "
*  Lparameters miadmision

	This.NroAdmision = tcNroAdmision

	Release msolfirma, mhayfirma

	Public msolfirma, mhayfirma
	lcErrorAnt = On("ERROR")
	On Error *

	With This
		If Vartype( This.NroAdmision )<>"C"
			This.NroAdmision = ''
		Endif

*-- Set Classlib To "c:\desaguemes\lib\lib_fbases_sg.vcx"
		Set Classlib To "..\lib\lib_fbases_sg.vcx"

		.AddProperty("lfirma",.T.)
		.lfirma = .T.

		On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

		Use In Select('mwklista')
		.cpredeter = Set('printer',2)
		.lmetiqueta = .cpredeter

*!*	         If Aprinters(aImpresor) > 0  						&& Si hay controladores de impresora instalados.

*!*	            For i = 1 To Alen(aImpresor,1)
*!*	               If At("ETIQUETA",Upper(aImpresor[i,1])) > 0
*!*	                  * .optvista.Value = 2
*!*	                  nAnswer = Messagebox( 'Imprime En : A4 ( SI ) o Imprime en Tiquetera ( NO ) ',4+16+256, 'Aviso al Usuario'  )
*!*	                  Do Case
*!*	                     Case nAnswer = 6 &&      WAIT WINDOW 'You chose Yes'
*!*	                        This.optvista = 1
*!*	                     Case nAnswer = 7 &&      WAIT WINDOW 'You chose No'
*!*	                        This.optvista = 2
*!*	                  Endcase

*!*	                  .lmetiqueta = aImpresor[i,1]
*!*	                  Exit
*!*	               Endif
*!*	            Next
*!*	         Endif

*!*	         Thisform.txtcuenta.Enabled = (mwkexe.nomexe = "ADMISION" )

		If Used('mwkbuspacie1')
			Select mwkbuspacie1
			Scatter Memvar
			If Vartype(m.reg_nombrepac)="C"
				.txtpaciente.Value 	= mwkbuspacie1.reg_nombrepac
				.mNroHClin = mwkbuspacie1.reg_nrohclinica
			Else
				.mNroHClin = ''
			Endif
		Else
			.mNroHClin = ''
		Endif

*!*	         .txtnroadm.Value = This.NroAdmision
*!*	         .txtnroadm.LostFocus()
*!*	         .txtnroadm.ReadOnly  = !(mwkexe.nomexe = "ADMISION" )

		This.NroAdmLostfocus( This.NroAdmision )

	Endwith

	On Error &lcErrorAnt

	Endproc

***************************************************************************************************
*  Procedure : NroAdmLostfocus
***************************************************************************************************
*  Parameters  :
*  Description :   Busca datos de Admision
***************************************************************************************************
*
	Procedure NroAdmLostfocus( lcNroAdmision )

	With This
		If Val(lcNroAdmision )> 0

			Do sp_busco_pac_int_impre With Allt( lcNroAdmision )
			.NombrePaciente = mwklista.pac_nombrepaciente
			lret = .T.

			If !Eof('mwklista')

*!*	               .cmrprinthceintepi.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmrprinthceint.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdprintamb.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdprint.Enabled = .T.
*!*	               .cmdetiquetas.Enabled = .T.
*!*	               .CmdPrintHCE.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdPrinterficha.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdreimpreplaca.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdvaleint.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdHemo.Enabled = (mwkexe.nomexe = "ADMISION" )
*!*	               .cmdprintsol.Enabled = (mwkexe.nomexe = "ADMISION" )

				If Inlist(Nvl(mwklista.TPV_Estado,0),1,3)

					Do Form frmpass_sec With mwklista.pac_codhci To lret
					mhc = Transf(mwklista.pac_codhci)
					Do sp_insert_tabCtrlErr With Iif(lret,"SI","NO") + mwkusuario.idusuario, mwkexe.nomexe+' factura '+ miform + '-'+mhc, '',''
				Endif

*-- Cantidad de Etiquetas
				.NroEti = 24

				If !lret
					Messagebox("USTED NO ESTA AUTORIZADO A VER ESTOS DATOS",48,"CONTROL SISTEMAS")
					Select * From mwklista Where 1=2 Into Cursor mwklista
				Endif
			Else
				Messagebox("NO SE ENCONTRO ESTA ORDEN DE ADMISION", 48,"Validacion")
			Endif
		Endif
	Endwith

	Endproc

***************************************************************************************************
*  Procedure : InsertoLinea
***************************************************************************************************
*  Parameters  :
*  Description :   Inserta una linea en la impresoin
***************************************************************************************************
*
	Procedure InsertoLinea( ccampo, ntipo )
* Lparameters ccampo,ntipo

	nlin = Alines(mimat,ccampo,.T.)
	limpre = .F.

	For i = 1 To nlin
		If !Empty(mimat(i))
			limpre = .T.
			npos32 = Rat(" ",Left(mimat(i),90))
			npos32 = Iif(npos32>0 And Len(Alltrim(Left(mimat(i),90))) = 90 ,npos32,90)

			Insert Into mwkevolprin (tipo,linea) Values (ntipo,Left(mimat(i),npos32))

			If Len(Alltrim(mimat(i)))>90
				mimati = Substr(Alltrim(mimat(i)),npos32 +1 )
				Do While Len(mimati)>1
					npos32 = Rat(" ",Left(mimati,90))
					npos32 = Iif(npos32>0 And Len(Alltrim(Left(mimati,90))) = 90 ,npos32,90)
					Insert Into mwkevolprin (tipo,linea) Values (ntipo,Left(mimati,npos32 ))
					mimati = Substr(Alltrim(mimati),npos32 +1)
				Enddo
			Endif
		Endif
	Next

	Endproc

***************************************************************************************************
*  Procedure : Carga_Firma
***************************************************************************************************
*  Parameters  :
*  Description :   Carga la Firma del Profesional
***************************************************************************************************
*
	Procedure Carga_Firma( codigov, mtipo )
* Lparameter codigov, mtipo

	Release mlcfirma,lfile ,lok

	If mtipo = 1 &&&auditor
		If File("C:\temp\imagenes\firma_ac.tif")
			Erase "C:\temp\imagenes\firma_ac.tif"
		Endif

*busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
		Do sp_busco_docgral With 19, "frmautor01",,codigov,,"C:\temp\imagenes\firma_ac."
*!*		mPropietario = 38
		If !File("C:\temp\imagenes\firma_ac.tif")
			Do sp_busco_docgral With 19, "frmautor01",,54035,,"C:\temp\imagenes\firma_ac."
		Endif

	Else

*-- Preguto si va la firma o no
		eMessageTitle = 'Aviso al Usuario '
		eMessageText  = 'Impresión Sin Firma Digitalizada?'
		nDialogType   = 4 + 16 + 256
*  4 = Yes and No buttons
*  16 = Stop sign icon
*  256 = Second button is default

		nAnswer = Messagebox(eMessageText, nDialogType, eMessageTitle)
		Do Case
		Case nAnswer = 6 				&& WAIT WINDOW 'You chose Yes'
			lnFirma = 0
		Case nAnswer = 7      			&& WAIT WINDOW 'You chose No'
			lnFirma = 1
		Endcase

* If Thisform.chkfirma.Value = 0 And Thisform.lfirma
		If lnFirma = 0 And This.lfirma

*	busco en tabdocgral la firma y lo grabo en C:\temp\imagenes\firma_ac.jpg
			lcdirectorio = 'C:\temp\imagenes\firmas'
			If !Directory(lcdirectorio)
				Md &lcdirectorio
			Endif

			Do sp_busco_prof_foto With codigov,3   && en codigov trae el id de medico

			Select Top 1 Imagen  As firmag From mprofFoto ;
				order By Id Desc ;
				into Cursor mprofFirma

			If Reccount('mprofFirma') =0
				This.lfirma = .F.
			Else
				If Isnull(mprofFirma.firmag)
					This.lfirma = .F.
				Else
					If File("C:\temp\imagenes\firmas\firma_ms.tif")
						Erase "C:\temp\imagenes\firmas\firma_ms.tif"
					Endif
					If File("C:\temp\imagenes\firmas\firma_ms.tif")
						Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
							"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
							"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
						This.lfirma = .F.
						Return
					Endif

					If Used('ima')
						Use In ima
					Endif

					If Used('__DATA')
						Use In __DATA
					Endif

					If Used ('imagen')
						Use In Imagen
					Endif

					If File("C:\temp\imagenes\firmas\imagen.dbf")
						Erase ("C:\temp\imagenes\firmas\imagen.dbf")
					Endif
					If File("C:\temp\imagenes\firmas\imagen.dbf")
						Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
							"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
							"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
						This.lfirma = .F.
						Return
					Endif
					If File("C:\temp\imagenes\firmas\imagen.fpt")
						Erase ("C:\temp\imagenes\firmas\imagen.fpt")
					Endif
					If File("C:\temp\imagenes\firmas\imagen.fpt")
						Messagebox("NO SE PUDO RECUPERAR LA FIRMA DEL PROFESIONAL!!"+Chr(13)+;
							"SALGA TOTALMENTE DE LA APLICACION Y VUELVA A INGRESAR" +Chr(13)+;
							"SI PERSISTE EL ERROR COMUNIQUESE CON SISTEMAS",48,"ALERTA")
						This.lfirma = .F.
						Return
					Endif

					Select mprofFirma
					Copy To "C:\temp\imagenes\firmas\imagen"
					Use In mprofFirma

* cambia el campo general de tipo memo
					LL = Fopen("C:\temp\imagenes\firmas\imagen.dbf",12)
					Fseek(LL,43)
					Fwrite(LL,'M')
					Fclose(LL)

					If Used('__DATA')
						Use In __DATA
					Endif

					If Used ('imagen')
						Use In Imagen
					Endif

					If Used('mprofFirma')
						Use In mprofFirma
					Endif

					lcdirectorio = 'C:\temp\imagenes\firmas'
					lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
					lcnombre = This.archivofirma

					Use C:\temp\imagenes\firmas\Imagen.Dbf In 0 Alias mFirma
					lfile = mFirma.firmag
					lok = Strtofile(lfile ,lcnombre)
					lcnombre    = 'C:\temp\imagenes\firmas\firma_ms.tif'
					Use In Select("mFirma")
				Endif
			Endif

			=Adir(acontrolfirma,"C:\temp\imagenes\firmas\firma_ms.tif")

			If File("C:\temp\imagenes\firmas\firma_ms.tif")
				If acontrolfirma(1,2)<10
					Messagebox("NO SE PUDO RECUPERAR LA FIRMA")
					Erase "C:\temp\imagenes\firmas\firma_ms.tif"
				Endif
			Endif
		Endif

	Endif
*!* ------------------ PRUEBA LA IMAGEN EN UN REPORTE NATIVO DE VFP9.0 ---------------
*!*			lnimage = 	Filetostr(lcnombre)
*!*			lcfirma = lcdirectorio  +'\' + lcid   + '.tif'
*!*			.Pg.PgAnexos.Olefirmaguardar.Imagefileformat= 6
*!*			.Pg.PgAnexos.Olefirmaguardar.Writeimagefile(lcfirma)
*!*			mlcfirma = lcfirma
*!*			Report Form reportfirma.frx To Printer Noconsole
*!* ------------------- FIN DE PRUEBA DE IMPRESION EN REPORTE -------------------

	Return

	Endproc

***************************************************************************************************
*  Procedure : cmdEtiquetas
***************************************************************************************************
*  Parameters  :
*  Description :   Imprime la etiqueta propiament dicha
***************************************************************************************************
*
	Procedure cmdetiquetas()

	Public gcmpaci , gcmEnti , gcmCon1, gcmEspe , gcmCent , gcmNafi , gcmHcli

	With This
		Select mwklista
		Go Top

* .NroEti = 0

		.oAbc.mpaci	= ''

		If Empty(.Lmprinter )

			Declare Integer GetDefaultPrinter In winspool.drv;
				STRING  @ pszBuffer,;
				INTEGER @ pcchBuffer

			nBufsize = 250
			cPrinter = Replicate(Chr(0), nBufsize)
			= GetDefaultPrinter(@cPrinter, @nBufsize)
			cPrinter = Substr(cPrinter, 1, At(Chr(0),cPrinter)-1)
			.Lmprinter = cPrinter

		Endif

		Set Step On
* PUBLIC gcmpaci , gcmEnti , gcmCon1, gcmEspe	, gcmCent , gcmNafi , gcmHcli

		If !Eof('mwklista')
			.oAbc.mpaci	= Allt(mwklista.pac_nombrepaciente)
			gcmpaci  = Allt(mwklista.pac_nombrepaciente)

			.oAbc.menti	= Alltrim(mwklista.ent_descrient)
			gcmEnti = Alltrim(mwklista.ent_descrient)

			.oAbc.mcon1	= mwklista.pac_codadmision
			gcmCon1 = mwklista.pac_codadmision

			.oAbc.mespe	= Transf(mwklista.pac_edad)
			gcmEspe = Transf(mwklista.pac_edad)

			.oAbc.mcent	= Iif( .NroAdmision ='522709-5'," ",mwklista.pac_sexo)
			gcmCent = Iif( .NroAdmision ='522709-5'," ",mwklista.pac_sexo)

			.oAbc.mnafi  = mwklista.AFI_nroafiliado
			gcmNafi  = mwklista.AFI_nroafiliado

			.oAbc.mhcli	= mwklista.pac_codhce
			gcmHcli	= mwklista.pac_codhce

*!*	         Else

*!*	            If .cmdprintamb.Enabled And Val(.txtnroadm.Value )= 0 And !Eof('mwkadmi')

*!*	               .oAbc.mpaci	= Allt(mwkadmi.pac_nombrepaciente)
*!*	               gcmpaci = Allt(mwkadmi.pac_nombrepaciente)

*!*	               .oAbc.menti	= Alltrim(mwkafient.ent_descrient)
*!*	               gcmEnti = Alltrim(mwkafient.ent_descrient)

*!*	               .oAbc.mcon1	= .NroCuenta
*!*	               gcmCon1 	= .NroCuenta

*!*	               .oAbc.mespe	= Transf(mwkadmi.pac_edad)
*!*	               gcmEspe	= Transf(mwkadmi.pac_edad)

*!*	               .oAbc.mcent	= Iif( .NroAdmision ='522709-5'," ",mwkadmi.pac_sexo)
*!*	               gcmCent = Iif( .NroAdmision ='522709-5'," ",mwkadmi.pac_sexo)

*!*	               .oAbc.mnafi  = mwkafient.AFI_nroafiliado
*!*	               gcmNafi = mwkafient.AFI_nroafiliado

*!*	               .oAbc.mhcli	= mwkadmi.pac_codhce
*!*	               gcmHcli	= mwkadmi.pac_codhce

*!*	            Endif

		Endif

* .NroEti = .txteti.Value

		If !Empty( .oAbc.mpaci )

*-- If Messagebox('IMPRESION DE ETIQUETAS ?', 4+32+0 ,'IDENTIFICACION') = 6

			Messagebox("COLOQUE LAS ETIQUETAS PARA PROSEGUIR",64,"Aviso al Usuario")

			If Used('etiquetas')
				Use In etiquetas
			Endif

*!*	 GUS 2019-08-20

			Create Cursor etiquetas (eti C(5))
			For i = 1  To .NroEti
				Insert Into etiquetas (eti) Values ("")
			Next i

			If !sp_busco_estados(1, " and tipo = 111", "mwkEti01")
				Return .F.
			Endif

			If Nvl(mwkEti01.Estado,0) = 1
				Private merror
				merror = 0

				lcCodADM =  Alltrim( .NroAdmision )
				lcCodVax = Transform(mwkusuario.codigovax)
				lcSQL = "CALL ZabEtiquetas_Generar( '" + lcCodADM + "'," + Transform( .NroEti ) + "," + lcCodVax + ", ?@merror )"

				If SQLExec( mcon1, lcSQL,"") <= 0
					Messagebox("ERROR AL GENERAR ETIQUETAS",16,"ERROR")
					Return .F.
				Endif

				If merror = 0
					Messagebox("ERROR AL GENERAR ETIQUETAS",16,"ERROR")
					Return .F.
				Endif

				lcSQL = "SELECT TOP " + Transform( .NroEti ) + " * FROM ZabEtiquetas WHERE ZET_Pacientes = ?lcCodADM and ZET_CodVaxAdd = ?lcCodVax ORDER BY ID DESC"
				If SQLExec(mcon1,lcSQL,"etiquetas1") <= 0
					Messagebox("ERROR AL BUSCAR ETIQUETAS",16,"ERROR")
					Return .F.
				Endif

				Select *, Cast("" As Char(250)) As ImagenDat1 From etiquetas1 Order By Id Into Cursor etiquetas Readwrite
				Use In Select("etiquetas1")

				Set Procedure To FoxBarcodeQR.prg Additive
				Local loFbc
				loFbc = Createobject("FoxBarcodeQR")

				Select etiquetas
				Scan All
					lcText = Transform( Int( mxambito ) ) + "|" + Alltrim(etiquetas.ZET_Pacientes)+ "|" + Alltrim(Transform(etiquetas.ZET_Numero))+ "|" + Alltrim(Transform(etiquetas.ZET_Verif))
					lcFile = loFbc.QRBarcodeImage(lcText,, 6,1)

					Select etiquetas
					Replace ImagenDat1 With lcFile

					Select etiquetas
				Endscan
			Endif
*!*	 FIN GUS 2019-08-20

			Select etiquetas
			If .optvista = 2 And This.lmetiqueta <> This.cpredeter

				Set Printer To Name ( .lmetiqueta )
				mp = Getprinter()
				Label Form etiadm03 To Printer Prompt

			Else

* lcLabel = "etiadm01"
				lcLabel = "etiadm01qr_bis" 			&&  Clone el label por que hacia refrncia directa al forulario
				If mwkEti01.Estado = 1
* lcLabel = "etiadm01QR"
					lcLabel = "etiadm01qr_bis"
				Endif

*Set Printer On
				If prg_modo_exe()
					Set Printer To Name (.Lmprinter)
					mp = Getprinter()
					Label Form ( lcLabel ) To Printer Prompt
				Else
					Label Form ( lcLabel ) Preview
				Endif
			Endif
		Endif

		If Used('etiquetas')
			Use In etiquetas
		Endif

*!*	            If Messagebox('IMPRIME LA PULSERA DE ID. DEL PACIENTE ?', 4+32+0 ,'IDENTIFICACION') = 6

*!*	               Do sp_actualizo_TabIntFPA With 1,0,mwklista.pac_codadmision,0,mwkfecserv.fechahora ,mwkusuario.idusuario , mwkfecserv.fechahora
*!*	               mlsector = "(ADMINT)"

*!*	               mpasoadmi = 0
*!*	               If !Used("mwkadmi")
*!*	                  mpasoadmi = 1
*!*	                  Do sp_busco_admision With .oAbc.mcon1
*!*	               Endif

*!*	               If Used("mwkadmi")

*!*	                  mvalsector = Alltrim(mwkadmi.pac_sectorinternac)
*!*	                  mcledad    = Int(Val( .oAbc.mespe))

*!*	                  Do Case
*!*	                     Case mvalsector = "NNT"
*!*	                        mlsector = "(ADMINTNEO)"

*!*	                     Case mvalsector = "NUR"
*!*	                        mlsector = "(ADMINTNEO)"

*!*	                     Case mvalsector = "TEP"
*!*	                        mlsector = "(ADMINTPED)"

*!*	                     Case mvalsector = "PED"
*!*	                        mlsector = "(ADMINTPED)"

*!*	                     Otherwise
*!*	                        mlsector = "(ADMINT)"
*!*	                  Endcase

*!*	               Endif

*!*	               mcledad = Int(Val(.oAbc.mespe))

*!*	               If mlsector = "(ADMINTNEO)"
*!*	                  Messagebox("LA PULSERA SE IMPRIMIRA EN LA IMPRESORA DE RED NEO",48,"RECUERDE")
*!*	               Endif

*!*	               If mpasoadmi = 1
*!*	                  Use In Select("mwkadmi")
*!*	               Endif

*!*	               Define Window winPrint From 0, 0 To 1, 1
*!*	               Activate Window winPrint In Screen

*!*	               mNomb   = .oAbc.mpaci
*!*	               mNacio  = .oAbc.mespe
*!*	               mCober  = .oAbc.menti
*!*	               mDocu   = .oAbc.mhcli
*!*	               mAdm    = .oAbc.mcon1
*!*	               mSexo   = .oAbc.mcent

*!*	               Do sp_pac_pulsera With mNomb, mNacio, mCober, mDocu, mAdm, mSexo, "", "", mlsector

*!*	               Release Windows winPrint


	Endwith

	Endproc

***************************************************************************************************
*  Procedure : Unload
***************************************************************************************************
*  Parameters  :
*  Description :   cierro tabla usada para las etiquetas
***************************************************************************************************
*

	Procedure Unload()
	Use In Select("mwkEti01")
	If lmeconecto
		Do sp_desconexion
	Endif
	Erase lmeconecto
	Endproc

Enddefine
