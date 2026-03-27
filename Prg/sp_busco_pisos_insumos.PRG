*
* Busqueda de Insumos de Farmacia para control de Pisos (Pendientes / Full)
*
Lparameters mdes, mhas, msec, mchk, mchksector

mwhere = ""
msec1  = ""
mhas1  = mhas + 1

If mchk = 1
	mwhere = " AND TVE_Entrega < TVE_Soli"
Endif

If mchksector = 1
	If Inlist(msec,"CEG","IDE",'IEP',"EME")
		msec1 = " AND valesasist.val_codSector = ?msec "
	Else
		msec1 = " AND TVE_Sector = ?msec "
	Endif
Endif

Use In Select("mwkvales")

mret = SQLExec(mcon1,"SELECT VALESASIST.VAL_habitacion," +;
	" VALESASIST.VAL_cama," +;
	" VALESASIST.VAL_codadmision," +;
	" INSUMOS.INS_descriinsumo," +;
	" TabFarmVPDetEnt.TVE_TipoEnt," +;
	" TabFarmVPDetEnt.TVE_Soli," +;
	" TabFarmVPDetEnt.TVE_Entrega," +;
	" TabFarmVPDetEnt.TVE_ObsItem," +;
	" TabFarmVPDetEnt.TVE_Vale," +;
	" VALESASIST.VAL_fechasolicitud,"+;
	" VALESASIST.VAL_horasolicitud,"+;
	" TabFarmVPCabe.TVC_IniPre," +;
	" TabFarmVPCabe.TVC_FinPre," +;
	" TabFarmVPDetEnt.TVE_insumocodigo," +;
	" TabFarmVPDetEnt.TVE_Sector," +;
	" TabFarmVPCabe.ID as Preparacion," +;
	" TabFarmVPDetEnt.TVE_usuario,"+;
	" TabFarmVPDetEnt.TVE_idpre,"+;
	" TabFarmVPEntega.TET_FecEnt, "+;
	" TabFarmVPEntega.TET_sector "+;
	" FROM TabFarmVPCabe" +;
	" INNER JOIN TabFarmVPDetEnt ON TabFarmVPCabe.ID = TabFarmVPDetEnt.TVE_IdPre" +;
	" INNER JOIN INSUMOS ON TabFarmVPDetEnt.TVE_insumocodigo = INSUMOS.INS_codinsumo" +;
	" INNER JOIN VALESASIST ON TabFarmVPDetEnt.TVE_Vale = VALESASIST.VAL_codvaleasist" +;
	" Left join TabFarmVPEntega on TET_idpre = TabFarmVPCabe.ID"+;
	" WHERE TabFarmVPCabe.TVC_IniPre >= ?mdes "+;
	" AND TabFarmVPCabe.TVC_FinPre < ?mhas1" +;
	" AND TabFarmVPCabe.TVC_Estado <> 3 " + mwhere + msec1 + ;
	" ORDER BY VALESASIST.VAL_habitacion, VALESASIST.VAL_cama","mwkvales")

*!*	mret = SQLExec(mcon1,"SELECT VALESASIST.VAL_habitacion," +;
*!*		" VALESASIST.VAL_cama," +;
*!*		" VALESASIST.VAL_codadmision," +;
*!*		" INSUMOS.INS_descriinsumo," +;
*!*		" TabFarmVPDetEnt.TVE_TipoEnt," +;
*!*		" TabFarmVPDetEnt.TVE_Soli," +;
*!*		" TabFarmVPDetEnt.TVE_Entrega," +;
*!*		" TabFarmVPDetEnt.TVE_ObsItem," +;
*!*		" TabFarmVPDetEnt.TVE_Vale," +;
*!*		" VALESASIST.VAL_fechasolicitud," +;
*!*		" VALESASIST.VAL_horasolicitud," +;
*!*		" TabFarmVPCabe.TVC_IniPre," +;
*!*		" TabFarmVPCabe.TVC_FinPre," +;
*!*		" TabFarmVPDetEnt.TVE_insumocodigo," +;
*!*		" TabFarmVPDetEnt.TVE_Sector," +;
*!*		" TabFarmVPCabe.ID as Preparacion" +;
*!*		" FROM TabFarmVPCabe" +;
*!*		" INNER JOIN TabFarmVPDetEnt ON TabFarmVPCabe.ID = TabFarmVPDetEnt.TVE_IdPre" +;
*!*		" INNER JOIN INSUMOS ON TabFarmVPDetEnt.TVE_insumocodigo = INSUMOS.INS_codinsumo" +;
*!*		" INNER JOIN VALESASIST ON TabFarmVPDetEnt.TVE_Vale = VALESASIST.VAL_codvaleasist" +;
*!*		" WHERE TabFarmVPCabe.TVC_IniPre >= ?mdes "+;
*!*		" AND TabFarmVPCabe.TVC_FinPre < ?mhas1" +;
*!*		" AND TabFarmVPCabe.TVC_Estado <> 3 " + mwhere + msec1 + ;
*!*		" ORDER BY VALESASIST.VAL_habitacion, VALESASIST.VAL_cama","mwkvales")

* Contemplando Maestro Silvia alimentado de ZTRAN005 operador = codigovax

*!*	mret = SQLExec(mcon1,"SELECT VALESASIST.VAL_habitacion," +;
*!*		" VALESASIST.VAL_cama," +;
*!*		" VALESASIST.VAL_codadmision," +;
*!*		" INSUMOS.INS_descriinsumo," +;
*!*		" TabFarmVPDetEnt.TVE_TipoEnt," +;
*!*		" TabFarmVPDetEnt.TVE_Soli," +;
*!*		" TabFarmVPDetEnt.TVE_Entrega," +;
*!*		" TabFarmVPDetEnt.TVE_ObsItem," +;
*!*		" TabFarmVPDetEnt.TVE_Vale," +;
*!*		" VALESASIST.VAL_fechasolicitud,"+;
*!*		" VALESASIST.VAL_horasolicitud,"+;
*!*		" TabFarmVPCabe.TVC_IniPre," +;
*!*		" TabFarmVPCabe.TVC_FinPre," +;
*!*		" TabFarmVPDetEnt.TVE_insumocodigo," +;
*!*		" TabFarmVPDetEnt.TVE_Sector," +;
*!*		" TabFarmVPCabe.ID as Preparacion," +;
*!*		" TabUsuario.idusuario as TVE_usuario"+;
*!*		" FROM TabFarmVPCabe" +;
*!*		" INNER JOIN TabFarmVPDetEnt ON TabFarmVPCabe.ID = TabFarmVPDetEnt.TVE_IdPre" +;
*!*		" INNER JOIN INSUMOS ON TabFarmVPDetEnt.TVE_insumocodigo = INSUMOS.INS_codinsumo" +;
*!*		" INNER JOIN VALESASIST ON TabFarmVPDetEnt.TVE_Vale = VALESASIST.VAL_codvaleasist" +;
*!*		" join StockMovimCabe on StockMovimCabe.codmov= 'VP' and StockMovimCabe.NROMOV = TabFarmVPDetEnt.TVE_Vale"+;
*!*		" join TabUsuario on TabUsuario.codigovax = StockMovimCabe.operador"+;
*!*		" WHERE TabFarmVPCabe.TVC_IniPre >= ?mdes "+;
*!*		" AND TabFarmVPCabe.TVC_FinPre < ?mhas1" +;
*!*		" AND TabFarmVPCabe.TVC_Estado <> 3 " + mwhere + msec1 + ;
*!*		" ORDER BY VALESASIST.VAL_habitacion, VALESASIST.VAL_cama","mwkvales")


If mret < 0
	mltabla = "FARMACIA PREPARACIONES DETALLES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkvales")

*!* 2014-11-07 Control " LEN(ALLTRIM(TET_sector)) > 2 " debido a error en el modulo de entrega
*!* 2014-11-18 Agrupamiento x Vale + Insumo

	Select TVE_sector,VAL_habitacion,;
		VAL_cama,;
		sp_busco_npac(VAL_codadmision, 1) As nombre,;
		INS_descriinsumo,;
		TVE_TipoEnt,;
		TVE_Soli,;
		TVE_Entrega,;
		TVE_ObsItem,;
		TVE_Vale,;
		ctot(Dtoc(VAL_fechasolicitud)+ " " +Strtran(Alltrim(VAL_horasolicitud),".",":")+":00") As fechahora,;
		TVC_IniPre,;
		TVC_FinPre,;
		NVL(TVE_usuario,Space(20)) As TVE_usuario,;
		Preparacion,;
		NVL(TET_FecEnt,Ctot("  /  /    ")) As entregado,;
		TVE_insumocodigo, TVE_idpre;
		FROM mwkvales ;
		WHERE Len(Alltrim(TET_sector)) > 2 ;
		GROUP By TVE_Vale, TVE_insumocodigo ;
		ORDER By TVE_sector, VAL_habitacion, VAL_cama ;
		Into Cursor mwkvales

*!*		Select TVE_sector,VAL_habitacion,;
*!*			VAL_cama,;
*!*			sp_busco_npac(VAL_codadmision, 1) As nombre,;
*!*			INS_descriinsumo,;
*!*			TVE_TipoEnt,;
*!*			TVE_Soli,;
*!*			TVE_Entrega,;
*!*			TVE_ObsItem,;
*!*			TVE_Vale,;
*!*			ctot(Dtoc(VAL_fechasolicitud)+ " " +Strtran(Alltrim(VAL_horasolicitud),".",":")+":00") As fechahora,;
*!*			TVC_IniPre,;
*!*			TVC_FinPre,;
*!*			Space(20) As TVE_usuario,;
*!*			TVE_insumocodigo,;
*!*			Preparacion;
*!*			FROM mwkvales ;
*!*			ORDER By TVE_sector, VAL_habitacion, VAL_cama ;
*!*			Into Cursor mwkvales

Endif

Return .T.








