*
* Busqueda de Documentos (Remito) Sistema Recepción de Materiales
*
Lparameters mdocu, mtipo, maestro, mdeposito

* mdocu = 78124 / 1-75251 - Puede tratarse de un ID o TXT
* set step on

If vartype(mdocu) <> "N"
	If Vartype(mdocu) <> "C"
		Return .F.
	Endif
Endif

If vartype(mdeposito) <> "N"
	mdeposito = 1
Endif

Use in select("mwkdocum1")
Use in select("mwkdocum2")
Use in select("mwkdocrcm")

If mtipo = 'INT'
	If mdocu > 0
	
		IF mdeposito = 0
			mwhere = " where RPV_ID = ?mdocu and REMITOPRV.DEP_id <> 1 "
		ELSE
			mwhere = " where RPV_ID = ?mdocu and REMITOPRV.DEP_id = ?mdeposito "
		ENDIF
		
		mret = sqlexe(mcon1,"select REMITOPRV.RPV_NRO, Proveedores.PRV_NOMBRE, Proveedores.PRV_CUIT,"+;
			" REMITOPRV.DEP_ID, REMITOPRV.ORC_ESTADO, REMITOPRV.RPV_ID, REMITOPRV.ORC_ID, REMITOPRV.RPV_NRO,"+;
			" REMITOPRV.PRV_ID, REMITOPRV.RPV_FECHA"+;
			" from REMITOPRV"+;
			" join proveedores on proveedores.PRV_ID = REMITOPRV.PRV_ID " + mwhere,"mwkdocum1")

		If mret < 0
			Messagebox("Error al consultar Documentos - Remitos",26,"Error")
			On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif
		If used("mwkdocum1")
			Select * from mwkdocum1 into cursor mwkdocrcm
		Endif
	Endif
Endif

If maestro = 2 && Maestro Firebird (mapeado) + CACHE

	If used("mwkdocum1")
		If reccount("mwkdocum1") > 0

			mcuit = Nvl(mwkdocum1.PRV_CUIT,"0")
			If vartype(mcuit) = "C"
				If at("-",mcuit) > 0
					mcuit = ChrTran(mcuit, '-', '')
				Endif
			Endif
			mbusca = Transform(mcuit,"99999999999")

			If mbusca <> "0"

				mret = sqlexe(mcon1,"select TGL_gln, TGL_TipoA from TabTraGLN"+;
					" where TGL_cuit =?mbusca","mwkdocum2")

				If mret < 0
					Messagebox("Error al consultar Documentos - Remitos",26,"Error")
					On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
					Return .F.
				Endif

			Endif

		Else
			Use in select("mwkdocum1")
		Endif
	Endif

Else && Maestro CACHE puede ser REMITO INTERNO (Firebird mapeado) o REMITO DOCUMENTO

	If mtipo = 'INT'

*!*    INSUMOS + INSUMOS TRAZABLES

*!*     Use in select("mwkinstra")
		Use in select("mwkinsrec")
		Use in select("mwkitrarec")
		Use in select("mwkitrarec2")

		If !Used("mwkinstra")

			mret = sqlexec(mcon1,"Select INS_codinsumo, INS_descriinsumo, TGT_unid, TGT_Gtin, INS_grupo, INS_tipo"+;
				" from insumos "+;
				" left join TabTraGtin on TGT_inscod = INS_codinsumo","mwkinstra")

			If mret < 0
				Messagebox("Error al consultar Maestro Insumos c/Trazables",26,"Error")
				On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .F.
			Endif

		Endif

*!*     MAESTRO RECEPCION DE MATERIALES INSUMOS SEGUN REMITO INTERNO

		mret = sqlexec(mcon1,"Select RPVD_ID, ART_Id, RPVD_Cantidad, RPVD_CANTENT, REQ_ID, REQ_TIPOCTE"+;
			" From REMITOPRVDET" +;
			" Where RPV_id = ?mdocu","mwkinsrec")

		If mret < 0
			Messagebox("Error al consultar Recepción de Materiales",26,"Error")
			On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif

*!*    Control Maestro DETALLE

		Use in select("mwkctrldet")

		mret = sqlexec(mcon1,"Select TMD_artid,sum(TMD_cantidad) as lcantidad, TMD_reqid, TMD_idmcab "+;
			" from tabmovdet"+;
			" where TMD_remitoid = ?mdocu"+;
			" group by TMD_artid, TMD_reqid","mwkctrldet")

		If mret < 0
			Messagebox("Error al consultar Maestro DETALLE DE MOVIMIENTOS",26,"Error")
			On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
			Return .F.
		Endif

*!*	*!*			Select iif(isnull(TGT_Gtin),"NO","SI") as trazable,;
*!*	*!*				INS_codinsumo, INS_descriinsumo, RPVD_Cantidad,;
*!*	*!*				nvl(lcantidad,0) as lentregado,;
*!*	*!*				000000.0000 as lCANTENT, nvl(REQ_ID,0) reqid, nvl(REQ_TIPOCTE,space(2)) as tipocte, ;
*!*	*!*				INS_grupo, INS_tipo;
*!*	*!*				from mwkinstra ;
*!*	*!*				join mwkinsrec on alltrim(INS_codinsumo) = alltrim(ART_Id);
*!*	*!*				left join mwkctrldet on alltrim(mwkctrldet.TMD_artid) = alltrim(INS_codinsumo);
*!*	*!*				Group by RPVD_ID,INS_codinsumo;
*!*	*!*				Into cursor mwkitrarec2

*!*     09/10/2012 Se vuelve al estado original por errores de origen en el maestro REMITO DETALLE

		Select iif(isnull(TGT_Gtin),"NO","SI") as trazable,;
			INS_codinsumo, INS_descriinsumo, RPVD_Cantidad,;
			nvl(lcantidad,0)  as lentregado,;
			000000.0000 as lCANTENT, nvl(REQ_ID,0) reqid, nvl(REQ_TIPOCTE,space(2)) as tipocte, ;
			INS_grupo, INS_tipo, nvl(TMD_idmcab,0) as idmcab ;
			from mwkinstra ;
			join mwkinsrec on alltrim(INS_codinsumo) = alltrim(ART_Id) ;
			left join mwkctrldet on alltrim(mwkctrldet.TMD_artid) = alltrim(INS_codinsumo);
			and mwkctrldet.TMD_reqid = nvl(mwkinsrec.REQ_ID ,0);
			Group by RPVD_ID, INS_codinsumo, REQ_ID;
			Into cursor mwkitrarec2

*!*	*!*     09/10/2012 Contemplo REQ_ID 

*!*			Select iif(isnull(TGT_Gtin),"NO","SI") as trazable,;
*!*				INS_codinsumo, INS_descriinsumo, RPVD_Cantidad,;
*!*				iif(nvl(mwkinsrec.REQ_ID ,0)>0,nvl(rpvd_cantidad,0), ;
*!*				(nvl(rpvd_cantidad,0) + RPVD_cantent)) as lentregado,;
*!*				000000.0000 as lCANTENT, nvl(REQ_ID,0) reqid, nvl(REQ_TIPOCTE,space(2)) as tipocte, ;
*!*				INS_grupo, INS_tipo ;
*!*				from mwkinstra ;
*!*				join mwkinsrec on alltrim(INS_codinsumo) = alltrim(ART_Id) ;
*!*				left join mwkctrldet on alltrim(mwkctrldet.TMD_artid) = alltrim(INS_codinsumo);
*!*				and mwkctrldet.TMD_reqid = nvl(mwkinsrec.REQ_ID ,0);
*!*				Group by RPVD_ID, INS_codinsumo, REQ_ID;
*!*				Into cursor mwkitrarec2


*!*		Use in select("mwkinstra")

		Use in select("mwkinsrec")
		Use in select("mwkctrldet")

		Use Dbf('mwkitrarec2') In 0 Again Alias mwkitrarec
		Use in select("mwkitrarec2")
	Endif

	If mtipo = 'INT'
		mwhere = "TTM_remitoint = ?mdocu"
	Else
		mwhere = "TTM_remitodoc = ?mdocu"
	Endif

	mret = sqlexe(mcon1,"select TabTraMov.*, TabTraGLN.TGL_Rsoc as PRV_NOMBRE,"+;
		" TabTraGTIN.TGT_des as producto, TabTraGTIN.TGT_rsoc as marca, TabTraGTIN.TGT_inscod as lcodigoins"+;
		" from TabTraMov"+;
		" join TabTraGLN on TGL_cuit = TabTraMov.TTM_cuitorg"+;
		" join TabTraGTIN on TGT_gtin = TabTraMov.TTM_gtin"+;
		" where " + mwhere +;
		" group by TTM_cuitorg, TTM_gtin, TTM_serie, TTM_tipomov, TTM_traorden","mwkdocum1")

	If mret < 0
		Messagebox("Error al consultar Documentos - Remitos",26,"Error")
		On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	Endif

Endif

Return .T.


