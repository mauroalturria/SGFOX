Lparameters oForm

Local lPermiteBlanqueo
Local cRespuesta
Local mGuian
Local mCodIns
Local mDale

If oForm.lblanqueaprescrip
** ya presiono el boton de blanqueo.
	Return
Endif

lPermiteBlanqueo = .F.
cRespuesta = ""
mGuian = ""
mCodIns = ""
mDale = .T.

mfec = sp_busco_fecha_serv("DD")
mFechaHoy = sp_busco_fecha_serv("DT")
mIdevol = oForm.mIdevol
mfechorpres = mFechaHoy
** Verificamos primero la ultima fecha de Prescripcion
mRet = SQLExec(mcon1,"select MAX(pps_fechora) as pps_fechora from TabIntPmPres where pps_idevol = ?mIdevol","mwkIntPmPres")

If mRet < 0
	Messagebox("No se puede consultar la tabla TABINTPMPRES.Avise a Sistemas.","Blanqueo")
	Return
Endif

Go Top In mwkIntPmPres
If Vartype(mwkIntPmPres.pps_fechora) = "T"
	mFecMax = Ttod(mwkIntPmPres.pps_fechora)
Else
	mFecMax = {//}
Endif

Do Case
Case mFecMax = {//}
	lPermiteBlanqueo = .T.
Case mFecMax <> {//}
	If mFecMax < mfec
		lPermiteBlanqueo = .T.
**Else
**Messagebox("No se puede blanquear. Hay una prescripción vigente del dia.","Prescripción")
	Endif
Endcase


If lPermiteBlanqueo
**	If mFecMax < mfec

*!*	** Permitimos blanquear los tildes.
*!*			Update mwkIgrid1 Set _valida = 0, _vale = 0, _idAc = 0
*!*			Update mwkIgrid2 Set _valida = 0, _vale = 0, _idAc = 0

*!*			Update mwkIgrid12 Set _valida = 0, _vale = 0, _idAc = 0
*!*			Update mwkIgrid22 Set _valida = 0, _vale = 0, _idAc = 0

*!*			Update mwkIgrid13 Set _valida = 0, _vale = 0, _idAc = 0

	Select mwkIgrid1
	Set Filter To
	Go Top

	Select mwkIgrid2
	Set Filter To
	Go Top

	Select mwkIgrid12
	Set Filter To
	Go Top

	Select mwkIgrid22
	Set Filter To
	Go Top

	Select mwkIgrid13
	Set Filter To
	Go Top

	Select mwkIgrid3
	Set Filter To
	Go Top

	Select mwkIgrid33
	Set Filter To
	Go Top


** Marcelo Torres, 21/08/2015
** Nuevo Blanqueo. Verificamos si pasaron mas de 24hs. desde la ultima modificacion del insumo.
	For nIn = 1 To 5

		Do Case
		Case nIn = 1
			mTabla= "mwkIgrid1"    &&sueros
			mFecMod = "ps_fechormodif"
			mtBase = "TabIntPmSolu"
		Case nIn = 2
			mTabla = "mwkIgrid2"   &&Agregados Sueros
			mFecMod = "pa_fechormodif"
			mtBase = "TabIntPmAgre"
		Case nIn = 3
			mTabla = "mwkIgrid12"  &&sueros ??
			mFecMod = "ps_fechormodif"
			mtBase = "TabIntPmSolu"
		Case nIn = 4
			mTabla = "mwkIgrid22"  &&Agregados Medicacion Endovenosa
			mFecMod = "pa_fechormodif"
			mtBase = "TabIntPmAgre"
		Case nIn = 5
			mTabla = "mwkIgrid13"  &&insumos
			mFecMod = "ps_fechormodif"
			mtBase = "TabIntPmSolu"
		Endcase

		Select &mTabla.
		Go Top

		Scan All

** Buscamos los datos del insumo y tomamos la fecha-hora de modificacion.
			If &mTabla.._registro > 0 And &mTabla.._estado = 1

				If (&mTabla.._idac > 0 Or &mTabla.._vale > 0)

					mId = &mTabla.._registro

					Do Case
					Case &mTabla.._vale > 0
						mValor = Alltrim(Str(&mTabla.._vale))
						mStatement = "select VAL_codvaleasist,VAL_fechasolicitud,VAL_horasolicitud from valesasist where VAL_codvaleasist = " + mValor + " "
					Case &mTabla.._idac > 0
						mValor = Alltrim(Str(&mTabla.._idac))
						mStatement = "select APV_idautprevias,APV_fechasolicitud,APV_horasolicitud from AutPrevias where APV_idautprevias = " + mValor + " "
					Endcase

**mId = Alltrim(Str(&mTabla.._registro))
** prg_ejecutosql(tcSql, tcCursor)

**If sp_busco_prescripcionxid(nIn,mId)
**mStatement = "select * from " + mtBase + " where id = " + mId + " "
					If prg_ejecutosql(mStatement,"mwkRegistro")

**mFechaPrescripcion = mwkRegistro.&mFecMod.

						Do Case
						Case &mTabla.._vale > 0
							mFechaPrescripcion = mwkRegistro.VAL_fechasolicitud
							mHoraPrescripcion = Strtran(".",mwkRegistro.VAL_horasolicitud,":")
						Case &mTabla.._idac > 0
							mFechaPrescripcion = mwkRegistro.APV_FechaSolicitud
							mHoraPrescripcion = Right(Ttoc(mwkRegistro.APV_horasolicitud),8)
						Endcase

						mFecHorPres = Ctot(Dtoc(mFechaPrescripcion) + " " + mHoraPrescripcion)

** El blanqueo se producira cuando la prescripcion haya tenido una antiguedad mayor a 24hs.
** Marcelo Torres, 08/09/2015.
** Esta validacion queda sin efecto hasta nuevo aviso. Hablado con Mariana Fidalgo.
**If (mFechaHoy - mFecHorPres ) >= 86400
** Actualizamos

						Select &mTabla.
						Replace &mTabla.._valida With 0
						Replace &mTabla.._vale   With 0
						Replace &mTabla.._idac   With 0


*!*	** Si la prescripcion tiene planificacion "POR UNICA VEZ", la eliminamos.
*!*	** Marcelo Torres 26/08/2015
*!*	** Borramos la planificacion "ANTE EVENTO" y "POR UNICA VEZ"
*!*	** Marcelo Torres, 16/06/2016
*!*	** Borramos la planificacion "ANTE EVENTO", "POR UNICA VEZ" , "REPOSICION" y "PARA ALTA"
*!*	** _idopt = 3 o 4 o 6 o 7
*!*	** 19/01/2022


*!*							If (mFechaHoy - mFecHorPres ) >= 86400

*!*								mGuian = &mTabla.._Guia
*!*								mCodIns = ALLTRIM(&mTabla.._codins)
*!*								Do Case
*!*								Case nIn = 4
*!*									Select mwkIgrid3
*!*	*Delete From mwkIgrid3 Where mwkIgrid3._Guia = mGuian And mwkIgrid3._estado = 1 And Alltrim(mwkIgrid3._codins) = (mCodIns) And (_idopt = 3 Or _idopt = 4)
*!*									Update mwkIgrid3 Set _estado = 0 Where _Guia = mGuian And _estado = 1 And Alltrim(_codins) = mCodIns And (_idopt = 3 Or _idopt = 4 Or _idopt = 6 Or _idopt = 7)
*!*								Case nIn = 5
*!*									Select mwkIgrid33
*!*	**Delete From mwkIgrid33 Where mwkIgrid33._Guia = mGuian And mwkIgrid3._estado = 1 And Alltrim(mwkIgrid33._codins) = (mCodIns) And (_idopt = 3 Or _idopt = 4)
*!*									Update mwkIgrid33 Set _estado = 0 Where _Guia = mGuian And _estado = 1 And Alltrim(_codins) = mCodIns And INLIST(_idopt,3,4,6,7)
*!*									*** (_idopt = 3 Or _idopt = 4 Or _idopt = 6 Or _idopt = 7)
*!*								Endcase

*!*							Endif

**Else
**	cRespuesta = cRespuesta + " - " + &mTabla.._mondroga + Chr(13)
**Endif
					Else
						Messagebox("No se blanquean todos los items. Intente nuevamente.",16,"Inicializar")
						Exit
					Endif

				Else

** ------------------------ Aca borramos los casos en que venga _idac = -1 o que el nro. de vale este en 0
					Select &mTabla.
					Replace &mTabla.._valida With 0
					Replace &mTabla.._vale   With 0
					Replace &mTabla.._idac   With 0

				Endif

** Si la prescripcion tiene planificacion "POR UNICA VEZ", la eliminamos.
** Marcelo Torres 26/08/2015
** Borramos la planificacion "ANTE EVENTO" y "POR UNICA VEZ"
** Marcelo Torres, 16/06/2016
** Borramos la planificacion "ANTE EVENTO", "POR UNICA VEZ" , "REPOSICION" y "PARA ALTA"
** _idopt = 3 o 4 o 6 o 7
** 19/01/2022

				If (mFechaHoy - mFecHorPres ) >= 86400

					mGuian = &mTabla.._Guia
					mCodIns = Alltrim(&mTabla.._codins)
					Do Case
					Case nIn = 4
						Select mwkIgrid3
*Delete From mwkIgrid3 Where mwkIgrid3._Guia = mGuian And mwkIgrid3._estado = 1 And Alltrim(mwkIgrid3._codins) = (mCodIns) And (_idopt = 3 Or _idopt = 4)
						Update mwkIgrid3 Set _estado = 0 Where _Guia = mGuian And _estado = 1 And Alltrim(_codins) = mCodIns And (_idopt = 3 Or _idopt = 4 Or _idopt = 6 Or _idopt = 7)
					Case nIn = 5
						Select mwkIgrid33
**Delete From mwkIgrid33 Where mwkIgrid33._Guia = mGuian And mwkIgrid3._estado = 1 And Alltrim(mwkIgrid33._codins) = (mCodIns) And (_idopt = 3 Or _idopt = 4)
						Update mwkIgrid33 Set _estado = 0 Where _Guia = mGuian And _estado = 1 And Alltrim(_codins) = mCodIns And Inlist(_idopt,3,4,6,7)
*** (_idopt = 3 Or _idopt = 4 Or _idopt = 6 Or _idopt = 7)
					Endcase

				Endif


			Endif

			Select &mTabla.

		Endscan

	Next nIn

** ---------- Borramos los urgentes - Marcelo Torres 07/08/2019
	Select mwkIgrid33
	Go Top
	Update mwkIgrid33 Set _Urge = ''
	Go Top
	If Used('mwkIvelinf')
		Select mwkIvelinf
		Go Top
		Update mwkIvelinf Set _chkurg = 0
		Go Top
	Endif
	oForm.lblanqueaprescrip = .T.

	oForm.pgconsulta.pgindic.pgindicaciones.page2.cntsueros.pgSueros.page1.txtultimaPres.Value = "Nueva Prescripción"
	oForm.pgconsulta.pgindic.pgindicaciones.page2.cntsueros.pgSueros.page2.txtultimaPres.Value = "Nueva Prescripción"
	oForm.pgconsulta.pgindic.pgindicaciones.page3.cntmedins.txtultimaPres.Value = "Nueva Prescripción"

Else
	Messagebox("No se puede Inicializar. Hay una prescripción vigente del dia.","Prescripción")
Endif

**Endif


*!*	Else

*!*	** Permitimos blanquear los tildes. Supuestamente es la primera vez...

*!*		Update mwkIgrid1 Set _valida = 0, _vale = 0, _idac = 0
*!*		Update mwkIgrid2 Set _valida = 0, _vale = 0, _idac = 0

*!*		Update mwkIgrid12 Set _valida = 0, _vale = 0, _idac = 0
*!*		Update mwkIgrid22 Set _valida = 0, _vale = 0, _idac = 0

*!*		Update mwkIgrid13 Set _valida = 0, _vale = 0, _idac = 0

*!*		oForm.lblanqueaprescrip = .T.

*!*		oForm.pgconsulta.pgindic.pgindicaciones.page2.cntsueros.pgSueros.page1.txtultimaPres.Value = "Nueva Prescripción"
*!*		oForm.pgconsulta.pgindic.pgindicaciones.page2.cntsueros.pgSueros.page2.txtultimaPres.Value = "Nueva Prescripción"
*!*		oForm.pgconsulta.pgindic.pgindicaciones.page3.cntmedins.txtultimaPres.Value = "Nueva Prescripción"

*!*	Endif

Select mwkIgrid1
Set Filter To mwkIgrid1._estado = 1
Go Top

Select mwkIgrid2
Go Top

Select mwkIgrid12
Set Filter To mwkIgrid12._estado = 1
Go Top

Select mwkIgrid22
Go Top

Select mwkIgrid13
Set Filter To mwkIgrid13._estado = 1
Go Top

Use In Select("mwkIntPmPres")
Use In Select("mwkRegistro")

If !Empty(cRespuesta)
	Messagebox("Los siguientes items no se inicializan por haber sido prescriptos dentro de las 24hs: " +Chr(13)+ cRespuesta + Chr(13) + "Verifique.","Inicializar")
Endif
