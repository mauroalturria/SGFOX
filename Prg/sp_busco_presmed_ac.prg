** sp_busco_presmed_ac
** Parametros :
** midevol,codigo de insumo,Fecha+Hora de pedido (en formato DT)
Lparameters mIdAC, mCodInsumo,mdTUltimaPres

mResultado = 0

If Vartype(mdTUltimaPres) = "T"

	If Ttod(mdTUltimaPres) <> {//}

		mFecha = Ttod(mdTUltimaPres)
		mHora = Right(Ttoc(mdTUltimaPres),8)
		mWhere = ""

** $ZDT({VAL_fechasolicitud},3)_" "_$TRANSLATE($JUSTIFY({VAL_horasolicitud},5,2),". ",":0")_":00" }

**mRet = SQLExec(mcon1,"SELECT b.ins_codpuntero,a.id as idac, " +;
"from autprevias as a " + ;
"left join insumos as b on a.apv_CodInsuSolic = b.ins_codpuntero and b.ins_codinsumo = ?mCodInsumo " + ;
"where a.id = ?mIdAc and a.apv_fechasolicitud >= ?mFecha and a.apv_horasolicitud >= ?mhora","mwkAutPrevia")

		mRet = SQLExec(mcon1,"SELECT b.ins_codpuntero,a.id as idac, a.apv_fechasolicitud,a.apv_horasolicitud " +;
			"from autprevias as a " + ;
			"left join insumos as b on a.apv_CodInsuSolic = b.ins_codpuntero and b.ins_codinsumo = ?mCodInsumo " + ;
			"where a.id = ?mIdAc and a.apv_fechasolicitud >= ?mFecha","mwkAutPrevia")

		If mRet <= 0
			Messagebox("ERROR EN LA LECTURA DE AUTPREVIAS.",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			mResultado = 0
			Return mResultado
		Endif

** --------------- Marcelo Torres, 01/07/2016. Filtramos la hora
		Select * From mwkAutPrevia Where Ctot(Dtoc(apv_fechasolicitud) + ' ' + Ttoc(apv_horasolicitud,2)) >= mdTUltimaPres Into Cursor mwkAutPrevia

		Go Top In mwkAutPrevia
		If Reccount("mwkAutPrevia") > 0
			mResultado = mwkAutPrevia.Idac
		Endif

		Use In Select("mwkAutPrevia")

	Endif

Endif

Return mResultado
