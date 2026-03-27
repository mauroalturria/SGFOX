** Pasamos nIdOptMax y cObsMax por referencia.

Lparameters cVale,cInsumo, nIdOptMax,cObsMax, cCodAdmision, nInsCodPuntero

Local cIdRegInsumoP
Local cIdRegInsumoA
Local cOrigen
Local lError
Local cAlias
Local nIdevol
Local xGuia
Local dtfechahoravale
* Local nIdOptMax
Local nVale
Local cAdmision

nIdOptMax = 0
cObsMax = ""
lError = .F.
nVale = Iif(Vartype(cVale) = "C",Round(Val(cVale),0),0)
cAdmision = ""

* Habilitamos el chequeo de dosis maxima
If !fHabDosisMaxima()
	Return .T.
Endif

Wait "CONSULTANDO DOSIS MAXIMA ..." Window Nowait

cAlias = Alias()

Set Step On

* ---------------------------------------------------
If nVale > 0

* Buscamos datos del vale
	mret = SQLExec(mcon1,"select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud,VAL_fhsolicitud, VAL_codadmision from valesasist where val_codvaleasist = ?nVale","mwkValVales")
	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE LA TABLA VALESASIST",26,"Dosis Máxima")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return nIdOptMax
	Endif

* Buscamos el vale en TabIntPmvales
	mret = SQLExec(mcon1,"select * from TabIntPmVales where IPV_vale = ?nVale","mwkPmVales")

	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMVALES",26,"Dosis Máxima")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return nIdOptMax
	Endif

	cIdRegInsumoP = ""
	cIdRegInsumoA = ""
	cOrigen = ""

	Select mwkPmVales
	Go Top

	cAdmision = mwkValVales.val_codadmision

Else
	cAdmision = cCodAdmision

	mret = SQLExec(mcon1,"select ins_codinsumo from insumos where ins_codpuntero = ?nInsCodPuntero","mwkInsumoMax")

	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE LA TABLA INSUMOS",26,"Dosis Máxima 1")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return nIdOptMax
	Endif

	Select mwkInsumoMax
	Go Top

	cInsumo = mwkInsumoMax.ins_codinsumo

	Use In Select("mwkInsumoMax")	

Endif


* ---------------------------------------------------
If !USED("mwkPmVales") .or. Reccount("mwkPmVales") = 0

*cAdmision = mwkValVales.val_codadmision

*   Buscamos el Idevol por número de Admision+Insumo activo
	mret = SQLExec(mcon1,"select MAX(PS_idevol) as Idevol " +;
		"from TabIntPmSolu " +;
		"where PS_admision = ?cAdmision and PS_insumo = ?cInsumo and PS_fecpasiva = '1900-01-01' ","mwkTabIntPmSolu")

	If mret < 0
		Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMSOLU",26,"Dosis Máxima 1")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return nIdOptMax
	Endif

	Select mwkTabIntPmSolu
	Go Top

*   Si el vale es por Reemplazo, no va a tener prescripción en las tablas de Pisos
	If Reccount() > 0 And Nvl(mwkTabIntPmSolu.Idevol,0) > 0

		nIdevol = mwkTabIntPmSolu.Idevol

*   La medicación requiere AC.
		mret = SQLExec(mcon1,"select PA_insumo as insumo, NVL(PA_IdOptDMax,0) as IdOptMax, NVL(PA_ObsDMax,'') as ObsDMax, PA_fecpasiva as fecpasiva, PA_fechormodif as fechormodif from TabIntPmAgre " +;
			"where PA_idevol = ?nIdevol and PA_insumo = ?cInsumo and PA_fecpasiva = '1900-01-01' ","mwkTabIntPmAgre")

		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMAGRE",26,"Dosis Máxima 1")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return nIdOptMax
		Endif

		mret = SQLExec(mcon1,"select PP_insumo as insumo, NVL(PP_IdOptDMax,0) as IdOptMax, NVL(PP_ObsDMax,'') as ObsDMax, PP_fecpasiva as fecpasiva, PP_fechormodif as fechormodif from TabIntPmPlan " +;
			"where PP_idevol = ?nIdevol and PP_insumo = ?cInsumo and PP_fecpasiva = '1900-01-01' ","mwkTabIntPmPlan")

		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPPLAN",26,"Dosis Máxima 1")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return nIdOptMax
		Endif

*mret = SQLExec(mcon1,"select PA_insumo as insumo, PA_IdOptDMax as IdOptMax, PA_ObsDMax as ObsDMax from TabIntPmAgreLg where PA_insumo = ?cInsumo","mwkTabIntPmAgreLG")

*mret = SQLExec(mcon1,"select PP_insumo as insumo, PP_IdOptDMax as IdOptMax, PP_ObsDMax as ObsDMax from TabIntPmPlanLg where PP_insumo = ?cInsumo","mwkTabIntPmPlanLG")

*!*		Select * From mwkTabIntPmAgre ;
*!*			UNION All ;
*!*			SELECT * From mwkTabIntPmPlan ;
*!*			UNION All ;
*!*			SELECT * From mwkTabIntPmAgreLG ;
*!*			UNION All ;
*!*			SELECT * From mwkTabIntPmPlanLG ;
*!*			INTO Cursor mwkInsuMax

		Select * From mwkTabIntPmAgre ;
			UNION All ;
			SELECT * From mwkTabIntPmPlan ;
			INTO Cursor mwkInsuMax

* Establecer la fecha de modificación para ver aquellos insumos pasivados
*!*			Select mwkValVales
*!*			Go Top

*!*			dtfechahoravale = mwkValVales.VAL_fhsolicitud

*!*			Select * From mwkInsuMax Where fechormodif >= dtfechahoravale Into Cursor mwkInsuMaxb

        Select * From mwkInsuMax Into Cursor mwkInsuMaxb

* En este caso, no se puede conocer con exactitud si el vale tiene ID de dosis maxima
		Select mwkInsuMaxb
		Go Top

		Scan All
			If mwkInsuMaxb.IdOptMax > 0
				nIdOptMax = mwkInsuMaxb.IdOptMax
				cObsMax = mwkInsuMaxb.ObsDMax
				Exit
			Endif
		Endscan

	Endif


Else

	Scan All

		Do Case
		Case mwkPmVales.IPV_instipo = "P"   &&insumo principal
			cIdRegInsumoP = cIdRegInsumoP + Transform(mwkPmVales.IPV_idreginsumo) + ","
		Case mwkPmVales.IPV_instipo = "A"   &&Agregado al suero
			cIdRegInsumoA = cIdRegInsumoA + Transform(mwkPmVales.IPV_idreginsumo) + ","
		Endcase

	Endscan


	Do Case
	Case !Empty(cIdRegInsumoP)

		cIdRegInsumoP = Left(cIdRegInsumoP,Len(cIdRegInsumoP)-1)

*mret = SQLExec(mcon1,"select PS_idevol,PS_insumo,PS_guia from TabIntPmSolu where ID in (" + cIdRegInsumoP + ") and PS_FECPASIVA = '1900-01-01' ","mwkTabIntPmSolu")
		mret = SQLExec(mcon1,"select PS_idevol,PS_insumo,PS_guia from TabIntPmSolu where ID in (" + cIdRegInsumoP + ") ","mwkTabIntPmSolu")

		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMSOLU",26,"Dosis Máxima 2")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lError = .T.
		Endif

		If !lError

			Select mwkTabIntPmSolu
			Go Top

			Scan All

				cInsumo = mwkTabIntPmSolu.PS_insumo
				nGuia = mwkTabIntPmSolu.PS_guia
				nIdevol = mwkTabIntPmSolu.PS_idevol

*mret = SQLExec(mcon1,"select * from TabIntPmPlan where PP_idevol = ?nIdevol and PP_guia = ?nGuia and PP_Insumo = ?cInsumo AND PP_FECPASIVA = '1900-01-01' ","mwkTabIntPmPlan")
				mret = SQLExec(mcon1,"select * from TabIntPmPlan where PP_idevol = ?nIdevol and PP_guia = ?nGuia and PP_Insumo = ?cInsumo ","mwkTabIntPmPlan")

				If mret < 0
					Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMPLAN",26,"Dosis Máxima 2")
					Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
					lError = .T.
				Endif

				If !lError
					Select mwkTabIntPmPlan
					Go Top

					Scan All

						nIdOptMax = Nvl(mwkTabIntPmPlan.PP_IdOptDMax,0)
						cObsMax = Nvl(mwkTabIntPmPlan.PP_ObsDMax,'')

						If nIdOptMax > 0
							Exit
						Endif

					Endscan

					Select mwkTabIntPmSolu

				Endif

			Endscan

		Endif

	Case !Empty(cIdRegInsumoA)

		cIdRegInsumoA = Left(cIdRegInsumoA,Len(cIdRegInsumoA)-1)

		mret = SQLExec(mcon1,"select PA_idevol,PA_insumo,PA_guia from TabIntPmAgre where ID in (" + cIdRegInsumoA + ") ","mwkTabIntPmAgre")

		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE LA TABLA TABINTPMAGRE",26,"Dosis Máxima 2")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lError = .T.
		Endif

		If !lError

			Select mwkTabIntPmAgre
			Go Top

			Scan All

				cInsumo = mwkTabIntPmAgre.PA_insumo
				nGuia = mwkTabIntPmAgre.PA_guia
				nIdevol = mwkTabIntPmAgre.PA_idevol
				nIdOptMax = Nvl(mwkTabIntPmAgre.PA_IdOptDMax,0)
				cObsMax = Nvl(mwkTabIntPmAgre.PA_ObsDMax,'')

				If nIdOptMax > 0
					Exit
				Endif

				Select mwkTabIntPmAgre

			Endscan

		Endif

	Endcase

Endif

Use In Select("mwkTabIntPmSolu")
Use In Select("mwkTabIntPmAgre")
Use In Select("mwkTabIntPmPlan")
Use In Select("mwkValVales")
Use In Select("mwkPmVales")

If Vartype(cAlias) = "C" And !Empty(cAlias)
	Select (cAlias)  && Nos paramos de nuevo en la tabla
Endif

Return .T.


* --------------------------------------
FUNCTION fHabDosisMaxima()

LOCAL lResult

lResult = .f.

Do sp_busco_estados With 57, " and tipo = 28  ","mwkHabDosisMax"

SELECT mwkHabDosisMax
GO top

IF mwkHabDosisMax.Estado = 1
   lResult = .t.
ENDIF 

USE IN SELECT("mwkHabDosisMax")

RETURN lResult