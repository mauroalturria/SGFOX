* Marcelo Torres, 28/03/2023
* Se agregó log de actividad sobre la tabla PADCABE.
* GraboControl(midpadcabe,mfecingreso,2,mdocumento)

Parameters loForm, tbReturn

Local cLogPlanes


cLogPlanes = ""

*!*         CASE i = 100529
*!*         SET DEFAULT TO "e:\disco c\pad\prepaga\140815\"
*!*         mentidadagrupadora = 100
*!*         mfechaproceso = CTOD('15/08/2014')
*!*         mfechatope = CTOD('01/01/2100')
*!*         mconcepto = "Pago 2014-08-15"
*!*         mfecdesde = CTOD('01/08/2014')
*!*         mfechasta = CTOD('01/01/2100')

* Marcelo Torres, 11/11/2024
* Nuevas entidades :
* 444	OSTEL - AFILIADOS ACTIVOS
* 650	OSTEL-O.S PERS.TELECOM.ARG.-JUBIL.Y PENSION.
* 712	OSPETELCO- O.S.PERSONAL DE TELECOMUNICACIONES
* 93	FIDEICOMISO DE ADMINST.JUB. TELEFONICOS

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

* Set Step On

*mcon1= SQLCONNECT('Conexion a Desarrollo','_system','sys')
*mcon1= SQLConnect('conec01','_system','sys')
* ---------------------------------
mret = SQLExec(mcon1,"select * from Planes","mwkPlanes")

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE PLANES",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
* ---------------------------------

* Set Step On

Do Case
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

Case mentidadagrupadora = 80

	cFile = Left(mDir,Len(mDir)-1)

	Use In Select("padronAux")

	Select 0
*** Use (mDir + "ospsip") Alias padronAux
*** Para ospsip se selecciona el fichero
	Use (cFile) Alias padronAux

	Select * From padronAux Into Cursor padron Readwrite

	Select padron
	Go Top
	mbaseok = .T.


Case mentidadagrupadora = 982
	Use In Select("padron")
	Select 0
	Use (mDir + "ospcra") Alias padron

Case mentidadagrupadora = 42

* Marcelo Torres, 25/06/2024
* Hay 2 documentos Excel para abrir y recuperar datos
* Crear un solo cursor. Ver estructura.

* Set Step On

	If tbReturn

&&llenamos la primera vez

		CreaEstrucDosuba()

		llenadosuba(mDir)

		If Used("mwkDosuba")
			Select * From mwkDosuba Into Cursor padron Readwrite
		Else
			Messagebox("No se pudieron generar datos, verifique",16,"DOSUBA")
			Return .F.
		Endif

		Use In Select("mwkDosuba")

	Endif

*!*	    Use In Select("padronAux")

*!*		Select 0
*!*		Use (mDir + "gastro") Alias padronAux

*!*		Select * From padronAux Into Cursor padron Readwrite

*!*		Select padron
*!*		Append From (mDir + "gasmba.DBF")
*!*		If File(mDir + "gastro_act.dbf")
*!*			Append From (mDir + "gastro_act.dBF")
*!*		Endif
*!*		If File(mDir + "gasmba_act.dbf")
*!*			Append From (mDir + "gasmba_act.DBF")
*!*		Endif
*!*		Select padron
*!*		Go Top
*!*		mbaseok = .T.

Case Inlist(mentidadagrupadora,444,650,712,93)

	If tbReturn

&&llenamos la primera vez

		CreaEstrucDosuba()  &&Usamos la misma estructura que Dosuba

		llenaTelefonicos(mDir)

		If Used("mwkDosuba")
			Select * From mwkDosuba Into Cursor padron Readwrite
		Else
			Messagebox("No se pudieron generar datos, verifique",16,"TELEFONICOS")
			Return .F.
		Endif

		Use In Select("mwkDosuba")

	Endif

Case mentidadagrupadora = 462

	If tbReturn

&&llenamos la primera vez

		cFile = Left(mDir,Len(mDir)-1)

		CreaEstrucDosuba()  &&Usamos la misma estructura que Dosuba

		llenaOsdeM(cFile)

		If Used("mwkDosuba")
			Select * From mwkDosuba Into Cursor padron Readwrite
		Else
			Messagebox("No se pudieron generar datos, verifique",16,"MUSICOS")
			Return .F.
		Endif

		Use In Select("mwkDosuba")

	Endif

Case Inlist(mentidadagrupadora,162,163)  && CMQS Junín/Gerenciadora de Salud

	*Set Step On

	If tbReturn

		cFile = Left(mDir,Len(mDir)-1)

		CreaEstrucDosuba()  &&Usamos la misma estructura que Dosuba

		llena162_163(cFile)

		If Used("mwkDosuba")
			Select * From mwkDosuba Into Cursor padron Readwrite
		Else
			Messagebox("No se pudieron generar datos, verifique",16,"CMQS Junín/Gerenciadora de Salud")
			Return .F.
		Endif

		Use In Select("mwkDosuba")

	Endif

Otherwise

	Return .F.

Endcase


Select padron
lnCant = Reccount()
Go Top

loForm.txtreg.Value = lnCant
loForm.txtnproc.Value = 0

If tbReturn
	Return .T.
Else
**** lID : Id del registro modificado
**** fecingreso : la fecha de ingreso que grabamos
**** Tarea : 1=alta,2=con cambios, 3=sin cambios
	Create Cursor dbcontrol (lID i, fecingreso D, Tarea N(1), documento C(30))
Endif


&&

* Set Step On



If mentidadagrupadora = 948 Or mentidadagrupadora = 80


	Wait "BUSCANDO DATOS VIGENTES, AGUARDE ..." Window Nowait

	mret = SQLExec(mcon1, "select Id, Documento, NroAfiliado from PadCabe where entidad=?mentidadagrupadora and fecegreso =?mfechatope","mwkPad01")
	If mret < 0
		Messagebox("ERROR de Lectura padcabe fechaegreso, Reintente", 48, "Validacion")
		Susp
	Endif

	Wait "MARCANDO REGISTROS A PROCESAR, AGUARDE ..." Window Nowait
* -------------------------------------------------------------------
*	Select * ;
From mwkPad01 ;
Where documento Not In (Select Val(documento) From padron) ;
Into Cursor mwkBaja

	Select a.Id,b.documento ;
		FROM mwkPad01 As a ;
		LEFT Join padron As b On a.documento = Val(b.documento) And a.nroafiliado = Val(b.cuil+b.parentesco) ;
		where b.documento Is Null ;
		INTO Cursor mwkBaja


*Set Step On
*Return


	Select mwkBaja
	Scan All

		Wait "Pasivando registro para proceso " + Transform(mwkBaja.Id)+ ". Aguarde" Window Nowait

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
* -------------------------------------------------------------------



*!*		mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechaproceso " + ;
*!*			"where entidad=?mentidadagrupadora and fecegreso =?mfechatope")
*!*		If mret < 0
*!*			Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
*!*			Susp
*!*		Endif

*!*		Wait "MARCANDO REGISTROS DE PADVIGENCIA, AGUARDE ... " Window Nowait
*!*		mret = SQLExec(mcon1, "Update PadVigencia set fechahasta =?mfechaproceso " + ;
*!*			"where IdPadCabe->entidad=?mentidadagrupadora and fechahasta =?mfechatope")
*!*		If mret < 0
*!*			Messagebox("ERROR de Escritura padvigencia fechahasta, Reintente", 48, "Validacion")
*!*			Susp
*!*		Endif



*!*		mret = SQLExec(mcon1, "select Id, Documento from PadCabe where entidad=?mentidadagrupadora and fecegreso =?mfechatope","mwkPad01")
*!*		If mret < 0
*!*			Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
*!*			Susp
*!*		Endif

*!*		Select * ;
*!*			From mwkPad01 ;
*!*			Where documento Not In (Select Val(documento) From padron) ;
*!*			Into Cursor mwkBaja

*!*		Select mwkBaja
*!*		Scan All

*!*			Wait "Pasivando registro para proceso " + Transform(mwkBaja.Id)+ ". Aguarde" Window Nowait

*!*			mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechaproceso " + ;
*!*				"where ID = ?mwkBaja.ID ")
*!*			If mret < 0
*!*				Messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
*!*				Susp
*!*			Endif

*!*			mret = SQLExec(mcon1, "Update PadVigencia set fechahasta =?mfechaproceso " + ;
*!*				"where IdPadCabe = ?mwkBaja.ID and fechahasta =?mfechatope")
*!*			If mret < 0
*!*				Messagebox("ERROR de Escritura padvigencia fechahasta, Reintente", 48, "Validacion")
*!*				Susp
*!*			Endif

*!*			Select mwkBaja
*!*		Endscan


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


*Set Step On


Select padron

Do While !Eof("padron")

* Set Step On

	Select padron

	loForm.txtnproc.Value = Recno("padron")
	mtipobeneficiario = ""

	Do Case
	Case mentidadagrupadora = 948 Or mentidadagrupadora = 80
		If(mentidadagrupadora = 948)
			mnroaso=Val(padron->cuil+padron->parentesco)
		Else
*!*				20230113 gus
			mnroaso=Val(Alltrim(padron->cuil)+padron->parentesco)
*!*				mnroaso=Val(Alltrim(padron->nroafil))
		Endif

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

*** SET STEP ON

	If mentidadagrupadora <> 100 And mentidadagrupadora <> 711

		If mentidadagrupadora = 948  && Marcelo Torres, 26/12/2022

			If Upper(Alltrim(padron->Obrasoc)) = "GASTRO"
				mplan = 151
			Endif
			If Upper(Alltrim(padron->Obrasoc)) = "GASMBA"
				mplan = 152
			Endif

			mtipobeneficiario = Alltrim(padron->tipo_afi)  && 11/11/2023 - Marcelo Torres

		Endif  && ------------------------------------------------

		If mentidadagrupadora <> 982
			mapellidosolo =""
			mnombresolo=""
			mapellido = Upper(Alltrim(Chrtran(padron->apellido, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
			mtipodocumento = Val(padron->tipodoc)
			mPmi = ""
			mAntecedente = ""

			If !INLIST(mentidadagrupadora,42,162,163,462)
				mtipodocumento = 0

				Do Case
				Case Inlist(mentidadagrupadora,712,650,93,462)
*                    Dejamos el tipo de documento cargado por defecto (4)

				Case mentidadagrupadora <> 982
					If Val(padron->tipodoc) = 3
						mtipodocumento = 4
					Else
						If Val(padron->tipodoc) = 4
							mtipodocumento = 3
						Endif
					Endif
				Endcase

				If Val(padron->tipodoc) > 5
					mtipodocumento = 5
				Endif
			Else

				If mentidadagrupadora = 42
*                  Tipo de Documento para Dosuba
					mtipodocumento = fGetTipoDocDosuba(Val(padron->tipodoc))
				Endif

			Endif


			If Val(padron->documento) = 0 And padron->parentesco = '00'
				mdocumento = Val(Alltrim(Substr(padron->cuil,3,8)))
				mtipodocumento = 4
			Else
				mdocumento = Val(Alltrim(padron->documento))
*               Marcelo Torres, 12/11/2024
*               Las entidades 444,650,712,93 no traen Tipo de Documento
				If mtipodocumento = 0
					mtipodocumento = 4
				Endif
			Endif

			mcuil = Val(padron->cuil)
			mfecnac = Iif(Empty(padron->c_fecnac) Or padron->c_fecnac < Ctod('01/01/1900'),Ctod('01/01/1900'),padron->c_fecnac)

			Do Case
			Case Inlist(mentidadagrupadora,42,462,162,163)
				msexo = Alltrim(padron->sexo)  && M/F
			Case Inlist(mentidadagrupadora,444,650,712,93)
				msexo = ""
			Otherwise
				msexo = Alltrim(Iif(padron->sexo,'M','F'))
			Endcase
		Else
&& es 982
			mapellidosolo = Upper(Alltrim(Chrtran(padron->apellido, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
			mnombresolo= Upper(Alltrim(Chrtran(padron->nombre, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|[]{}", "###  ")))
			mapellido = mapellidosolo+" "+mnombresolo

			mtipodocumento =  5
			mPmi = ""
			mAntecedente = ""

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
		mPmi = ""
		mAntecedente = ""

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

** SET STEP ON

		mcuil = Val(Substr(padron->cuit,1,2)+Substr(padron->cuit,4,8)+Substr(padron->cuit,13,1))
		mfecingreso = mfechaproceso
		mfecha_naci = Ctod(Substr(padron->fecha_naci,9,2)+'/'+Substr(padron->fecha_naci,6,2)+'/'+Substr(padron->fecha_naci,1,4))
		mfecnac = Iif(Empty(mfecha_naci) Or mfecha_naci < Ctod('01/01/1900'),Ctod('01/01/1900'),mfecha_naci)
		msexo = Alltrim(padron->sexo)
		mplan = 0

		If Inlist(mentidadagrupadora,100,106,711)  &&solo hominis
			mPmi = Alltrim(padron->pmi)
			mAntecedente = Alltrim(padron->antecedent)
		Endif

		cEntAbrevia = Alltrim(padron->plan)

** SET STEP ON

** ----------------- Primero buscar por mwkPlanes.AbreviaEnt
		lPaso = .F.

		Select * From mwkPlanes ;
			WHERE AbreviaEnt = cEntAbrevia ;
			INTO Cursor mwkAbreviaPlan

		Select mwkAbreviaPlan
		If Reccount() > 0
			mplan = Val(Alltrim(mwkAbreviaPlan.Abreviatura))
			lPaso = .T.
		Endif

** ---------------- Si no aparece, buscar por mwkPlanes.DescripEnt
		If !lPaso

			Select * From mwkPlanes ;
				WHERE DescripEnt = cEntAbrevia ;
				INTO Cursor mwkAbreviaPlan

			Select mwkAbreviaPlan
			If Reccount() > 0
				mplan = Val(Alltrim(mwkAbreviaPlan.Abreviatura))
				lPaso = .T.
			Endif

		Endif
** --------------- Si tampoco aparece, buscar por mwkPlanes.Descripcion - Carolina, 06/06/2023
		If !lPaso

			Select * From mwkPlanes ;
				WHERE Descripcion = cEntAbrevia ;
				INTO Cursor mwkAbreviaPlan

			Select mwkAbreviaPlan
			If Reccount() > 0
				mplan = Val(Alltrim(mwkAbreviaPlan.Abreviatura))
				lPaso = .T.
			Endif

		Endif


		If !lPaso
			If !(At(cEntAbrevia ,cLogPlanes ) > 0)
				cLogPlanes = cLogPlanes + cEntAbrevia +","+ Chr(13)
			Endif
		Endif


** ------------------------------------------------------- Esta parte queda fuera de uso. Marcelo Torres, 25/07/2022

*!*					Do Case
*!*					Case Alltrim(padron->plan) == 'T-N'
*!*						mplan = 1
*!*					Case Alltrim(padron->plan) == 'I'
*!*						mplan = 2
*!*					Case Alltrim(padron->plan) == 'S-N'
*!*						mplan = 3
*!*					Case Alltrim(padron->plan) == 'R'
*!*						mplan = 4
*!*					Case Alltrim(padron->plan) == 'E-N'
*!*						mplan = 5
*!*					Case Alltrim(padron->plan) == 'M-N'
*!*						mplan = 6
*!*					Case Alltrim(padron->plan) == 'ASG-N'
*!*						mplan = 7
*!*					Case Alltrim(padron->plan) == 'RN-N'
*!*						mplan = 8
*!*					Case Alltrim(padron->plan) == 'PMI'
*!*						mplan = 9
*!*					Case Alltrim(padron->plan) == 'TH-N'
*!*						mplan = 10
*!*					Case Alltrim(padron->plan) == 'IH-N'
*!*						mplan = 11
*!*					Case Alltrim(padron->plan) == 'SH-N'
*!*						mplan = 12
*!*					Case Alltrim(padron->plan) == 'PS-N'
*!*						mplan = 13
*!*					Case Alltrim(padron->plan) == 'RC'
*!*						mplan = 14
*!*					Case Alltrim(padron->plan) == 'RH'
*!*						mplan = 15
*!*					Case Alltrim(padron->plan) == 'U'
*!*						mplan = 16
*!*					Case Alltrim(padron->plan) == 'J'
*!*						mplan = 17
*!*					Case Alltrim(padron->plan) == 'I-N'
*!*						mplan = 18
*!*					Case Alltrim(padron->plan) == 'EST'
*!*						mplan = 19
*!*					Case Val(Alltrim(padron->plan)) >= 100 And Val(Alltrim(padron->plan)) <= 199
*!*						mplan = 20
*!*					Case Val(Alltrim(padron->plan)) >= 200 And Val(Alltrim(padron->plan)) <= 299
*!*						mplan = 21
*!*					Case Val(Alltrim(padron->plan)) >= 300 And Val(Alltrim(padron->plan)) <= 399
*!*						mplan = 22
*!*					Case Val(Alltrim(padron->plan)) >= 400 And Val(Alltrim(padron->plan)) <= 499
*!*						mplan = 25
*!*					Case Alltrim(padron->plan) == 'ITER'
*!*						mplan = 23
*!*					Case Alltrim(padron->plan) == 'E 500'
*!*						mplan = 24
*!*					Case Alltrim(padron->plan) == 'SG1.0' Or Alltrim(padron->plan) == 'SG1.0D'
*!*						mplan = 118
*!*					Case Alltrim(padron->plan) == 'SG2.0'
*!*						mplan = 119
*!*					Case Alltrim(padron->plan) == 'H3.0'
*!*						mplan = 120
*!*					Endcase
** -------------------------------------------------------

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
		"fecegreso, fecingreso, fecnac, nroafiliado, sexo, tipodocumento,grupofamiliar, plan, pmi, antecedentes, NVL(tipobeneficiario,'') as tipobeneficiario " + ;
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
				Suspend
			Endif
			Select mwkpadcabe
			If !Eof()
				midpadcabe = mwkpadcabe->Id

				GraboControl(midpadcabe,mfecingreso,1,mdocumento)  && Graba log - Marcelo Torres

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

					If mentidadagrupadora <> 42 && Excluimos para Dosuba
						insertarotrosdatos()
					Endif

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


Use In Select("padron")
Use In Select("mwkPadVigencia")
Use In Select("mwkPadotr")
Use In Select("mwkPaddoc")
Use In Select("mwkPaddom")
Use In Select("mwkpadcabe")
Use In Select("PadronAux")
Use In Select("mwkAbreviaPlan")
Use In Select("mwkDocuDosuba")

** ----------------- Escribimos log con Planes que no se encontraron
If Trim(cLogPlanes) <> ""

	cTxtNicolas = "c:\temp\TxtPlanes"+Ttoc(Datetime(),1)+".txt"

	cLogPlanes = "Los siguientes datos no se encontraron en la tabla PLANES : " + Chr(10) + cLogPlanes
	Strtofile(cLogPlanes,cTxtNicolas)

	o = Createobject("Shell.Application")
	o.ShellExecute("notepad.exe", cTxtNicolas, "", "open", 1)

Endif

* Set Step On

** ---------------- Pasar dbcontrol a Excel
cTemp = "c:\temp\controlpadron_"+Dtos(mfechaproceso)+".csv"

Select dbcontrol

Copy To (cTemp) Type Csv

Use In Select("dbcontrol")
** ----------------------------------------

If File(cTemp)
	Messagebox("FIN DEL PROCESO." + Chr(10)+Chr(10) + "Se generó el archivo" + Chr(10)+ cTemp+ Chr(10) + "Para control." ,64,"AVISO DEL SISTEMA !!!")
Else
	Messagebox("FIN DEL PROCESO." + Chr(10) + "No se generó archivo de control." ,64,"AVISO DEL SISTEMA !!!")
Endif

*		Close Tables
*SQLDisconnect(mcon1)



*!*------------------------------------------------------------------------------------------------------------------------------
Function versicambiodatos
*!*------------------------------------------------------------------------------------------------------------------------------

*Set Step On


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
		OR mplan#Nvl(mwkpadcabe->plan,0) ;
		OR mPmi#Alltrim(Nvl(mwkpadcabe->pmi,"")) ;
		OR mAntecedente#Alltrim(Nvl(mwkpadcabe->Antecedentes,"")) ;
		OR mtipobeneficiario#Alltrim(Nvl(mwkpadcabe->tipobeneficiario,""));
		OR mcuil#mwkpadcabe->cuil

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
	xpmi = mwkpadcabe->pmi
	xantecedente = mwkpadcabe->Antecedentes
	xTipoBeneficiario = mwkpadcabe->tipobeneficiario

	mret = SQLExec(mcon1, "insert into PadCabelog set nroafiliado = ?xnroafiliado, " +;
		"apeynom =?xapeynom,  documento =?xdocumentoprincipal, " +;
		"tipodocumento =?xtipodocumento, cuil =?xcuil," +;
		"entidad = ?xentidadagrupadora, fecingreso = ?xfecingreso," +;
		"fecegreso=?xfecegreso, fecnac =?xfecnac, sexo=?xsexo, idpadcabe=?xid, grupofamiliar=?xgrupofamiliar, plan=?xplan " + ;
		",fechaproceso=?mfechaproceso,pmi = ?xpmi, antecedentes = ?xAntecedente, tipobeneficiario = ?xTipoBeneficiario ")

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
		"fecingreso=?mfecingreso, fecegreso =?mfechatope, grupofamiliar=?mgrupofamiliar," +;
		"plan=?mplan ,pmi = ?mpmi,antecedentes = ?mAntecedente, tipobeneficiario = ?mTipoBeneficiario " +;
		"where id=?midpadcabe ")
	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
	Else
		GraboControl(midpadcabe,mfecingreso,2,mdocumento)
	Endif

Else
	mret = SQLExec(mcon1, "Update PadCabe set fecegreso =?mfechatope, fecingreso=?mfecingreso where id=?midpadcabe ")
	If mret<1
		=Aerr(eros)
		Messagebox(eros(3))
		Select padron
	Else
		GraboControl(midpadcabe,mfecingreso,3,mdocumento)
	Endif
Endif

If mret < 0
	Select padron
	? Recno()
	Susp
Endif

mret = SQLExec(mcon1," select * from PadDomicilio where idpadcabe = ?midpadcabe","mwkpaddom")
If mret < 0
	Select padron
	Messagebox("ERROR de LECTURA EN PADDOM. " + Chr(10) + "Registro PADRON : " + Transform(Recno("Padron")) + Chr(10) +" Reintente", 48, "Validacion")
*Select padron
* ? Recno()
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


* SET STEP ON

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

* Set Step On

***--> Otros Datos AF
If Type('padron->AF') <> 'U'
	mcampo = "AF"
** mcontenido = Alltrim(padron->seccional)
	mcontenido = Alltrim(padron->af)

	mret = SQLExec(mcon1," select * from PadOtrosDatos where idpadcabe = ?midpadcabe and Trim(campo) = 'AF'","mwkpadotr")
	If mret < 0
		Messagebox("ERROR de LECTURA EN PADOTROSDATOS , Reintente", 48, "Validacion")
		Select padron
		? Recno()
		Susp
	Endif
	If Reccount("mwkpadotr")> 0

		Select mwkpadotr
		Do While !Eof()
			If mwkpadotr->campo = "AF"
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

		mcampo = "AF"
		mcontenido = padron->af
		mret = SQLExec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
			" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
			"fechahasta=?mfechasta " )
	Endif

Else
	mret = 0
Endif

* SET STEP ON

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

* Set Step On

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

* SET STEP ON
* MESSAGEBOX("INSERTA OTROS DATOS")

If Type('padron->obrasoc') <> 'U'
	mcampo = "OBRASOC"
	mcontenido = padron->Obrasoc
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
	mcampo = "AF"
	mcontenido = padron->af
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
Local mAfialt

If mentidadagrupadora = 80
	mAfialt = Transform(mnroaso)
	mAfialt = Left(mAfialt,11)+"/"+Right(mAfialt,2)
Else
	mAfialt = ""
Endif

mret = SQLExec(mcon1, "insert into PadCabe set nroafiliado = ?mnroaso, " + ;
	"apeynom =?mapellido, documento=?mdocumento, tipodocumento =?mtipodocumento, " + ;
	"cuil =?mcuil, entidad=?mentidadagrupadora, fecingreso = ?mfecingreso," + ;
	"fecegreso=?mfechatope, fecnac =?mfecnac, sexo=?msexo, apellido=?mapellidosolo," + ;
	"nombre=?mnombresolo, grupofamiliar=?mgrupofamiliar, plan=?mplan ," +;
	"planalternativo=?mplanalternativo, nroafiliadoalternativo=?mnroafiliadoalternativo," +;
	"pmi = ?mpmi,antecedentes = ?mAntecedente,nroafiliadoalternativo = ?mAfiAlt, " +;
	"tipobeneficiario = ?mTipoBeneficiario ")
If mret < 0
	Messagebox("ERROR de ESCRITURA PADCABE, Reintente", 48, "Validacion")
	Select padron
	? Recno()
	Suspend
Endif

**Use In Select("mwkPlanes")

Return Iif(mret<0,.F.,.T.)


* dbcontrol (lID I, fecingreso D, Tarea n(1))
* Tarea: 1=insert,2=con modificacion, 3=sin modificacion
* ----------------------------------------
Function GraboControl(nID,dFecha,nTarea,ndocumento)

Select dbcontrol
Append Blank

Replace lID With nID
Replace fecingreso With dFecha
Replace Tarea With nTarea
Replace documento With Iif(Vartype(ndocumento) = "C",ndocumento,Alltrim(Str(ndocumento)))

Select padron

Return


* ---------------------------------------------------------
Function CreaEstrucDosuba()

* SET STEP ON

Use In Select("mwkDosuba")

Create Cursor mwkDosuba (cuil C(13), apellido C(50), documento C(20), tipodoc C(1),nroafil C(20),parentesco C(2),;
	localidad C(50), seccional C(25), cp C(10),provincia C(30), domicilio C(30), telefono C(30), clave C(10), ;
	c_idepac C(25),c_fecnac D, sexo C(1), edad C(3), Obrasoc C(10), af C(2), tipo_afi C(25), codent N(10))


Create Cursor mwkDocuDosuba (TipoDosuba N(1),TipoSG N(1), Abrevio C(3), Descrip C(30))

*** Documentos Dosuba
*!*	1 libreta cívica
*!*	2 libreta de enrolamiento
*!*	3 pasaporte
*!*	4 cedula de identidad
*!*	5 DNI

Insert Into mwkDocuDosuba(TipoDosuba, TipoSG, Abrevio, Descrip) Values( ;
	1, 2, 'LC', 'LIB. CIVICA')

Insert Into mwkDocuDosuba(TipoDosuba, TipoSG, Abrevio, Descrip) Values( ;
	2, 1, 'LE', 'LIB. DE ENROLAMIENTO')

Insert Into mwkDocuDosuba(TipoDosuba, TipoSG, Abrevio, Descrip) Values( ;
	3, 5, 'PAS', 'PASAPORTE')

Insert Into mwkDocuDosuba(TipoDosuba, TipoSG, Abrevio, Descrip) Values( ;
	4, 3, 'CI', 'CED. DE IDENTIDAD')

Insert Into mwkDocuDosuba(TipoDosuba, TipoSG, Abrevio, Descrip) Values( ;
	5, 4, 'DNI', 'DOC. UNICO')



Return


* ---------------------------------------------------------
Function llenadosuba(cRuta)

Local aArchivos
Local cExcel
Local oExcel
Local loWorkbook
Local oIn
Local nIn
Local nX
Local nRegistros
Local loSheet
Local cFecNacim
Local cCurrent

cCurrent = Sys(2003)

* Primer Excel abrir excel
Set Default To (cRuta)

Dimension aArchivos(1)

nArchivos = Adir(aArchivos,"*.xlsx")
nRegistros = 0

For nX = 1 To nArchivos

	cExcel = Alltrim(aArchivos(nX,1))

	oExcel = Createobject("Excel.application")
	oExcel.Visible = .F.
	oExcel.DisplayAlerts = .F.
	loWorkbook = oExcel.Workbooks.Open(cRuta+cExcel)
	loSheet = loWorkbook.sheets("Hoja1")

	nRegistros = loSheet.UsedRange.Rows.Count

*oExcel.Range("A1").Select
*lcSalida = Addbs(Getenv("TEMP")) + "Salida"
*oExcel.ActiveWorkbook.SaveAs(lcSalida, 6)  &&graba en csv

	For nIn = 2 To nRegistros

		Wait "Leyendo registro " + Transform(nIn)+" del EXCEL, Aguarde ... " Window Nowait

		cFecNacim = Alltrim(Transform(Round(loSheet.cells(nIn,09).Value,0)))
		cFecNacim = Right(cFecNacim,2)+"-"+Substr(cFecNacim,5,2)+"-"+Left(cFecNacim,4)
		cAfiliado = Alltrim(Transform(Nvl(loSheet.cells(nIn,05).Value,0)))
		cAfiliado = Left(cAfiliado,Len(cAfiliado)-2)

		Select mwkDosuba
		Append Blank

*		loSheet.cells(nIn,01).Value
		Replace cuil With  ""
		Replace apellido With Alltrim(loSheet.cells(nIn,06).Value)+" "+ Alltrim(loSheet.cells(nIn,07).Value)
		Replace documento With Alltrim(Transform(Nvl(loSheet.cells(nIn,11).Value,0)))
		Replace tipodoc With Alltrim(Transform(Nvl(loSheet.cells(nIn,10).Value,0)))
		Replace nroafil With cAfiliado
		Replace parentesco With Right(Alltrim(Transform(Nvl(loSheet.cells(nIn,05).Value,0))),2)
		If Vartype(Nvl(loSheet.cells(nIn,15).Value,"")) = "C"
			Replace localidad With Alltrim(Nvl(loSheet.cells(nIn,15).Value,""))
		Else
			Replace localidad With 'CIUDAD AUTONOMA DE BUENOS AIRES'
		Endif
		Replace seccional With ""
		Replace cp With Transform(Nvl(loSheet.cells(nIn,14).Value,0))
		Replace provincia With ""
		Replace domicilio With ""
		Replace telefono With ""
		Replace clave With ""
		Replace c_idepac With ""
		Replace c_fecnac With Ctod(cFecNacim)
		Replace sexo With Alltrim(Nvl(loSheet.cells(nIn,08).Value,""))
		Replace edad With ""
		Replace Obrasoc With ""
		Replace af With ""
		Replace tipo_afi With ""

	Next

*oExcel.ActiveWorkbook.Close(0)
	oExcel.Quit()
	oExcel = .F.
	loSheet = .F.
	loWorkbook = .F.

Next

Release oExcel
Release loSheet
Release loWorkbook

Set Default To (cCurrent)

Return


* -------------------------------------------------
Function fGetTipoDocDosuba(nTipoDosuba)

Local nTipoSG

* mwkDocuDosuba (TipoDosuba N(1),TipoSG N(1), Abrevio C(3), Descrip C(30))

Select mwkDocuDosuba
Go Top

Scan All
	If mwkDocuDosuba.TipoDosuba = nTipoDosuba
		nTipoSG = mwkDocuDosuba.TipoSG
		Exit
	Endif
Endscan


Return nTipoSG


* --------------------------------------------------
Procedure llenaTelefonicos(cRuta)

Local aArchivos
Local cExcel
Local oExcel
Local loWorkbook
Local oIn
Local nIn
Local nX
Local nRegistros
Local loSheet
Local cFecNacim
Local cCurrent
Local nEntidad
Local cObraSoc
Local cAfiliado
Local cPariente

cCurrent = Sys(2003)

* Primer Excel abrir excel
Set Default To (cRuta)

Dimension aArchivos(1)

nArchivos = Adir(aArchivos,"*.xlsx")
nRegistros = 0

* Set Step On
* 26/02/2024
* Por ahora son 3 posibles entidades:
* 712 - OSPETELCO
* 650 - OSTEL JUBILADOS
* 93 - FIDEICOMISO - PAMI
* 06/03/2025
* Se agrega OSTEL Activos (entidad 444)

cObraSoc = ""

* SET STEP ON

Do Case
Case mentidadagrupadora = 712
	cObraSoc = "OSPETELCO"
Case mentidadagrupadora = 650
	cObraSoc = "OSTEL JUBILADOS"
Case mentidadagrupadora = 93
	cObraSoc = "FIDEICOMISO"
Case mentidadagrupadora = 444
	cObraSoc = "OSTEL"
Case mentidadagrupadora = 462
	cObraSoc = "OSDEM"
Endcase


For nX = 1 To nArchivos

	cExcel = Alltrim(aArchivos(nX,1))

	oExcel = Createobject("Excel.application")
	oExcel.Visible = .F.
	oExcel.DisplayAlerts = .F.
	loWorkbook = oExcel.Workbooks.Open(cRuta+cExcel)
	loSheet = loWorkbook.sheets("Hoja1")

	nRegistros = loSheet.UsedRange.Rows.Count

*oExcel.Range("A1").Select
*lcSalida = Addbs(Getenv("TEMP")) + "Salida"
*oExcel.ActiveWorkbook.SaveAs(lcSalida, 6)  &&graba en csv

* SET STEP ON

	For nIn = 2 To nRegistros

		Wait "Leyendo registro " + Transform(nIn)+" del EXCEL, Aguarde ... " Window Nowait

*       la columna 1 tiene los datos de la entidad
		If Empty(Alltrim(Nvl(loSheet.cells(nIn,01).Value,"")))
			Exit
		Endif

		cObraSocTemp = Upper(Alltrim(Nvl(loSheet.cells(nIn,01).Value,"")))

		If At(cObraSoc,cObraSocTemp)>0

			Select mwkDosuba && el cursor tiene este nombre, pero los registros son de Ospetelco/Ostel
			Append Blank

			If mentidadagrupadora = 444

				Replace cuil With Alltrim(Transform(loSheet.cells(nIn,06).Value))
*Replace apellido With Alltrim(loSheet.cells(nIn,06).Value)+" "+ Alltrim(loSheet.cells(nIn,07).Value)
				Replace apellido With Alltrim(loSheet.cells(nIn,02).Value)
				Replace documento With Alltrim(Transform(Nvl(loSheet.cells(nIn,3).Value,0)))
				Replace tipodoc With "4"
*Replace tipodoc With Alltrim(Transform(Nvl(loSheet.cells(nIn,2).Value,0)))

				cAfiliado = ""
				cPariente = ""

				cAfiliado = Alltrim(Nvl(loSheet.cells(nIn,5).Value,0))

				npos = At("/",cAfiliado)

				If npos > 0

					nDerecha = Len(cAfiliado)-npos

					cPariente = Right(cAfiliado,nDerecha)
					cAfiliado = Left(cAfiliado,npos-1)

				Endif


				Replace nroafil With cAfiliado
				Replace parentesco With cPariente

				Replace c_fecnac With Ttod(loSheet.cells(nIn,7).Value)
				Replace sexo With Left(Alltrim(Nvl(loSheet.cells(nIn,04).Value,"")),1)
*!*			Replace edad With ""
				Replace Obrasoc With Alltrim(Nvl(loSheet.cells(nIn,01).Value,""))
				Replace codent With mentidadagrupadora

			Else
*		loSheet.cells(nIn,01).Value
				Replace cuil With Alltrim(Transform(loSheet.cells(nIn,07).Value))
*Replace apellido With Alltrim(loSheet.cells(nIn,06).Value)+" "+ Alltrim(loSheet.cells(nIn,07).Value)
				Replace apellido With Alltrim(loSheet.cells(nIn,02).Value)
				Replace documento With Alltrim(Transform(Nvl(loSheet.cells(nIn,3).Value,0)))
				Replace tipodoc With "4"
*Replace tipodoc With Alltrim(Transform(Nvl(loSheet.cells(nIn,2).Value,0)))
				Replace nroafil With Alltrim(Transform(Nvl(loSheet.cells(nIn,5).Value,0)))
				Replace parentesco With Alltrim(Transform(Nvl(loSheet.cells(nIn,6).Value,0)))
				Replace c_fecnac With Ttod(loSheet.cells(nIn,8).Value)
				Replace sexo With Left(Alltrim(Nvl(loSheet.cells(nIn,04).Value,"")),1)
*!*			Replace edad With ""
				Replace Obrasoc With Alltrim(Nvl(loSheet.cells(nIn,01).Value,""))
				Replace codent With mentidadagrupadora
*!*			Replace af With ""
*!*			Replace tipo_afi With ""
			Endif

		Endif

	Next

*oExcel.ActiveWorkbook.Close(0)
	oExcel.Quit()
	oExcel = .F.
	loSheet = .F.
	loWorkbook = .F.

Next

Release oExcel
Release loSheet
Release loWorkbook

Set Default To (cCurrent)

Return


* --------------------------------------------------
Procedure llenaOsdeM(cRuta)  && obra social de musicos

Local aArchivos
Local cExcel
Local oExcel
Local loWorkbook
Local oIn
Local nIn
Local nX
Local nRegistros
Local loSheet
Local cFecNacim
Local cCurrent
Local nEntidad
Local cObraSoc
Local cAfiliado
Local cPariente
Local npos
Local cCuil

*cCurrent = Sys(2003)

* Primer Excel abrir excel
*Set Default To (cRuta)

*Dimension aArchivos(1)

*nArchivos = Adir(aArchivos,"*.xlsx")
*nRegistros = 0

* Set Step On

cObraSoc = ""


*For nX = 1 To nArchivos

*If nArchivos = 0
*	Messagebox("No hay archivos Excel en el directorio.",16,"OsdeM")
*	Return
*Endif

*cExcel = Alltrim(aArchivos(1,1))

oExcel = Createobject("Excel.application")
oExcel.Visible = .F.
oExcel.DisplayAlerts = .F.
loWorkbook = oExcel.Workbooks.Open(cRuta)
loSheet = loWorkbook.sheets(1)

nRegistros = loSheet.UsedRange.Rows.Count


* Set Step On

For nIn = 9 To nRegistros

	Wait "Leyendo registro " + Transform(nIn)+" del EXCEL, Aguarde ... " Window Nowait

*       la columna 1 tiene los datos de la entidad
	If Empty(Nvl(loSheet.cells(nIn,01).Value,""))
		Exit
	Endif


	Select mwkDosuba && el cursor tiene este nombre, pero los registros son de Ospetelco/Ostel
	Append Blank

	cCuil = Alltrim(loSheet.cells(nIn,09).Value)
	cCuil = Strtran(cCuil,"-","")

	Replace cuil With cCuil
*Replace apellido With Alltrim(loSheet.cells(nIn,06).Value)+" "+ Alltrim(loSheet.cells(nIn,07).Value)
	Replace apellido With Alltrim(loSheet.cells(nIn,03).Value)
	Replace documento With Alltrim(Transform(Nvl(loSheet.cells(nIn,8).Value,0)))
	Replace tipodoc With "4"   &&parece que siempre viene documento, aunque sea extranjero.
*Replace tipodoc With Alltrim(Transform(Nvl(loSheet.cells(nIn,2).Value,0)))

	cAfiliado = ""
	cPariente = ""

	cAfiliado = Alltrim(Transform(Nvl(loSheet.cells(nIn,1).Value,0)))

	npos = At("/",cAfiliado)

	If npos > 0

		nDerecha = Len(cAfiliado)-npos

		cPariente = Right(cAfiliado,nDerecha)
		cAfiliado = Left(cAfiliado,npos-1)

	Endif

	Replace nroafil With cAfiliado
	Replace parentesco With cPariente

	Replace c_fecnac With Ttod(loSheet.cells(nIn,4).Value)
	Replace sexo With Alltrim(Nvl(loSheet.cells(nIn,06).Value,""))
*!*			Replace edad With ""
	Replace Obrasoc With ""  &&Alltrim(Nvl(loSheet.cells(nIn,01).Value,""))
	Replace codent With mentidadagrupadora
	Replace tipo_afi With ""

Next

*oExcel.ActiveWorkbook.Close(0)
oExcel.Quit()
oExcel = .F.
loSheet = .F.
loWorkbook = .F.

*Next

Release oExcel
Release loSheet
Release loWorkbook

*Set Default To (cCurrent)

Return


* ---------------------------------------
Procedure llena162_163(cRuta)

Local aArchivos
Local cExcel
Local oExcel
Local loWorkbook
Local oIn
Local nIn
Local nX
Local nRegistros
Local loSheet
Local cFecNacim
Local cCurrent
Local nEntidad
Local cObraSoc
Local cAfiliado
Local cPariente
Local npos
Local cCuil

*cCurrent = Sys(2003)

* Primer Excel abrir excel
*Set Default To (cRuta)

*Dimension aArchivos(1)

*nArchivos = Adir(aArchivos,"*.xlsx")
nRegistros = 0

* Set Step On

cObraSoc = ""


*For nX = 1 To nArchivos

*If nArchivos = 0
*	Messagebox("No hay archivos Excel en el directorio.",16,"Junin")
*	Return
*Endif

*Set Step On

oExcel = Createobject("Excel.application")
oExcel.Visible = .F.
oExcel.DisplayAlerts = .F.
loWorkbook = oExcel.Workbooks.Open(cRuta)
loSheet = loWorkbook.sheets(1)

nRegistros = loSheet.UsedRange.Rows.Count


* Set Step On

For nIn = 2 To nRegistros

	Wait "Leyendo registro " + Transform(nIn)+" del EXCEL, Aguarde ... " Window Nowait

*       la columna 1 tiene los datos de la entidad
	If Empty(Nvl(loSheet.cells(nIn,01).Value,""))
		Exit
	Endif


	Select mwkDosuba && el cursor tiene este nombre, pero los registros son de Ospetelco/Ostel
	Append Blank

	Replace apellido With Alltrim(loSheet.cells(nIn,03).Value)+" "+ Alltrim(loSheet.cells(nIn,04).Value)
	Replace documento With Alltrim(Transform(Nvl(loSheet.cells(nIn,9).Value,0)))
	Replace tipodoc With "4"   &&parece que siempre viene documento DU

	cAfiliado = ""
	cPariente = ""

	cAfiliado = Alltrim(Nvl(loSheet.cells(nIn,1).Value,''))
	cPariente = Alltrim(Nvl(loSheet.cells(nIn,2).Value,''))

	Replace nroafil With cAfiliado
	Replace parentesco With cPariente

	Replace c_fecnac With loSheet.cells(nIn,7).Value
	Replace sexo With Alltrim(Nvl(loSheet.cells(nIn,06).Value,""))
	Replace Obrasoc With ""  &&Alltrim(Nvl(loSheet.cells(nIn,01).Value,""))
	Replace codent With mentidadagrupadora
	Replace tipo_afi With ""

Next

oExcel.Quit()
oExcel = .F.
loSheet = .F.
loWorkbook = .F.

*Next

Release oExcel
Release loSheet
Release loWorkbook

*Set Default To (cCurrent)

Return

