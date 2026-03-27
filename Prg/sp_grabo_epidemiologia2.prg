*
* Ingreso FICHA EPIDEMILOGIA
*
Lparameters mf, mf2

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

*!*	mret = sqlexec(mcon1,"insert into TabFichEp2"+;
*!*		"(FE_proto,FE_domlab,FE_telab,FE_tuvodeng,FE_cuando,FE_serotipo,FE_vivedes,FE_viajo,FE_lugarvia,"+;
*!*		"FE_regreso,FE_contacto,FE_lugarcon,FE_vacufieb,FE_vacufec,FE_hemato,FE_blarecu,FE_plarecu,"+;
*!*		"FE_pruetorni,FE_embarazo,FE_gestacion,FE_fecsintoma,FE_feconsulta,FE_atencion,FE_internado,"+;
*!*		"FE_evolucion,FE_fecprimues,FE_pcr,FE_igm,FE_tomasegmue,FE_segresu,FE_segserot,FE_realizado,"+;
*!*		"FE_otramues,FE_clasifica,FE_causa,FE_usuario,FE_ipadress,FE_fecmodifica)"+;
*!*		" values ("+;
*!*		"?mf[01],?mf[02],?mf[03],?mf[04],?mf[05],?mf[06],?mf[07],?mf[08],?mf[09],?mf[10],?mf[11],?mf[12],"+;
*!*		"?mf[13],?mf[14],?mf[15],?mf[16],?mf[17],?mf[18],?mf[19],?mf[20],?mf[21],?mf[22],?mf[23],?mf[24],"+;
*!*		"?mf[25],?mf[26],?mf[27],?mf[28],?mf[29],?mf[30],?mf[31],?mf[32],?mf[33],?mf[34],?mf[35],?muse,?myip,?mfec)")

mret = SQLExec(mcon1,"insert into TabFichEp2 "+;
	"(FE_proto,FE_domlab,FE_telab,FE_tdengue,FE_tchikun,FE_tzika,FE_tfamarilla,FE_tno,FE_tnosabe,"+;
	"FE_cuando,FE_viajo,FE_lugarvia,FE_regreso,FE_salida,FE_contacto,FE_crchikun,"+;
	"FE_crzika,FE_crfamarilla,FE_crtno,FE_crnosabe,FE_crimosq,FE_tiprep,FE_vacufieb,"+;
	"FE_vacufec,FE_tvertical,FE_transfusiones,FE_donosangre,FE_dondedono,FE_comorno,FE_obesidad,"+;
	"FE_dbt,FE_cardio,FE_inmuno,FE_edadm3,FE_edad70,FE_comorotr,"+;
	"FE_embarazo,FE_gestacion,FE_riesgosoc,FE_vivesol,FE_difahospital,FE_probrext,FE_riesgotr,"+;
	"FE_sospdengue,FE_sospchikun,FE_sospzika,FE_sospfamarilla,FE_sospotros,FE_sospotrtxt,"+;
	"FE_pruetorni,FE_hemato,FE_blarecu,FE_gbformula,FE_plarecu,FE_bilirrubina,FE_transaminasas,"+;
	"FE_internado,FE_fecsintoma,FE_atencion,FE_integral,FE_inteuti,FE_mues1fec,FE_mues1tec,FE_mues1res,"+;
	"FE_mues2fec,FE_mues2tec,FE_mues2res,FE_mues3fec,FE_mues3tec,FE_mues3res,FE_otrfec,FE_otrtec,FE_otrres,"+;
	"FE_complica,FE_compcual,FE_fechalta,FE_curado,FE_secuela,FE_seccual,FE_fallecio,FE_derivado,FE_clasifica,FE_causa,"+;
	"FE_salarma,FE_dolabdo,FE_dseroso,FE_vomitoper,FE_smucosa,FE_sirrita,"+;
	"FE_hepatog,FE_incrhto,FE_incrhton,FE_displaq,FE_displaqn,"+;
	"FE_dengrave,FE_shockhipo,FE_distress,FE_sangrave,FE_danorgimp,FE_finifiebre,FE_fconsulta,"+;
	"FE_usuario,FE_ipadress ,FE_fecmodifica)"+;
	" values ("+;
	"?mf[01],?mf[02],?mf[03],?mf[04],?mf[05],?mf[06],?mf[07],?mf[08],?mf[09],?mf[10],?mf[11],?mf[12],"+;
	"?mf[13],?mf[14],?mf[15],?mf[16],?mf[17],?mf[18],?mf[19],?mf[20],?mf[21],?mf[22],?mf[23],"+;
	"?mf[25],?mf[26],?mf[27],?mf[28],?mf[29],?mf[30],?mf[31],?mf[32],?mf[33],?mf[34],?mf[35],"+;
	"?mf[36],?mf[37],?mf[38],?mf[39],?mf[40],?mf[41],?mf[42],?mf[43],?mf[44],"+;
	"?mf[45],?mf[46],?mf[47],?mf[48],?mf[49],?mf[50],?mf[51],?mf[52],?mf[53],?mf[54],"+;
	"?mf[55],?mf[56],?mf[57],?mf[58],?mf[59],?mf[60],?mf[61],?mf[62],?mf[63],?mf[64],"+;
	"?mf[65],?mf[66],?mf[67],?mf[68],?mf[69],?mf[70],?mf[71],?mf[72],?mf[73],?mf[74],"+;
	"?mf[75],?mf[76],?mf[77],?mf[78],?mf[79],?mf[80],?mf[81],?mf[82],?mf[83],?mf[84],"+;
	"?mf[85],?mf[86],?mf[87],?mf[88],?mf[89],?mf[90],?mf[91],?mf[92],?mf[93],"+;
	"?mf[94],?mf[95],?mf[96],?mf[97],?mf[98],?mf[99],?mf[100],?mf[101],?mf[102],"+;
	"?muse,?myip,?mfec)")

If mret > 0
	If Used('mwkedidat')
		Use In mwkedidat
	Endif

	mret = SQLExec(mcon1,"select id as lid from TabFichEp2 where FE_usuario=?muse and FE_ipadress=?myip"+;
		" and FE_fecmodifica=?mfec","mwkedidat")

	If mret > 0

		Select mwkedidat
		Go Top
		mvid = mwkedidat.lid
*!*			mret = SQLExec(mcon1,"insert into TabFichEpSin "+;
*!*				"(FES_idfich,FES_mialgia,FES_fmialgia,FES_astralgia,FES_fastralgia,FES_rash,FES_frash,FES_petequias,"+;
*!*				"FES_fpetequias,FES_hmogas,FES_fhmogas,FES_otrosig,FES_fotrosig,FES_nauseas,FES_fnauseas,FES_diarrea,"+;
*!*				"FES_fdiarrea,FES_dolab,FES_fdolab,FES_hepato,FES_fhepato,FES_adenop,FES_fadenop,FES_shock,FES_fshock,"+;
*!*				"FES_ulor,FES_fulor, FES_estomatitis, FES_festomatitis, FES_astenia, FES_fastenia, FES_gb, FES_fgb,"+;
*!*				"FES_malcon, FES_fmalcon, FES_brarel, FES_fbrarel"+;
*!*				")"+;
*!*				" values "+;
*!*				"(?mvid,?mf2[1,1],?mf2[1,2],?mf2[2,1],?mf2[2,2],?mf2[3,1],?mf2[3,2],?mf2[4,1],?mf2[4,2],?mf2[5,1],?mf2[5,2],"+;
*!*				"?mf2[6,1],?mf2[6,2],?mf2[7,1],?mf2[7,2],?mf2[8,1],?mf2[8,2],?mf2[9,1],?mf2[9,2],?mf2[10,1],?mf2[10,2],"+;
*!*				"?mf2[11,1],?mf2[11,2],?mf2[12,1],?mf2[12,2],"+;
*!*				"?mf2[13,1],?mf2[13,2],?mf2[14,1],?mf2[14,2],"+;
*!*				"?mf2[15,1],?mf2[15,2],?mf2[16,1],?mf2[16,2],"+;
*!*				"?mf2[17,1],?mf2[17,2],?mf2[18,1],?mf2[18,2])")


		mret = SQLExec(mcon1,"insert into TabFichEpSin2 "+;
			"(FES_idfich,"+;
			"FES_c01,FES_fc01,"+;
			"FES_c02,FES_fc02,"+;
			"FES_c03,FES_fc03,"+;
			"FES_c04,FES_fc04,"+;
			"FES_c05,FES_fc05,"+;
			"FES_c06,FES_fc06,"+;
			"FES_c07,FES_fc07,"+;
			"FES_c08,FES_fc08,"+;
			"FES_c09,FES_fc09,"+;
			"FES_c10,FES_fc10,"+;
			"FES_c11,FES_fc11,"+;
			"FES_c12,FES_fc12,"+;
			"FES_c13,FES_fc13,"+;
			"FES_c14,FES_fc14,"+;
			"FES_c15,FES_fc15,"+;
			"FES_c16,FES_fc16,"+;
			"FES_c17,FES_fc17,"+;
			"FES_c18,FES_fc18,"+;
			"FES_c19,FES_fc19,"+;
			"FES_c20,FES_fc20,"+;
			"FES_c21,FES_fc21,"+;
			"FES_c22,FES_fc22,"+;
			"FES_c23,FES_fc23,"+;
			"FES_c24,FES_fc24,"+;
			"FES_c25,FES_fc25,"+;
			"FES_c26,FES_fc26,"+;
			"FES_c27,FES_fc27,"+;
			"FES_c28,FES_fc28,"+;
			"FES_c29,FES_fc29,"+;
			"FES_c30,FES_fc30,"+;
			"FES_c31,FES_fc31,"+;
			"FES_c32,FES_fc32,"+;
			"FES_c33,FES_fc33,"+;
			"FES_c34,FES_fc34,"+;
			"FES_c35,FES_fc35,"+;
			"FES_c36,FES_fc36,"+;
			"FES_c37,FES_fc37,"+;
			"FES_c38,FES_fc38"+;
			")"+;
			" values "+;
			"(?mvid,?mf2[1,1],?mf2[1,2],?mf2[2,1],?mf2[2,2],?mf2[3,1],?mf2[3,2],?mf2[4,1],?mf2[4,2],?mf2[5,1],?mf2[5,2],"+;
			"?mf2[6,1] ,?mf2[6,2] ,?mf2[7,1] ,?mf2[7,2],?mf2[8,1],?mf2[8,2],?mf2[9,1],?mf2[9,2],?mf2[10,1],?mf2[10,2],"+;
			"?mf2[11,1],?mf2[11,2],?mf2[12,1],?mf2[12,2],"+;
			"?mf2[13,1],?mf2[13,2],?mf2[14,1],?mf2[14,2],"+;
			"?mf2[15,1],?mf2[15,2],?mf2[16,1],?mf2[16,2],"+;
			"?mf2[17,1],?mf2[17,2],?mf2[18,1],?mf2[18,2],"+;
			"?mf2[19,1],?mf2[19,2],?mf2[20,1],?mf2[20,2],"+;
			"?mf2[21,1],?mf2[21,2],?mf2[22,1],?mf2[22,2],"+;
			"?mf2[23,1],?mf2[23,2],?mf2[24,1],?mf2[24,2],"+;
			"?mf2[25,1],?mf2[25,2],?mf2[26,1],?mf2[26,2],"+;
			"?mf2[27,1],?mf2[27,2],?mf2[28,1],?mf2[28,2],"+;
			"?mf2[29,1],?mf2[29,2],?mf2[30,1],?mf2[30,2],"+;
			"?mf2[31,1],?mf2[31,2],?mf2[32,1],?mf2[32,2],"+;
			"?mf2[33,1],?mf2[33,2],?mf2[34,1],?mf2[34,2],"+;
			"?mf2[35,1],?mf2[35,2],?mf2[36,1],?mf2[36,2],"+;
			"?mf2[37,1],?mf2[37,2],?mf2[38,1],?mf2[38,2])")

		If mret < 0
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN INGRESO DE SINTOMAS FICHA EPIDEMIOLOGICA - DENGUE"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")

		Endif
	Else
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN CONSULTA DE FICHA EPIDEMIOLOGICA - DENGUE"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")

	Endif

Else
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN INCORPORACION DE FICHA EPIDEMIOLOGICA - DENGUE"+Chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

Return

