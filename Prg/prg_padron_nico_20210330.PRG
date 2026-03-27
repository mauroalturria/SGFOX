Parameters loForm, tbReturn

*!*         CASE i = 100529
*!*         SET DEFAULT TO "e:\disco c\pad\prepaga\140815\"
*!*         mentidadagrupadora = 100
*!*         mfechaproceso = CTOD('15/08/2014')
*!*         mfechatope = CTOD('01/01/2100')
*!*         mconcepto = "Pago 2014-08-15"
*!*         mfecdesde = CTOD('01/08/2014')
*!*         mfechasta = CTOD('01/01/2100')



*	mcon1= SQLConnect('conec01','_system','sys')
	i = 100628
	
    mentidadagrupadora = loForm.cboentidad.Value
    mfechaproceso = loForm.txtProc.Value && CTOD('15/08/2014')
    mfechatope = loForm.txtTop.Value && CTOD('01/01/2100')
    mconcepto = loForm.txtconcepto.Value && "Pago 2014-08-15"
    mfecdesde = loForm.txtdesde.Value && CTOD('01/08/2014')
    mfechasta = loForm.txthasta.Value && CTOD('01/01/2100')


	mDir = Addbs(Alltrim(loForm.edtDir.Value))

	Set Date French
	Set Century On
	Set Talk Off

	Set Step On
*mcon1= SQLCONNECT('Conexion a Desarrollo','_system','sys')
*mcon1= SQLConnect('conec01','_system','sys')


	

	DO Case 
	Case mentidadagrupadora = 100
			
			Use In Select("padronAux")
			Select 0
			Use (mDir + "Pad.Dbf") Alias padronAux
			
			lcBus = "Instituto de Previ"
			lnLen = Len(lcBus)
			
			*!* 08/01/2016 11:53:48  - Gustavo Fittipaldi
 			Select * From padronAux Where Left(Alltrim(grupo__cor),lnLen) <> lcBus Into Cursor padron Readwrite 
			
			
			Set Filter To Left(Alltrim(grupo__cor),lnLen) <> lcBus 
			Go Top
			mbaseok = .T.
			
	Case mentidadagrupadora = 711
			lcBus = "Instituto de Previ"
			lnLen = Len(lcBus)
			
			Use In Select("padronAux")
			Select 0
			Use (mDir + "Pad.Dbf") Alias padronAux

			*!* 08/01/2016 11:53:48  - Gustavo Fittipaldi
 			Select * From padronAux Where Left(Alltrim(grupo__cor),lnLen) = lcBus Into Cursor padron Readwrite 

			Set Filter To Left(Alltrim(grupo__cor),lnLen) = lcBus
			Go Top
			mbaseok = .T.
	
	Case mentidadagrupadora = 948
			
			Use In Select("padronAux")
			
			Select 0
			Use (mDir + "gastro") Alias padronAux
			
			Select * From padronAux Into Cursor padron Readwrite 

			Select padron 
			Append From (mDir + "gasmba.DBF")
			If File(mDir + "gastro_act.dbf")
				Append From (mDir + "gastro_act.dBF")
			Endif
			If File(mDir + "gasmba_act.dbf")
				Append From (mDir + "gasmba_act.DBF")
			Endif
			Select padron
			Go Top
			mbaseok = .T.
	
	Case mentidadagrupadora = 982
			Use In Select("padron")
			Select 0
			Use (mDir + "ospcra") Alias padron

	Otherwise
		Return .f.

	Endcase 
	
		Select padron
		lnCant = Reccount()
		Go top
		
		loForm.txtreg.Value = lnCant
		loForm.txtnproc.Value = 0
		
		If tbReturn
			Return .t.
		Endif 	
		
		
		&& 
		
		
		Set Step On
		
		
		
		If mentidadagrupadora = 948
		
		
			mret = SQLExec(mcon1, "select Id, Documento from PadCabe where entidad=?mentidadagrupadora and fecegreso =?mfechatope","mwkPad01")
			If mret < 0
				Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
				Susp
			Endif
			
			Select * ;
				From mwkPad01 ;
				Where Documento Not in (Select Val(Documento) From padron) ;
				Into Cursor mwkBaja 
				
			Select mwkBaja
			Scan All
			
					mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechaproceso " + ;
						"where ID = ?mwkBaja.ID ")
					If mret < 0
						Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
						Susp
					Endif

					mret = SQLExec(mcon1, "Update PadVigencia set fechahasta =?mfechaproceso " + ;
						"where IdPadCabe = ?mwkBaja.ID and fechahasta =?mfechatope")
					If mret < 0
						Messagebox("ERROR de Escritura padvigencia fechahasta, Reintente", 48, "Validacion")
						Susp
					Endif
			
				Select mwkBaja
			Endscan 
				
			
			
					
		
		Else


			mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechaproceso " + ;
				"where entidad=?mentidadagrupadora and fecegreso =?mfechatope")
			If mret < 0
				Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
				Susp
			Endif

			mret = SQLExec(mcon1, "Update PadVigencia set fechahasta =?mfechaproceso " + ;
				"where IdPadCabe->entidad=?mentidadagrupadora and fechahasta =?mfechatope")
			If mret < 0
				Messagebox("ERROR de Escritura padvigencia fechahasta, Reintente", 48, "Validacion")
				Susp
			Endif
		
		Endif 
		
		Select padron

		Do While !Eof()

			loForm.txtnproc.Value = Recno("padron")

			Do Case
			Case mentidadagrupadora = 948
				mnroaso=Val(padron->cuil+padron->parentesco)
				mgrupofamiliar=Val(padron->cuil)
			Case mentidadagrupadora = 988
				mnroaso=Val(Alltrim(padron->nroafil)+padron->parentesco)
				mgrupofamiliar=Val(Alltrim(padron->nroafil))
			Case mentidadagrupadora = 904
				mnroaso=Val(padron->documento)
				mgrupofamiliar=Val(Alltrim(padron->nroafil))
			Case mentidadagrupadora = 964
				mnroaso=Val(padron->cuil)
				mgrupofamiliar=Val(Alltrim(padron->nroafil))
			Case mentidadagrupadora = 100 Or mentidadagrupadora = 711
				If mentidadagrupadora = 100 Or mentidadagrupadora = 711
					mnroaso=Val(Substr(padron->afiliado,1,7)+Substr(padron->afiliado,9,5))
					mgrupofamiliar=Val(Substr(padron->afiliado,1,7))
				Else
					mnroaso= Val(Substr(codigo_alt,1,At("/",codigo_alt)-1)+Substr(codigo_alt,At("/",codigo_alt)+1))
					mgrupofamiliar= Val(Substr(padron->codigo_alt,1,At("/",padron->codigo_alt)-1))
				Endif
				Do Case
				Case Alltrim(padron->parentesco)=''
					mparentesco='00'
				Case Alltrim(padron->parentesco)='Conyuge'
					mparentesco='01'
				Case Alltrim(padron->parentesco)='Hijo'
					mparentesco='02'
				Case Alltrim(padron->parentesco)='Madre'
					mparentesco='50'
				Case Alltrim(padron->parentesco)='Padre'
					mparentesco='51'
				Otherwise
					mparentesco='99'
				Endcase

			Case mentidadagrupadora = 982
				mparentesco = padron->afil_orden
				mnroaso=Val(Alltrim(Str(padron->afil_numer,20,0))+mparentesco)
				mgrupofamiliar=Val(Alltrim(Str(padron->afil_numer,20,0)))
			Otherwise
				mparentesco = padron->parentesco
				If mparentesco = '**'
					mparentesco = '99'
				Endif
				mnroaso=Val(Alltrim(padron->nroafil)+mparentesco)
				mgrupofamiliar=Val(Alltrim(padron->nroafil))
			Endcase
			mplan = 0
			mplanalternativo = ""
			mnroafiliadoalternativo =""
			If mentidadagrupadora <> 100 And mentidadagrupadora <> 711
				If mentidadagrupadora <> 982
					mapellidosolo =""
					mnombresolo=""
					mapellido = Upper(Alltrim(Chrtran(padron->apellido, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
					mtipodocumento = Val(padron->tipodoc)
					If mentidadagrupadora <> 982
						If Val(padron->tipodoc) = 3
							mtipodocumento = 4
						Else
							If Val(padron->tipodoc) = 4
								mtipodocumento = 3
							Endif
						Endif
					Endif
					If Val(padron->tipodoc) > 5
						mtipodocumento = 5
					Endif
					If Val(padron->documento) = 0 And padron->parentesco = '00'
						mdocumento = Val(Alltrim(Substr(padron->cuil,3,8)))
						mtipodocumento = 4
					Else
						mdocumento = Val(Alltrim(padron->documento))
					Endif

					mcuil = Val(padron->cuil)
					mfecnac = Iif(Empty(padron->c_fecnac) Or padron->c_fecnac < Ctod('01/01/1900'),Ctod('01/01/1900'),padron->c_fecnac)
					msexo = Alltrim(Iif(padron->sexo,'M','F'))
				Else
&& es 982
					mapellidosolo = Upper(Alltrim(Chrtran(padron->apellido, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
					mnombresolo= Upper(Alltrim(Chrtran(padron->nombre, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
					mapellido = mapellidosolo+" "+mnombresolo

					mtipodocumento =  5

					Do Case
					Case Alltrim(padron->tdoc) = 'D.N.I'
						mtipodocumento = 4
					Case Alltrim(padron->tdoc) = 'Cédula de Identid'
						mtipodocumento = 3
					Case Alltrim(padron->tdoc) = 'Libreta Cívica'
						mtipodocumento = 2
					Case Alltrim(padron->tdoc) = 'Libreta de Enrola'
						mtipodocumento = 1
					Endcase
					mdocumento = padron->Doc
					mcuil = 0
					mfecnac = Ctod(padron->fecnac)
					mfecnac = Iif(Empty(mfecnac) Or mfecnac < Ctod('01/01/1900'),Ctod('01/01/1900'),mfecnac)
					msexo = Alltrim(padron->sexo)
				Endif
				mfecingreso = mfechaproceso
			Else
&& es 100 o 512
				mapellidosolo = Upper(Alltrim(Chrtran(padron->apellidos, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
				mnombresolo= Upper(Alltrim(Chrtran(padron->nombres, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
				mapellido = mapellidosolo+' '+mnombresolo
				mtipodocumento =  8

				Do Case
				Case padron->tipo = 'DNI'
					mtipodocumento = 4
				Case padron->tipo = 'CI '
					mtipodocumento = 3
				Case padron->tipo = 'LC '
					mtipodocumento = 2
				Case padron->tipo = 'LE '
					mtipodocumento = 1
				Case padron->tipo = 'PSP'
					mtipodocumento = 5
				Case padron->tipo = 'OT.'
					mtipodocumento = 8
				Endcase

				If (padron->documento) = 0
					mdocumento = Val(Alltrim(Substr(padron->cuit,4,8)))
					mtipodocumento = 4
				Else
					mdocumento = padron->documento
				Endif

				mcuil = Val(Substr(padron->cuit,1,2)+Substr(padron->cuit,4,8)+Substr(padron->cuit,13,1))
				mfecingreso = mfechaproceso
				mfecha_naci = Ctod(Substr(padron->fecha_naci,9,2)+'/'+Substr(padron->fecha_naci,6,2)+'/'+Substr(padron->fecha_naci,1,4))
				mfecnac = Iif(Empty(mfecha_naci) Or mfecha_naci < Ctod('01/01/1900'),Ctod('01/01/1900'),mfecha_naci)
				msexo = Alltrim(padron->sexo)
				mplan = 0
				Do Case
				Case Alltrim(padron->plan) == 'T-N'
					mplan = 1
				Case Alltrim(padron->plan) == 'I'
					mplan = 2
				Case Alltrim(padron->plan) == 'S-N'
					mplan = 3
				Case Alltrim(padron->plan) == 'R'
					mplan = 4
				Case Alltrim(padron->plan) == 'E-N'
					mplan = 5
				Case Alltrim(padron->plan) == 'M-N'
					mplan = 6
				Case Alltrim(padron->plan) == 'ASG-N'
					mplan = 7
				Case Alltrim(padron->plan) == 'RN-N'
					mplan = 8
				Case Alltrim(padron->plan) == 'PMI'
					mplan = 9
				Case Alltrim(padron->plan) == 'TH-N'
					mplan = 10
				Case Alltrim(padron->plan) == 'IH-N'
					mplan = 11
				Case Alltrim(padron->plan) == 'SH-N'
					mplan = 12
				Case Alltrim(padron->plan) == 'PS-N'
					mplan = 13
				Case Alltrim(padron->plan) == 'RC'
					mplan = 14
				Case Alltrim(padron->plan) == 'RH'
					mplan = 15
				Case Alltrim(padron->plan) == 'U'
					mplan = 16
				Case Alltrim(padron->plan) == 'J'
					mplan = 17
				Case Alltrim(padron->plan) == 'I-N'
					mplan = 18
				Case Alltrim(padron->plan) == 'EST'
					mplan = 19
				Case Val(Alltrim(padron->plan)) >= 100 And Val(Alltrim(padron->plan)) <= 199
					mplan = 20
				Case Val(Alltrim(padron->plan)) >= 200 And Val(Alltrim(padron->plan)) <= 299
					mplan = 21
				Case Val(Alltrim(padron->plan)) >= 300 And Val(Alltrim(padron->plan)) <= 399
					mplan = 22
				Case Val(Alltrim(padron->plan)) >= 400 And Val(Alltrim(padron->plan)) <= 499
					mplan = 25
				Case Alltrim(padron->plan) == 'ITER'
					mplan = 23
				Case Alltrim(padron->plan) == 'E 500'
					mplan = 24
				Case Alltrim(padron->plan) == 'SG1.0' Or Alltrim(padron->plan) == 'SG1.0D'
					mplan = 118
				Case Alltrim(padron->plan) == 'SG2.0'
					mplan = 119
				Case Alltrim(padron->plan) == 'H3.0'
					mplan = 120
				Endcase
				If i <= 100103
					If !Empty(Alltrim(padron->grupo_corp))
						mplanalternativo = Alltrim(padron->grupo_corp)
					Endif
				Else
					If !Empty(Alltrim(padron->grupo__cor))
						mplanalternativo = Alltrim(padron->grupo__cor)
					Endif
				Endif
				If !Empty(Alltrim(padron->codigo_alt))
					If mentidadagrupadora = 100 Or mentidadagrupadora = 711
						mnroafiliadoalternativo =  Alltrim(padron->codigo_alt)
					Else
						mnroafiliadoalternativo =  Alltrim(padron->afiliado)
					Endif
				Endif
			Endif
			mdomicilio = Alltrim(Upper(padron->domicilio))
			mlocalidad = Alltrim(Upper(padron->localidad))
			mtelefono = Alltrim(padron->telefono)

			If mentidadagrupadora <> 100 And mentidadagrupadora <> 711
				mcodigopostal = padron->cp
				mprovincia = Alltrim(Upper(padron->provincia))
			Else
				If Type("padron->codigo_pos")="C"
					mcodigopostal = Alltrim(padron->codigo_pos)
				Else
					mcodigopostal = Str(padron->codigo_pos,4,0)
				Endif
				mprovincia = ' '
			Endif

			mret = SQLExec(mcon1," select id,apeynom,cuil,documento,entidad, " + ;
				"fecegreso, fecingreso, fecnac, nroafiliado, sexo, tipodocumento,grupofamiliar, plan " + ;
				"from PadCabe where entidad=?mentidadagrupadora and nroafiliado = ?mnroaso","mwkpadcabe")
			If mret < 0
				Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				Select padron
				? Recno()
				Susp
			Endif

			Select mwkpadcabe
			If Eof()
				If insertarpadcabe()
					mret = SQLExec(mcon1," select id from PadCabe where entidad=?mentidadagrupadora and nroafiliado = ?mnroaso","mwkpadcabe")
					If mret < 0
						Messagebox("ERROR de LECTURA LUEGO DE GRABAR , Reintente", 48, "Validacion")
						Select padron
						? Recno()
						Susp
					Endif
					Select mwkpadcabe
					If !Eof()
						midpadcabe = mwkpadcabe->Id
						mret = SQLExec(mcon1," select id from PadDomicilio where  idpadcabe = ?midpadcabe","mwkpaddomicilio")
						If mret < 0
							Messagebox("ERROR de LECTURA EN PADDOM , Reintente", 48, "Validacion")
							Select padron
							? Recno()
							Susp
						Endif
						Select mwkpaddomicilio
						If Eof()
							insertardomicilio()
							insertarvigencia()
							insertarpago()
							insertardocumento()
							insertarotrosdatos()
						Else
							Messagebox("ERROR de Domicilio existente EN Afiliado nuevo de PADcabe , Reintente", 48, "Validacion")
						Endif
					Else
						Messagebox("ERROR de LECTURA EN cursor luego de insertar , Reintente", 48, "Validacion")
						Select padron
						? Recno()
						Susp
					Endif
				Endif
			Else
*messagebox("ERROR Afiliado duplicado", 48, "Validacion")
*? "Afilido duplicado",mnroaso,RECNO()
				Select mwkpadcabe
				midpadcabe = mwkpadcabe->Id
				versicambiodatos()
				actualizarvigencia()
				insertarpago()

*!*					If i = 948071
*!*						insertar2otrosdatos()
*!*					Endif
			Endif
			Select padron
			Skip
		Enddo

		Select padron
		Use
				
		Use in Select("mwkPadVigencia")
		Use in Select("mwkPadotr")
		Use in Select("mwkPaddoc")
		Use in Select("mwkPaddom")
		Use in Select("mwkpadcabe")
		Use in Select("PadronAux")		
		
		Messagebox("FIN DEL PROCESO",64,"AVISO DEL SISTEMA !!!")
*		Close Tables
*SQLDisconnect(mcon1)

*!*------------------------------------------------------------------------------------------------------------------------------
Function versicambiodatos
*!*------------------------------------------------------------------------------------------------------------------------------
If mwkpadcabe->fecegreso = mfechaproceso
	mfecingreso = mwkpadcabe->fecingreso
Else
	mfecingreso = mfechaproceso
Endif
mrealizocambios = .F.
If mapellido# Upper(Alltrim(Chrtran(mwkpadcabe->apeynom, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  "))) ;
		or mdocumento#mwkpadcabe->documento ;
		or mtipodocumento#mwkpadcabe->tipodocumento ;
		or mfecnac#mwkpadcabe->fecnac ;
		or msexo#Alltrim(mwkpadcabe->sexo) ;
		or mgrupofamiliar#mwkpadcabe->grupofamiliar ;
		OR mplan#mwkpadcabe->plan
	mrealizocambios = .T.
Endif
If mrealizocambios
** Actualizacion de cambios y manda log lo anterior
** Falta campos que no se usan
	xid = mwkpadcabe->Id
	xapeynom = mwkpadcabe->apeynom
	xcuil = mwkpadcabe->cuil
	xdocumentoprincipal = mwkpadcabe->documento
	xentidadagrupadora = mwkpadcabe->entidad
	xfecegreso = mwkpadcabe->fecegreso
	xfecingreso = mwkpadcabe->fecingreso
	xfecnac = mwkpadcabe->fecnac
	xnroafiliado = mwkpadcabe->nroafiliado
	xsexo = mwkpadcabe->sexo
	xtipodocumento = mwkpadcabe->tipodocumento
	xgrupofamiliar = mwkpadcabe->grupofamiliar
	xplan = mwkpadcabe->plan

	mret = SQLExec(mcon1, "insert into PadCabelog set nroafiliado = ?xnroafiliado, " +;
		"apeynom =?xapeynom,  documento =?xdocumentoprincipal, " +;
		"tipodocumento =?xtipodocumento, cuil =?xcuil," +;
		"entidad = ?xentidadagrupadora, fecingreso = ?xfecingreso," +;
		"fecegreso=?xfecegreso, fecnac =?xfecnac, sexo=?xsexo, idpadcabe=?xid, grupofamiliar=?xgrupofamiliar, plan=?xplan " + ;
		",fechaproceso=?mfechaproceso ")
		
	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
		Select padron
		? Recno()
		Susp
	Endif
	
	mret = SQLExec(mcon1, "Update PadCabe set apeynom =?mapellido, " + ;
		"documento =?mdocumento, tipodocumento =?mtipodocumento, cuil =?mcuil," +;
		"entidad= ?mentidadagrupadora, fecnac =?mfecnac, sexo=?msexo, " + ;
		"fecingreso=?mfecingreso, fecegreso =?mfechatope, grupofamiliar=?mgrupofamiliar, plan=?mplan where id=?midpadcabe ")
	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
	Endif
Else
	mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechatope, fecingreso=?mfecingreso where id=?midpadcabe ")
	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
		Select padron
	Endif
Endif

If mret < 0
	Select padron
	? Recno()
	Susp
Endif

mret = SQLExec(mcon1," select * from PadDomicilio where idpadcabe = ?midpadcabe","mwkpaddom")
If mret < 0
	Messagebox("ERROR de LECTURA EN PADDOM , Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Select mwkpaddom
Do While !Eof()
	If mwkpaddom->fechahasta = mfechatope
*OR mwkpaddom->fechahasta = mfechaproceso
		midpaddom = mwkpaddom->Id
		xdomicilio = mwkpaddom->domicilio
		xlocalidad = mwkpaddom->localidad
		xcodigopostal = mwkpaddom->codigo
		xprovincia = mwkpaddom->provincia
		xtelefono = mwkpaddom->telefono

		If xdomicilio#mdomicilio Or xlocalidad#mlocalidad Or xcodigopostal#mcodigopostal ;
				or xprovincia#mprovincia Or xtelefono#mtelefono

			mret = SQLExec(mcon1, "insert into PadDomicilio set idpadcabe = ?midpadcabe, " + ;
				"domicilio=?mdomicilio, localidad=?mlocalidad, provincia=?mprovincia, " + ;
				"telefono=?mtelefono, codigo=?mcodigopostal, fechadesde =?mfechaproceso, " + ;
				"fechahasta=?mfechatope " )
			If mret < 0
				Messagebox("ERROR de ACTUALIZACION PADDOM, Reintente", 48, "Validacion")
				Select padron
				? Recno()
				Susp
			Endif
** Actualizar domicilio con fecha hasta
			mret = SQLExec(mcon1, "update PadDomicilio set fechahasta=?mfechaproceso where id =?midpaddom")
		Endif
		If mret < 0
			Messagebox("ERROR de ACTUALIZACION PADDOM, Reintente", 48, "Validacion")
			Select padron
			? Recno()
			Susp
		Endif
	Endif
	Select mwkpaddom
	Skip
Enddo
***--> Documento
mret = SQLExec(mcon1," select * from PadDocumentos where idpadcabe = ?midpadcabe","mwkpaddoc")
If mret < 0
	Messagebox("ERROR de LECTURA EN PADDOC , Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Select mwkpaddoc
Do While !Eof()
	If mwkpaddoc->fechahasta = mfechatope
*OR mwkpaddom->fechahasta = mfechaproceso
		midpaddoc = mwkpaddoc->Id
		xtipodocumento = mwkpaddoc->tipodocumento
		xdocumento = mwkpaddoc->documento
		If xdocumento#mdocumento Or xtipodocumento#mtipodocumento
			insertardocumento()
** Actualizar domicilio con fecha hasta
			mret = SQLExec(mcon1, "update PadDocumentos set fechahasta=?mfechaproceso where id =?midpaddoc")
		Endif
		If mret < 0
			Messagebox("ERROR de ACTUALIZACION PADDOC, Reintente", 48, "Validacion")
			Select padron
			? Recno()
			Susp
		Endif
	Endif
	Select mwkpaddoc
	Skip
Enddo
***--> Otros Datos EMERGENCIA
If Type('padron->emergencia') <> 'U'
	mcampo = "EMERGENCIA"
	mcontenido = Alltrim(padron->emergencia)
	mret = SQLExec(mcon1," select * from PadOtrosDatos where idpadcabe = ?midpadcabe","mwkpadotr")
	If mret < 0
		Messagebox("ERROR de LECTURA EN PADOTROSDATOS , Reintente", 48, "Validacion")
		Select padron
		? Recno()
		Susp
	Endif
	Select mwkpadotr
	Do While !Eof()
		If mwkpadotr->campo = "EMERGENCIA"
			If mwkpadotr->fechahasta = mfechatope
				midpadotr = mwkpadotr->Id
				xcontenido = Alltrim(mwkpadotr->contenido)
				If xcontenido#mcontenido
					insertarotrosdatos()
					mret = SQLExec(mcon1, "update PadOtrosDatos set fechahasta=?mfechaproceso where id =?midpadotr")
				Endif
				If mret < 0
					Messagebox("ERROR de ACTUALIZACION PADOTROSDATOS, Reintente", 48, "Validacion")
					Select padron
					? Recno()
					Susp
				Endif
			Endif
		Endif
		Select mwkpadotr
		Skip
	Enddo

Else
	mret = 0
Endif
***--> Otros Datos SECCIONAL
If Type('padron->seccional') <> 'U'
	mcampo = "SECCIONAL"
	mcontenido = Alltrim(padron->seccional)
	mret = SQLExec(mcon1," select * from PadOtrosDatos where idpadcabe = ?midpadcabe","mwkpadotr")
	If mret < 0
		Messagebox("ERROR de LECTURA EN PADOTROSDATOS , Reintente", 48, "Validacion")
		Select padron
		? Recno()
		Susp
	Endif
	Select mwkpadotr
	Do While !Eof()
		If mwkpadotr->campo = "SECCIONAL"
			If mwkpadotr->fechahasta = mfechatope
				midpadotr = mwkpadotr->Id
				xcontenido = Alltrim(mwkpadotr->contenido)
				If xcontenido#mcontenido
					insertarotrosdatos()
					mret = SQLExec(mcon1, "update PadOtrosDatos set fechahasta=?mfechaproceso where id =?midpadotr")
				Endif
				If mret < 0
					Messagebox("ERROR de ACTUALIZACION PADOTROSDATOS, Reintente", 48, "Validacion")
					Select padron
					? Recno()
					Susp
				Endif
			Endif
		Endif
		Select mwkpadotr
		Skip
	Enddo

Else
	mret = 0
Endif
Return .T.
*!*------------------------------------------------------------------------------------------------------------------------------
Function actualizarvigencia
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1," select * from Padvigencia where idpadcabe = ?midpadcabe","mwkpadvigencia")

If mret < 0
	Messagebox("ERROR de LECTURA EN PADVigencia , Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Select mwkpadvigencia
If !Eof()
	maccionupdate = .F.
	Do While !Eof()
		If mwkpadvigencia->fechahasta = mfechatope Or mwkpadvigencia->fechahasta = mfechaproceso
			midpadvigencia = mwkpadvigencia->Id
			maccionupdate = .T.
			Exit
		Endif
		Select mwkpadvigencia
		Skip
	Enddo
** Accion
	If maccionupdate
		mret = SQLExec(mcon1, "update Padvigencia set fechahasta=?mfechatope where id =?midpadvigencia")
		If mret < 0
			Messagebox("ERROR de Actualizacion EN PADVigencia , Reintente", 48, "Validacion")
			Select padron
			? Recno()
			Susp
		Endif
	Else
		insertarvigencia()
	Endif
Else
** Vigencia nueva??
*uspend
	insertarvigencia()
Endif

Return .T.
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertarpago
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
mret = SQLExec(mcon1, "insert into Padpagos set idpadcabe = ?midpadcabe, " + ;
	"concepto=?mconcepto, fechadesde=?mfecdesde, fechahasta=?mfechasta ")
If mret < 0
	Messagebox("ERROR de ESCRITURA PADPAGOS, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Return Iif(mret<0,.F.,.T.)
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertardocumento
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
mret = SQLExec(mcon1, "insert into Paddocumentos set idpadcabe = ?midpadcabe, " + ;
	" tipodocumento=?mtipodocumento, documento=?mdocumento, fechadesde =?mfechaproceso, " + ;
	"fechahasta=?mfechasta " )
If mret < 0
	Messagebox("ERROR de ESCRITURA PADDOCUMENTOS, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif

Return Iif(mret<0,.F.,.T.)
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertarotrosdatos
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
** Ciclar por cada dato no ingresado
If Type('padron->obrasoc') <> 'U'
	mcampo = "OBRASOC"
	mcontenido = padron->obrasoc
	mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
		" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	If mret < 0
		Messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
		mresultado =.F.
		Select padron
		? Recno()
		Susp
	Endif
Else
	mret = 0
Endif
If Type('padron->emergencia') <> 'U'
	mcampo = "EMERGENCIA"
	mcontenido = padron->emergencia
	mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
		" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	If mret < 0
		Messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
		mresultado =.F.
		Select padron
		? Recno()
		Susp
	Endif
Else
	mret = 0
Endif

If Type('padron->seccional') <> 'U'
	mcampo = "SECCIONAL"
	mcontenido = padron->seccional
	mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
		" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	If mret < 0
		Messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
		mresultado =.F.
		Select padron
		? Recno()
		Susp
	Endif
Else
	mret = 0
Endif

If Type('padron->Af') <> 'U'
	mcampo = "Af"
	mcontenido = padron->Af
	mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
		" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	If mret < 0
		Messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
		mresultado =.F.
		Select padron
		? Recno()
		Susp
	Endif
Else
	mret = 0
Endif


Return Iif(mret<0,.F.,.T.)
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertar2otrosdatos
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
If Type('padron->seccional') <> 'U'
	mcampo = "SECCIONAL"
	mcontenido = padron->seccional
	mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
		" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	If mret < 0
		Messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
		mresultado =.F.
		Select padron
		? Recno()
		Susp
	Endif
Else
	mret = 0
Endif
Return Iif(mret<0,.F.,.T.)
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertardomicilio
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
mret = SQLExec(mcon1, "insert into PadDomicilio set idpadcabe = ?midpadcabe, " + ;
	"domicilio=?mdomicilio, localidad=?mlocalidad, provincia=?mprovincia, " + ;
	"telefono=?mtelefono, codigo=?mcodigopostal, fechadesde =?mfechaproceso, " + ;
	"fechahasta=?mfechatope " )
If mret < 0
	Messagebox("ERROR de ESCRITURA PADDOM, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Return Iif(mret<0,.F.,.T.)
*!*------------------------------------------------------------------------------------------------------------------------------
Function insertarvigencia
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
mret = SQLExec(mcon1, "insert into Padvigencia set idpadcabe = ?midpadcabe, " + ;
	"fechadesde=?mfechaproceso, fechahasta=?mfechatope ")
If mret < 0
	Messagebox("ERROR de ESCRITURA PADVIGENCIAS, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Return Iif(mret<0,.F.,.T.)

*!*------------------------------------------------------------------------------------------------------------------------------
Function insertarpadcabe
*!*------------------------------------------------------------------------------------------------------------------------------
Private mret
mret = SQLExec(mcon1, "insert into PadCabe set nroafiliado = ?mnroaso, " + ;
	"apeynom =?mapellido, documento=?mdocumento, tipodocumento =?mtipodocumento, " + ;
	"cuil =?mcuil, entidad=?mentidadagrupadora, fecingreso = ?mfecingreso," + ;
	"fecegreso=?mfechatope, fecnac =?mfecnac, sexo=?msexo, apellido=?mapellidosolo," + ;
	"nombre=?mnombresolo, grupofamiliar=?mgrupofamiliar, plan=?mplan ," +;
	"planalternativo=?mplanalternativo, nroafiliadoalternativo=?mnroafiliadoalternativo ")
If mret < 0
	Messagebox("ERROR de ESCRITURA PADCABE, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Susp
Endif
Return Iif(mret<0,.F.,.T.)
