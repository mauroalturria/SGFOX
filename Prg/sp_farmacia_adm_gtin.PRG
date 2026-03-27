*
* Busqueda de Insumos (GTIN) por diversos criterios
*
Lparameters mvec

mwhere = ""

&& Principio Activo
If !empty(mvec[1])
	mwhere = mwhere + " TGT_PrincAct like '%" + mvec[1] + "%'"
Endif

&& Código S.G.
If !empty(mvec[2])
	*mwhere = iif(empty(mwhere),""," and ") + " TGT_inscod = ?mvec[2] "
	mwhere = mwhere + iif(empty(mwhere),""," and ") + " TGT_inscod like '%" + mvec[2] + "%'"
Endif

&& GTIN
If !empty(mvec[3])
	mwhere = mwhere + iif(empty(mwhere),""," and ") + " TGT_gtin = ?mvec[3] "
Endif

&& Descripción
If !empty(mvec[4])
	mwhere = mwhere + iif(empty(mwhere),""," and ") + " ucase(TGT_des) like '%" + Upper(mvec[4]) + "%'"
Endif

&& Razón Social
If !empty(mvec[5])
	mwhere = mwhere + iif(empty(mwhere),""," and ") + " ucase(TGT_Rsoc) like '%" + Upper(mvec[5]) + "%'"
Endif

&& Solo Nulos
If mvec[6] = "S"
	mwhere = mwhere + iif(empty(mwhere),""," and ") + " TGT_inscod is null or TGT_inscod = 'SIN CODIGO' "
Endif

Use in select("mwkadmgtin")

mret = sqlexec(mcon1,"select TGT_gtin, TGT_inscod, TGT_des, TGT_PrincAct, TGT_Frma, TGT_Rsoc, TGT_cantidad, TGT_Troquel, TGT_Pres,"+;
    " Id as lid from TabTraGtin "+iif(!empty(mwhere)," where " + mwhere,"") ,"mwkadmgtin")

mretorna = .T.

If mret < 0
	Messagebox("EN CONSULTA DE INSUMOS GTIN",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	mretorna = .F.
Endif

Return mretorna

