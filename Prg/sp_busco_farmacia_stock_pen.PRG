*
* Stock de Farmacia / Suministros
*
Lparameters mlfecha, mconforme, mprocede

If vartype(mprocede) <> "C"
	mprocede = "FAR"
Endif

Use in select("mwkstk1")
Use in select("mwkstk2")
Use in select("mwkstk3")
Use in select("mwkstk4")
Use in select("mwkstk5")

If mprocede = "FAR"

*!* -- Gotas y pomadas
*!* -- Comprimidos OC PP - Alfabetico
*!* -- Ampollas
*!* -- Asistenciales y Descartables
&& Insumos de Farmacia

	mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
		" nvl(STSALDO.SALDO,0) as saldo"+;
		" From INSUMOS "+;
		" Left Join STSALDO"+;
		" On INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito = 1"+;
		" Where ( (ins_grupo = 'A' or ins_grupo = 'D' or ins_grupo = 'M' or ins_grupo = 'U' or ins_grupo = 'W') "+;
		" and "+;
		" ins_tipo in ('AR', 'DL', 'MA', 'ME', 'OG', 'OP', 'SO', 'US', 'DD', 'GG', 'MM', 'DC', 'AT',"+;
		" 'OC','PP',"+;
		" 'NI', 'NN', 'SS', 'II', 'PS','RD') )"+;
		" or "+;
		" (ins_grupo = 'A' or ins_grupo = 'D')"+;
		" and ins_fechapasivo is null"+;
		" ORDER BY INS_descriinsumo","mwkstk1")

*" and saldo <> 0"+;

Else

&& Insumos de Suministros
*!*	Grupo   V     LI  LIMPIEZA
*!*	Grupo   L     UT  Utilies de libreria
*!*	Grupo   L     FC  Formularios Continuos
*!*	Grupo   L     FP  Formularios Planos
*!*	Grupo   L     PA  Papeleria
*!*	Grupo   C     EL  PILAS
*!*	Grupo   C     ET
*!*	Grupo   C     EC
*!*	Grupo   V     VA
*!*	Grupo   V     VR

	mret = sqlexec(mcon1,"select INS_codpuntero,INS_GRUPO,INS_TIPO,INS_CODINSUMO,INS_descriinsumo,"+;
		" nvl(STSALDO.SALDO,0) as saldo"+;
		" From INSUMOS "+;
		" Left Join STSALDO"+;
		" On INSUMOS.INS_codpuntero = STSALDO.Codigo and stsaldo.deposito = 1"+;
		" Where ( (ins_grupo = 'V' or ins_grupo = 'L' or ins_grupo = 'C') "+;
		" and "+;
		" ins_tipo in ('LI', 'UT', 'FC', 'FP', 'PA', 'EL', 'ET', 'EC', 'VA', 'VR') )"+;
		" and ins_fechapasivo is null"+;
		" ORDER BY INS_descriinsumo","mwkstk1")

*" and saldo <> 0"+;

Endif

If mret < 0
	Messagebox("EN CONSULTA DE STOCK"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Detalle items Remito

*Set step on

mret = sqlexec(mcon1,"select * from REMITOPRVDET "+;
	" join REMITOPRV on REMITOPRV.RPV_id = REMITOPRVDET.RPV_id and REMITOPRV.DEP_id = 1"+;
	" where REMITOPRVDET.RPVD_STAMP >= ?mlfecha","mwkstk2")

If mret < 0
	Messagebox("EN CONSULTA ITEMS REMITO DETALLE"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Detalle movimientos

mret = sqlexec(mcon1,"select * from TabMovDet"+;
	" Join TabMovCab on TMC_deposito = 1 and TMC_fecha >= ?mlfecha and TabMovCab.Id = TabMovDet.TMD_idmcab"+;
	" where TMD_fecha >= ?mlfecha","mwkstk3")

* and TMD_tipocte = 'RQ'

If mret < 0
	Messagebox("EN CONSULTA MOVIMIENTOS DETALLE"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Solo articulos de farmacia

Select * from mwkstk2 ;
	join mwkstk1 on mwkstk1.INS_CODINSUMO = mwkstk2.Art_id ;
	into cursor mwkstk4

*!*	Select ttod(RPVD_STAMP) as lfecha,;
*!*		RPV_id as remitopro, ;
*!*		INS_CODINSUMO as codart, ;
*!*		INS_descriinsumo as desart, ;
*!*		Nvl(TMD_idmcab,0) as confrecep, ;
*!*		Int(RPVD_cantidad) as canrecibe, ;
*!*		Nvl(TMD_cantidad,0) as canstk ;
*!*		From mwkstk4 ;
*!*		Left join mwkstk3 on mwkstk3.TMD_remitoid = mwkstk4.RPV_id and TMD_artid = Art_id;
*!*		Order by remitopro ;
*!*		Into cursor mwkstk5

*
* 16-11-2012 // Agrupamiento en caso de contar con un mismo producto solicitado + de una vez en la misma requisición
*
Select ttod(RPVD_STAMP) as lfecha,;
	RPV_id as remitopro, ;
	INS_CODINSUMO as codart, ;
	INS_descriinsumo as desart, ;
	Nvl(TMD_idmcab,0) as confrecep, ;
	Int(RPVD_cantidad) as canrecibe, ;
	Nvl(TMD_cantidad,0) as canstk ;
	From mwkstk4 ;
	Left join mwkstk3 on mwkstk3.TMD_remitoid = mwkstk4.RPV_id;
	and TMD_artid = Art_id ;
	and TMD_reqid = nvl(REQ_ID ,0);
	group by orc_id, remitopro, codart, rpvd_id;
	Order by remitopro ;
	Into cursor mwkstk5
*
* 16-11-2012 Modelo de Farmacia34
*
*!*		Select iif(isnull(TGT_Gtin),"NO","SI") as trazable,;
*!*				INS_codinsumo, INS_descriinsumo, RPVD_Cantidad,;
*!*				nvl(lcantidad,0)  as lentregado,;
*!*				000000.0000 as lCANTENT, nvl(REQ_ID,0) reqid, nvl(REQ_TIPOCTE,space(2)) as tipocte, ;
*!*				INS_grupo, INS_tipo ;
*!*				from mwkinstra ;
*!*				join mwkinsrec on alltrim(INS_codinsumo) = alltrim(ART_Id) ;
*!*				left join mwkctrldet on alltrim(mwkctrldet.TMD_artid) = alltrim(INS_codinsumo);
*!*				and mwkctrldet.TMD_reqid = nvl(mwkinsrec.REQ_ID ,0);
*!*				Group by RPVD_ID, INS_codinsumo, REQ_ID;
*!*				Into cursor mwkitrarec2


If mconforme = 1
	Select * from mwkstk5 where confrecep = 0 into cursor mwkstk5
Endif

Use in select("mwkstk1")
Use in select("mwkstk2")
Use in select("mwkstk3")
Use in select("mwkstk4")

Return .T.
