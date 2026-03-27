** Grabamos el medicamento
** Tablas requeridas:
** mwkMedicamentos, mwkMediDrogas
Lparameters nOpcion

LOCAL lError
LOCAL mFecAlta
LOCAL mFecDesde
LOCAL mOpeAlta

mFecAlta = sp_busco_fecha_serv("DD")
mFecDesde = mFecAlta
mOpeAlta = mwkusuario.codigovax
lError = .f.
**--------------------- Alta/ Baja de cabecera.

If nOpcion = 1  && Grabar.

	Select mwkMedicamentos
	mId = ID_
	mCodPuntero = CodPuntero_
	mCodInsumo = CODINSUMO_
	mDescriInsumo = DescriInsumo_
	mPresentacion = Presentacion_
	mTipo = Tipo_
	mTipoEstado = TipoEstado_
	mVolumen = Volumen_
	mUniVolumen = UniVolumen_
	mUniTiempo = UniTiempo_
	mInfContinua = InfContinua_
	mIntervalo = Intervalo_
	mDosis = Dosis_
	mUniPrescripcion = UniPrescripcion_
	mVia = Via_

	If mId = 0  && item nuevo

** Cargamos la cabecera
		mRet = SQLExec(mcon1,"insert into tabMedicamentos (TM_insumo,tm_descripcion,tm_presentacion,tm_tipo," + ;
			"tm_tipoestado,tm_volumen,tm_univolumen,tm_unitiempo,tm_infcontinua,tm_intervalo,tm_dosis,tm_uniprescripcion,tm_via,tm_opealta," + ;
			"tm_fechaAlta,tm_fechaDesde " + ;
			") values (" + ;
			"?mCodPuntero,?mDescriInsumo,?mPresentacion,?mTipo,?mTipoEstado,?mVolumen,?mUniVolumen,?mUniTiempo,?mInfContinua," + ;
			"?mIntervalo,?mDosis,?mUniPrescripcion,?mVia,?mOpeAlta,?mFecAlta,?mFecDesde)" )

	Else
		mRet = SQLExec(mcon1,"update tabMedicamentos set " + ;
			"tm_descripcion = ?mDescriInsumo, " + ;
			"tm_presentacion = ?mPresentacion," + ;
			"tm_tipo = ?mTipo," + ;
			"tm_tipoestado = ?mTipoEstado, " + ;
			"tm_volumen = ?mVolumen, " + ;
			"tm_univolumen = ?mUniVolumen, " + ;
			"tm_unitiempo = ?mUniTiempo, " + ;
			"tm_infcontinua = ?mInfContinua, " + ;
			"tm_intervalo = ?mIntervalo, " + ;
			"tm_dosis = ?mDosis, " + ;
			"tm_uniprescripcion = ?mUniPrescripcion, " + ;
			"tm_via = ?mVia " + ;
			"where ID = ?mId")
	Endif

	If mRet <= 0
		Messagebox("ERROR EN ALTA/MODIFICACION TABLA TABMEDICAMENTOS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Else   &&borrar

	Select mwkMedicamentos
	mId = ID_
	mCodPuntero = CodPuntero_

	If mId > 0
** Borramos la cabecera.
		mRet = SQLExec(mcon1,"delete from TabMedicamentos where ID  = ?mId")

		If mRet <= 0
			Messagebox("ERROR AL INTENTAR BORRAR EN TABLA TABMEDICAMENTOS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif
Endif


**----------------------------Alta / Baja de Items.
Select mwkMediDrogas
SET FILTER TO 
Go Top
Scan All

	mEstado = Estado_
	mId = IdMd
	**mDescripcion = Td_Descripcion
	mDroga = idDroga
	mSecuencia = tmd_drogaseq
	mPotencia = tmd_potencia
	mUniPotencia = tmd_unipotencia
	mDMA = tmd_dosismaximaadultos
	mUniDma = tmd_unidma
	mDmn = tmd_dosismaximaniños
	mUniDmn = tmd_unidmn
    mFecHasta = '2100-01-01'
    
	If mEstado = 1   &&Alta
		If mId = 0
			mRet = SQLExec(mcon1,"insert into TabMediDrogas (tmd_droga,tmd_insumo,tmd_drogaseq,tmd_potencia, tmd_unipotencia,tmd_dosismaximaadultos," + ;
				"tmd_unidma,tmd_dosismaximaniños,tmd_unidmn,tmd_fechaalta,tmd_fechadesde,tmd_fechahasta,tmd_opealta) values (" + ;
				"?mDroga,?mCodPuntero,?mSecuencia,?mPotencia,?mUniPotencia,?mDma,?mUnidma,?mDmn,?mUniDmn,?mFecAlta,?mFecDesde,?mFecHasta,?mOpeAlta)")

			If mRet <= 0
				Messagebox("ERROR AL INSERTAR EN TABLA TABMEDIDROGAS",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				lError = .T.
				Exit
			Endif

        ELSE   && modificamos el nro. de secuencia.
        
            mRet = SQLEXEC(mcon1,"update TabMediDrogas set tmd_drogaseq = ?mSecuencia where ID = ?mId")
            If mRet <= 0
				Messagebox("ERROR AL ACTUALIZAR TABLA TABMEDIDROGAS",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				lError = .T.
				Exit
			Endif
            
		ENDIF
		
	Else  &&Borramos
		If mId > 0
			mRet = SQLExec(mcon1,"delete from TabMediDrogas where Id = ?mId")
		Endif

		If mRet <= 0
			Messagebox("ERROR AL INTENTAR BORRAR EN TABLA TABMEDIDROGAS",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lError = .T.
			Exit
		Endif

	Endif

Endscan

Return !lError
