*
* Actualizacion de Ficha Epidemiologica & Sintomas - DENGUE
*
Lparameters mf, mf2

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

mret = SQLExec(mcon1,"update TabFichEp2 set "+;
	"FE_domlab        = ?mf[02],"+;
	"FE_telab         = ?mf[03],"+;
	"FE_tdengue       = ?mf[04],"+;
	"FE_tchikun       = ?mf[05],"+;
	"FE_tzika         = ?mf[06],"+;
	"FE_tfamarilla    = ?mf[07],"+;
	"FE_tno           = ?mf[08],"+;
	"FE_tnosabe       = ?mf[09],"+;
	"FE_cuando        = ?mf[10],"+;
	"FE_viajo         = ?mf[11],"+;
	"FE_lugarvia      = ?mf[12],"+;
	"FE_regreso       = ?mf[13],"+;
	"FE_salida        = ?mf[14],"+;
	"FE_contacto      = ?mf[15],"+;
	"FE_crchikun      = ?mf[16],"+;
	"FE_crzika        = ?mf[17],"+;
	"FE_crfamarilla   = ?mf[18],"+;
	"FE_crtno         = ?mf[19],"+;
	"FE_crnosabe      = ?mf[20],"+;
	"FE_crimosq       = ?mf[21],"+;
	"FE_tiprep        = ?mf[22],"+;
	"FE_vacufieb      = ?mf[23],"+;
	"FE_vacufec       = ?mf[25],"+;
	"FE_tvertical     = ?mf[26],"+;
	"FE_transfusiones = ?mf[27],"+;
	"FE_donosangre    = ?mf[28],"+;
	"FE_dondedono     = ?mf[29],"+;
	"FE_comorno       = ?mf[30],"+;
	"FE_obesidad      = ?mf[31],"+;
	"FE_dbt           = ?mf[32],"+;
	"FE_cardio        = ?mf[33],"+;
	"FE_inmuno        = ?mf[34],"+;
	"FE_edadm3        = ?mf[35],"+;
	"FE_edad70        = ?mf[36],"+;
	"FE_comorotr      = ?mf[37],"+;
	"FE_embarazo      = ?mf[38],"+;
	"FE_gestacion     = ?mf[39],"+;
	"FE_riesgosoc     = ?mf[40],"+;
	"FE_vivesol       = ?mf[41],"+;
	"FE_difahospital  = ?mf[42],"+;
	"FE_probrext      = ?mf[43],"+;
	"FE_riesgotr      = ?mf[44],"+;
	"FE_sospdengue    = ?mf[45],"+;
	"FE_sospchikun    = ?mf[46],"+;
	"FE_sospzika      = ?mf[47],"+;
	"FE_sospfamarilla = ?mf[48],"+;
	"FE_sospotros     = ?mf[49],"+;
	"FE_sospotrtxt    = ?mf[50],"+;
	"FE_pruetorni     = ?mf[51],"+;
	"FE_hemato        = ?mf[52],"+;
	"FE_blarecu       = ?mf[53],"+;
	"FE_gbformula     = ?mf[54],"+;
	"FE_plarecu       = ?mf[55],"+;
	"FE_bilirrubina   = ?mf[56],"+;
	"FE_transaminasas = ?mf[57],"+;
	"FE_internado     = ?mf[58],"+;
	"FE_fecsintoma    = ?mf[59],"+;
	"FE_atencion      = ?mf[60],"+;
	"FE_integral      = ?mf[61],"+;
	"FE_inteuti       = ?mf[62],"+;
	"FE_mues1fec      = ?mf[63],"+;
	"FE_mues1tec      = ?mf[64],"+;
	"FE_mues1res      = ?mf[65],"+;
	"FE_mues2fec      = ?mf[66],"+;
	"FE_mues2tec      = ?mf[67],"+;
	"FE_mues2res      = ?mf[68],"+;
	"FE_mues3fec      = ?mf[69],"+;
	"FE_mues3tec      = ?mf[70],"+;
	"FE_mues3res      = ?mf[71],"+;
	"FE_otrfec        = ?mf[72],"+;
	"FE_otrtec        = ?mf[73],"+;
	"FE_otrres        = ?mf[74],"+;
	"FE_complica      = ?mf[75],"+;
	"FE_compcual      = ?mf[76],"+;
	"FE_fechalta      = ?mf[77],"+;
	"FE_curado        = ?mf[78],"+;
	"FE_secuela       = ?mf[79],"+;
	"FE_seccual       = ?mf[80],"+;
	"FE_fallecio      = ?mf[81],"+;
	"FE_derivado      = ?mf[82],"+;
	"FE_clasifica     = ?mf[83],"+;
	"FE_causa         = ?mf[84],"+;
	"FE_salarma       = ?mf[85],"+;
	"FE_dolabdo       = ?mf[86],"+;
	"FE_dseroso       = ?mf[87],"+;
	"FE_vomitoper     = ?mf[88],"+;
	"FE_smucosa       = ?mf[89],"+;
	"FE_sirrita       = ?mf[90],"+;
	"FE_hepatog       = ?mf[91],"+;
	"FE_incrhto       = ?mf[92],"+;
	"FE_incrhton      = ?mf[93],"+;
	"FE_displaq       = ?mf[94],"+;
	"FE_displaqn      = ?mf[95],"+;
	"FE_dengrave      = ?mf[96],"+;
	"FE_shockhipo     = ?mf[97],"+;
	"FE_distress      = ?mf[98],"+;
	"FE_sangrave      = ?mf[99],"+;
	"FE_danorgimp     = ?mf[100],"+;
	"FE_finifiebre    = ?mf[101],"+;
	"FE_fconsulta     = ?mf[102],"+;
	"FE_usuario       = ?muse,"+;
	"FE_ipadress      = ?myip,"+;
	"FE_fecmodifica   = ?mfec"+;
	" where FE_proto = ?mf[01]")

If mret > 0

	Use In Select("mwkedidat")
	mret = SQLExec(mcon1,"select id as lid from TabFichEp2 where FE_usuario = ?muse and FE_ipadress = ?myip and FE_fecmodifica = ?mfec","mwkedidat")

	If mret > 0

		Select mwkedidat
		Go Top
		mvid = mwkedidat.lid

		Use In Select("mwkctrlexis")
		mret = SQLExec(mcon1,"select * from TabFichEpSin2 where FES_idfich = ?mvid","mwkctrlexis")

		If mret > 0
			If Used("mwkctrlexis")
				If Reccount("mwkctrlexis") > 0

					mret = SQLExec(mcon1,"update TabFichEpSin2 set "+;
						" FES_c01  = ?mf2[1,1]"+;
						",FES_fc01 = " + Iif(mf2[1,2]={//} ,"1900-01-01", "?mf2[1,2]")+;
						",FES_c02  = ?mf2[2,1]"+;
						",FES_fc02 = " + Iif(mf2[2,2]={//} ,"1900-01-01", "?mf2[2,2]")+;
						",FES_c03  = ?mf2[3,1]"+;
						",FES_fc03 = " + Iif(mf2[3,2]={//} ,"1900-01-01", "?mf2[3,2]")+;
						",FES_c04  = ?mf2[4,1]"+;
						",FES_fc04 = " + Iif(mf2[4,2]={//} ,"1900-01-01", "?mf2[4,2]")+;
						",FES_c05  = ?mf2[5,1]"+;
						",FES_fc05 = " + Iif(mf2[5,2]={//} ,"1900-01-01", "?mf2[5,2]")+;
						",FES_c06  = ?mf2[6,1]"+;
						",FES_fc06 = " + Iif(mf2[6,2]={//} ,"1900-01-01", "?mf2[6,2]")+;
						",FES_c07  = ?mf2[7,1]"+;
						",FES_fc07 = " + Iif(mf2[7,2]={//} ,"1900-01-01", "?mf2[7,2]")+;
						",FES_c08  = ?mf2[8,1]"+;
						",FES_fc08 = " + Iif(mf2[8,2]={//} ,"1900-01-01", "?mf2[8,2]")+;
						",FES_c09  = ?mf2[9,1]"+;
						",FES_fc09 = " + Iif(mf2[9,2]={//} ,"1900-01-01", "?mf2[9,2]")+;
						",FES_c10  = ?mf2[10,1]"+;
						",FES_fc10 = " + Iif(mf2[10,2]={//},"1900-01-01", "?mf2[10,2]")+;
						",FES_c11  = ?mf2[11,1]"+;
						",FES_fc11 = " + Iif(mf2[11,2]={//} ,"1900-01-01", "?mf2[11,2]")+;
						",FES_c12  = ?mf2[12,1]"+;
						",FES_fc12 = " + Iif(mf2[12,2]={//} ,"1900-01-01", "?mf2[12,2]")+;
						",FES_c13  = ?mf2[13,1]"+;
						",FES_fc13 = " + Iif(mf2[13,2]={//} ,"1900-01-01", "?mf2[13,2]")+;
						",FES_c14  = ?mf2[14,1]"+;
						",FES_fc14 = " + Iif(mf2[14,2]={//} ,"1900-01-01", "?mf2[14,2]")+;
						",FES_c15  = ?mf2[15,1]"+;
						",FES_fc15 = " + Iif(mf2[15,2]={//} ,"1900-01-01", "?mf2[15,2]")+;
						",FES_c16  = ?mf2[16,1]"+;
						",FES_fc16 = " + Iif(mf2[16,2]={//} ,"1900-01-01", "?mf2[16,2]")+;
						",FES_c17  = ?mf2[17,1]"+;
						",FES_fc17 = " + Iif(mf2[17,2]={//} ,"1900-01-01", "?mf2[17,2]")+;
						",FES_c18  = ?mf2[18,1]"+;
						",FES_fc18 = " + Iif(mf2[18,2]={//} ,"1900-01-01", "?mf2[18,2]")+;
						",FES_c19  = ?mf2[19,1]"+;
						",FES_fc19 = " + Iif(mf2[19,2]={//} ,"1900-01-01", "?mf2[19,2]")+;
						",FES_c20  = ?mf2[20,1]"+;
						",FES_fc20 = " + Iif(mf2[20,2]={//},"1900-01-01", "?mf2[20,2]")+;
						",FES_c21  = ?mf2[21,1]"+;
						",FES_fc21 = " + Iif(mf2[21,2]={//} ,"1900-01-01", "?mf2[21,2]")+;
						",FES_c22  = ?mf2[22,1]"+;
						",FES_fc22 = " + Iif(mf2[22,2]={//} ,"1900-01-01", "?mf2[22,2]")+;
						",FES_c23  = ?mf2[23,1]"+;
						",FES_fc23 = " + Iif(mf2[23,2]={//} ,"1900-01-01", "?mf2[23,2]")+;
						",FES_c24  = ?mf2[24,1]"+;
						",FES_fc24 = " + Iif(mf2[24,2]={//} ,"1900-01-01", "?mf2[24,2]")+;
						",FES_c25  = ?mf2[25,1]"+;
						",FES_fc25 = " + Iif(mf2[25,2]={//} ,"1900-01-01", "?mf2[25,2]")+;
						",FES_c26  = ?mf2[26,1]"+;
						",FES_fc26 = " + Iif(mf2[26,2]={//} ,"1900-01-01", "?mf2[26,2]")+;
						",FES_c27  = ?mf2[27,1]"+;
						",FES_fc27 = " + Iif(mf2[27,2]={//} ,"1900-01-01", "?mf2[27,2]")+;
						",FES_c28  = ?mf2[28,1]"+;
						",FES_fc28 = " + Iif(mf2[28,2]={//} ,"1900-01-01", "?mf2[28,2]")+;
						",FES_c29  = ?mf2[29,1]"+;
						",FES_fc29 = " + Iif(mf2[29,2]={//} ,"1900-01-01", "?mf2[29,2]")+;
						",FES_c30  = ?mf2[30,1]"+;
						",FES_fc30 = " + Iif(mf2[30,2]={//},"1900-01-01" , "?mf2[30,2]")+;
						",FES_c31  = ?mf2[31,1]"+;
						",FES_fc31 = " + Iif(mf2[31,2]={//} ,"1900-01-01", "?mf2[31,2]")+;
						",FES_c32  = ?mf2[32,1]"+;
						",FES_fc32 = " + Iif(mf2[32,2]={//} ,"1900-01-01", "?mf2[32,2]")+;
						",FES_c33  = ?mf2[33,1]"+;
						",FES_fc33 = " + Iif(mf2[33,2]={//} ,"1900-01-01", "?mf2[33,2]")+;
						",FES_c34  = ?mf2[34,1]"+;
						",FES_fc34 = " + Iif(mf2[34,2]={//} ,"1900-01-01", "?mf2[34,2]")+;
						",FES_c35  = ?mf2[35,1]"+;
						",FES_fc35 = " + Iif(mf2[35,2]={//} ,"1900-01-01", "?mf2[35,2]")+;
						",FES_c36  = ?mf2[36,1]"+;
						",FES_fc36 = " + Iif(mf2[36,2]={//} ,"1900-01-01", "?mf2[36,2]")+;
						",FES_c37  = ?mf2[37,1]"+;
						",FES_fc37 = " + Iif(mf2[37,2]={//} ,"1900-01-01", "?mf2[37,2]")+;
						",FES_c38  = ?mf2[38,1]"+;
						",FES_fc38 = " + Iif(mf2[38,2]={//},"1900-01-01" , "?mf2[38,2]")+;
						" where FES_idfich = ?mvid")

				Else

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
						"?mf2[19,1],?mf2[19,2],?mf2[20,1],?mf2[20,2],?mf2[21,1],?mf2[21,2],"+;
						"?mf2[22,1],?mf2[22,2],?mf2[23,1],?mf2[23,2],"+;
						"?mf2[24,1],?mf2[24,2],?mf2[25,1],?mf2[25,2],"+;
						"?mf2[26,1],?mf2[26,2],?mf2[27,1],?mf2[27,2],"+;
						"?mf2[28,1],?mf2[28,2],?mf2[29,1],?mf2[29,2],"+;
						"?mf2[30,1],?mf2[30,2],?mf2[31,1],?mf2[31,2],"+;
						"?mf2[32,1],?mf2[32,2],?mf2[33,1],?mf2[33,2],"+;
						"?mf2[34,1],?mf2[34,2],?mf2[35,1],?mf2[35,2],"+;
						"?mf2[36,1],?mf2[36,2],?mf2[37,1],?mf2[37,2],"+;
						"?mf2[38,1],?mf2[38,2])")


				Endif

				If mret < 0
				
					Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Messagebox("EN ACTUALIZACION DE IDENTIFICADOR DE FICHA EPIDEMIOLOGIA, SINTOMAS - DENGUE -"+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
					
						
				Endif

			Endif

			Use In Select("mwkctrlexis")

		Else

			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

			Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE FICHA EPIDEMIOLOGIA - DENGUE -"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif

	Else
		mpaso = .F.

		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

		Messagebox("EN ACTUALIZACION DE FICHA EPIDEMIOLOGIA - DENGUE"+Chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif
Endif
Return


*!*			mret = SQLExec(mcon1,"update TabFichEpSin set "+;
*!*				" FES_mialgia      = ?mf2[1,1]"+;
*!*				",FES_fmialgia     = "+Iif(mf2[1,2]={//} ,"1900-01-01", "?mf2[1,2]")+;
*!*				",FES_astralgia    = ?mf2[2,1]"+;
*!*				",FES_fastralgia   = "+Iif(mf2[2,2]={//} ,"1900-01-01", "?mf2[2,2]")+;
*!*				",FES_rash         = ?mf2[3,1]"+;
*!*				",FES_frash        = "+Iif(mf2[3,2]={//} ,"1900-01-01", "?mf2[3,2]")+;
*!*				",FES_petequias    = ?mf2[4,1]"+;
*!*				",FES_fpetequias   = "+Iif(mf2[4,2]={//} ,"1900-01-01", "?mf2[4,2]")+;
*!*				",FES_hmogas       = ?mf2[5,1]"+;
*!*				",FES_fhmogas      = "+Iif(mf2[5,2]={//} ,"1900-01-01", "?mf2[5,2]")+;
*!*				",FES_otrosig      = ?mf2[6,1]"+;
*!*				",FES_fotrosig     = "+Iif(mf2[6,2]={//} ,"1900-01-01", "?mf2[6,2]")+;
*!*				",FES_nauseas      = ?mf2[7,1]"+;
*!*				",FES_fnauseas     = "+Iif(mf2[7,2]={//} ,"1900-01-01", "?mf2[7,2]")+;
*!*				",FES_diarrea      = ?mf2[8,1]"+;
*!*				",FES_fdiarrea     = "+Iif(mf2[8,2]={//} ,"1900-01-01", "?mf2[8,2]")+;
*!*				",FES_dolab        = ?mf2[9,1]"+;
*!*				",FES_fdolab       = "+Iif(mf2[9,2]={//} ,"1900-01-01", "?mf2[9,2]")+;
*!*				",FES_hepato       = ?mf2[10,1]"+;
*!*				",FES_fhepato      = "+Iif(mf2[10,2]={//},"1900-01-01","?mf2[10,2]")+;
*!*				",FES_adenop       = ?mf2[11,1]"+;
*!*				",FES_fadenop      = "+Iif(mf2[11,2]={//},"1900-01-01","?mf2[11,2]")+;
*!*				",FES_shock        = ?mf2[12,1]"+;
*!*				",FES_fshock       = "+Iif(mf2[12,2]={//},"1900-01-01","?mf2[12,2]")+;
*!*				",FES_ulor         = ?mf2[13,1]"+;
*!*				",FES_fulor        = "+Iif(mf2[13,2]={//},"1900-01-01","?mf2[13,2]")+;
*!*				",FES_estomatitis  = ?mf2[14,1]"+;
*!*				",FES_festomatitis = "+Iif(mf2[14,2]={//},"1900-01-01","?mf2[14,2]")+;
*!*				",FES_astenia      = ?mf2[15,1]"+;
*!*				",FES_fastenia     = "+Iif(mf2[15,2]={//},"1900-01-01","?mf2[15,2]")+;
*!*				",FES_gb           = ?mf2[16,1]"+;
*!*				",FES_fgb          = "+Iif(mf2[16,2]={//},"1900-01-01","?mf2[16,2]")+;
*!*				",FES_malcon       = ?mf2[17,1]"+;
*!*				",FES_fmalcon      = "+Iif(mf2[17,2]={//},"1900-01-01","?mf2[17,2]")+;
*!*				",FES_brarel       = ?mf2[18,1]"+;
*!*				",FES_fbrarel      = "+Iif(mf2[18,2]={//},"1900-01-01","?mf2[18,2]")+;
*!*				" where FES_idfich = ?mvid")
