*
* CD Reinternaciones
*
Lparameters mdesde, mhasta

Use In Select("mwkinfo")
Use In Select("mwkinfo1")
Use In Select("mwkinfo2")
Use In Select("mwkinfo3")
Use In Select("mwkinfo3a")
Use In Select("mwkinfo4")

mret = SQLExec(mcon1, "select TabCuiDomSoli.ID as lidsol,"+;
	" PAC_nombrepaciente,"+;
	" PAC_sectorinternac,"+;
	" PAC_habitacion,"+;
	" PAC_cama,"+;
	" PAC_fechaadmision,"+;
	" PAC_fechaalta,"+;
	" TabCiap2E.Descripcion as ldiagnos,"+;
	" TCS_patologia,"+;
	" Entidades.ENT_descrient as lentidad,"+;
	" PAC_tipopaciente, "+;
	" PAC_codhci,"+;
	" TCS_diagnos "+;
	" FROM TabCuiDomSoli"+;
	" Left join Entidades on Entidades.ENT_codent = TabCuiDomSoli.TCS_entidad"+;
	" Left join TabCiap2E on TabCiap2E.id = TabCuiDomSoli.TCS_diagnos"+;
	" Join PACIENTES on PACIENTES.PAC_codhci = TabCuiDomSoli.TCS_nroregistrac "+;
	" and PAC_fechaadmision >= ?mdesde and PAC_fechaadmision <= ?mhasta"+;
	" WHERE TCS_fecarga >= ?mdesde AND TCS_fecarga <= ?mhasta and TCS_estado <> 7","mwkinfo1")

If mret < 0
	mltabla = "CONSULTA CUIDADOS DOMICILIARIOS REINTERNACIONES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select lidsol, ;
	PAC_nombrepaciente, ;
	PAC_sectorinternac, ;
	PAC_habitacion, ;
	PAC_cama, ;
	NVL(PAC_fechaadmision,{//}) As PAC_fechaadmision, ;
	NVL(PAC_fechaalta,{//}) As PAC_fechaalta,;
	ldiagnos,;
	TCS_patologia,;
	lentidad,;
	PAC_tipopaciente,;
	PAC_codhci,;
	TCS_diagnos;
	FROM mwkinfo1;
	into Cursor mwkinfo2

mcalculo = mdesde - 365

mret = SQLExec(mcon1, "select TabCuiDomSoli.ID as lidsol,"+;
	" PAC_nombrepaciente,"+;
	" PAC_sectorinternac,"+;
	" PAC_habitacion,"+;
	" PAC_cama,"+;
	" PAC_fechaadmision,"+;
	" PAC_fechaalta,"+;
	" TabCiap2E.Descripcion as ldiagnos,"+;
	" TCS_patologia,"+;
	" Entidades.ENT_descrient as lentidad,"+;
	" PAC_tipopaciente, "+;
	" PAC_codhci,"+;
	" TCS_diagnos "+;
	" FROM TabCuiDomSoli"+;
	" Left join Entidades on Entidades.ENT_codent = TabCuiDomSoli.TCS_entidad"+;
	" Left join TabCiap2E on TabCiap2E.id = TabCuiDomSoli.TCS_diagnos"+;
	" Join PACIENTES on PACIENTES.PAC_codhci = TabCuiDomSoli.TCS_nroregistrac "+;
	" and PAC_fechaadmision > ?mcalculo and PAC_fechaadmision < ?mdesde "+;
	" WHERE TCS_fecarga >= ?mdesde AND TCS_fecarga <= ?mhasta and TCS_estado <> 7","mwkinfo3")

If mret < 0
	mltabla = "CONSULTA CUIDADOS DOMICILIARIOS REINTERNACIONES"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

select * FROM mwkinfo3 WHERE lidsol in (SELECT lidsol FROM mwkinfo2) INTO CURSOR mwkinfo3a

Select lidsol, ;
	PAC_nombrepaciente, ;
	PAC_sectorinternac, ;
	PAC_habitacion, ;
	PAC_cama, ;
	NVL(PAC_fechaadmision,{//}) As PAC_fechaadmision, ;
	NVL(PAC_fechaalta,{//}) As PAC_fechaalta,;
	ldiagnos,;
	TCS_patologia,;
	lentidad,;
	PAC_tipopaciente,;
	PAC_codhci,;
	TCS_diagnos;
	FROM mwkinfo3a;
	GROUP By lidsol ;
	into Cursor mwkinfo4

Select * From mwkinfo2 Union Select * From mwkinfo4 ORDER BY lidsol, pac_fechaadmision Into Cursor mwkinfo

Use In Select("mwkinfo1")
Use In Select("mwkinfo2")
Use In Select("mwkinfo3")
Use In Select("mwkinfo3a")
Use In Select("mwkinfo4")

Return .T.









