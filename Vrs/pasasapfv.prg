
Create Cursor SAP (vacio c(1),CESa c(4),EPISODIO c(8),UNOrg c(50),PRESTACION N(10),NROACTUAL n(17),REFMOVIM c(50),RSOLO c(50);
	,UOMEDSOL c(15),Modif c(1),UOGES c(6),MODIF1 c(1),CP N(10),PRecio c(20),MATERIAL c(10),CSOLO c(1),PSOLO c(1),CTF n(17);
	,FEINIR c(10),FEFINR c(10),HORADE c(8),AHORA2 c(8),CTD2 c(50),FECHADE c(10),AFECHA2 c(10),HORADE2 c(8),AHORa c(8),CP2 c(50);
	,PRESTACION2 c(20),CL c(10),FACTMULT N(10),CTDP c(50),UN c(10),DENOMPREST c(50),CREADOEL c(10),CREADO c(20),MODifel c(10);
	,MODIFPOR c(50),ASOLO c(50),ANULADO c(50),NROACT N(10),PR c(50),JUSTIF c(50),WOUNDNO c(50),OBSERV c(50),NROACTUAL0 N(10);
	,NADa c(50),EF c(50),UOENFSOL c(10),MODIF2 c(1),IDIOMA2 c(50),IQ c(50),CIQ c(50),CP3 c(50),IDIOMa c(50),CSOLO2 c(50);
	,CLAN c(50),OSOLO c(50),DEFECHa c(10),AFECHa c(10),TSOLO c(50),CTD3 c(50),MODIF3 c(50),ISOLO c(50),CR c(50),Ca c(50);
	,CR2 c(50),EVENTO N(10),OBJETO c(20),ISOLO2 c(1);
	,EVENMOD c(50),OBJETOMOD c(50),VIACX c(50),Cot c(10),MODIF4 c(50),ORDEN c(50),REF c(50),PASEG c(1),fsolo c(10),CR3 c(50);
	,FFESIG c(10),HRSIG c(8),Ta c(8),NPUNTOS c(50),IDEXTERNO N(10),CLASEXT c(50),MODULO c(50);
	,ORDENCX c(50),FEINIMOD c(10),FEFINMOD c(10),HRINIMOD c(8),HRFINMOD c(8),IMPORTE c(50),CANTINMS N(17),UNID c(50);
	,MODULO2 c(50),urgen c(1),entrada c(20),Noprotoco c(50),VALE N(10))

Do SP_CONEXION


Set Step On
Select SAP

Append From  c:\desaguemes\vales.txt Delimited With Tab
*Use ?sap Again In 0
Select SAP
mireg= Reccount('sap')
Scan
	Wait Windows Transform(Recno())+"/"+Transform(mireg) Nowait
	If CESa = 'SGSC'
		mret = SQLExec(mcon1,"insert into  Sapvalesish (Ahora, Anulado,   Asolo, Cl, Creado,   CreadoEl, Csolo, DeFecha,   Evento, FFeSig, "+;
			"FactMult,   FeFinMod, FeFinR, FeIniMod,    FechaDe, HoraDe2,  HrFinMod, HrIniMod, HrSig,   IDExterno, Isolo2, "+;
			"Modif,   Modif2, Modif3, Modif4,   ModifPor, NroAct, Objeto,   PAseg, Precio, Prestacion2,   Psolo, TA, UNOrg,   "+;
			"UOEnfSol, UOGes, Un,   Vale, cantinms, ctf,   episodio, feiniR, horade,   material, modif1, nroactual,   nroactual0,"+;
			" prestacion, uomedsol ) values "+;
			"( ?sap.Ahora, ?sap.Anulado,   ?sap.Asolo, ?sap.Cl, ?sap.Creado,   ?sap.CreadoEl, ?sap.Csolo, ?sap.DeFecha,  "+;
			" ?sap.Evento, ?sap.FFeSig, ?sap.FactMult,   ?sap.FeFinMod, ?sap.FeFinR, ?sap.FeIniMod,   ?sap.FechaDe,"+;
			" ?sap.HoraDe2,  ?sap.HrFinMod, ?sap.HrIniMod, ?sap.HrSig,   ?sap.IDExterno, ?sap.Isolo2, ?sap.Modif,  "+;
			" ?sap.Modif2, ?sap.Modif3, ?sap.Modif4,   ?sap.ModifPor, ?sap.NroAct, ?sap.Objeto,   ?sap.PAseg, ?sap.Precio, "+;
			"?sap.Prestacion2,   ?sap.Psolo, ?sap.TA, ?sap.UNOrg,   ?sap.UOEnfSol, ?sap.UOGes, ?sap.Un,   ?sap.Vale, ?sap.cantinms,"+;
			" ?sap.ctf,   ?sap.episodio, ?sap.feiniR, ?sap.horade,   ?sap.material, ?sap.modif1, ?sap.nroactual,   ?sap.nroactual0,"+;
			" ?sap.prestacion, ?sap.uomedsol)")
	Endif
Endscan

Set Step On
Do sp_desconexion
