**********************************************************************
* Program....: SP_GRABO_EPICOV19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 18 March 2020, 14:55:13
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: eTkachuk, Created 18 March 2020 / 14:55:13
* Purpose....: 		Insercion de datos a tabla de Zabfichepncov19 (Planilla Coronavirus nCOV19)
**********************************************************************

Parameters mf, myip

mrespuesta = .T.

mUse = mwkusuario.idusuario
mFec = sp_busco_fecha_serv('DT')

lcmdSQL = ''

TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7

		INSERT INTO Zabfichepncov19 (
		            COV_Registrac,
		            COV_Ocupacion,
					COV_Domicilio,
					COV_Telefono,
					COV_Pais,
					COV_ambulat ,
					COV_inisintoma ,
					COV_semanaepi ,
					COV_primconsulta ,
					COV_estabprimconsul ,
					COV_ambulat1 ,
					COV_internado ,
					COV_fechInterna ,
					COV_estabinternac ,
					COV_InternaUTI ,
					COV_fechInternaUti ,
					COV_requierearm ,
					COV_fiebremasmenos38 ,
					COV_taquipnea ,
					COV_diarrea ,
					COV_artalgias ,
					COV_malestargral ,
					COV_coma ,
					COV_tos ,
					COV_tiraje ,
					COV_vomitos ,
					COV_mialgias ,
					COV_rxneumonia ,
					COV_dolorgaganta ,
					COV_insufrespirat ,
					COV_dolorabdominal ,
					COV_cefalea ,
					COV_inyecconjuntival ,
					COV_odinofagia ,
					COV_dolortoracico ,
					COV_rechaaliemnt ,
					COV_irritabconfu ,
					COV_convulsiones ,
					COV_otrossint ,
					COV_enfermprev ,
					COV_inmunSupres ,
					COV_diabetes ,
					COV_obesidad ,
					COV_embarazo ,
					COV_puerperio ,
					COV_prematuridad ,
					COV_prematsemana ,
					COV_bajopesonac ,
					COV_bajopesogr ,
					COV_endfneurolog ,
					COV_enferpatica ,
					COV_enfrenal ,
					COV_hiparterial ,
					COV_insufcardiaca ,
					COV_enfoncologica ,
					COV_bronquiolitis ,
					COV_nac ,
					COV_epoc ,
					COV_asma ,
					COV_tuberculosis ,
					COV_ningunaant ,
					COV_otrosespec ,
					COV_fecAntibiot ,
					COV_resulencurso ,
  				    COV_resulterminado ,
					COV_fecAntiviral ,
					COV_antivencurso ,
					COV_antivterminado ,
					COV_estadorepencurso ,
					COV_estadorepnorecup ,
					COV_estadorepfallecido ,
					COV_estadorepfechafallec ,
					COV_diagsmegripal ,
					COV_diagbronquitis ,
					COV_diagneumonia ,
					COV_diagespecif ,
					COV_trabsalud ,
					COV_trablaborat ,
					COV_trabanimales ,
					COV_antvacunaAntigrip ,
					COV_fechavacuantigrip1 ,
					COV_antvacunaAntigrip2 ,
					COV_viajoresidio ,
					COV_viajoDonde ,
					COV_viajoDesde ,
					COV_viajohasta ,
					COV_viajoavion ,
					COV_viajobarco ,
					COV_viajoomnibus ,
					COV_fechaingresopais ,
					COV_companiaviaje ,
					COV_viajodentropais ,
					COV_dentropaisdonde ,
					COV_viajoresidioDesde ,
					COV_dentropaishasta ,
					COV_concasosconf ,
					COV_nomcentronCOV19 ,
					COV_ciudadcentronCOV19 ,
					COV_centroFechanCOV19 ,
					COV_Cerdos ,
					COV_contactoconaves ,
					COV_Camelidos ,
					COV_Contactomercados ,
					COV_ContactoOtros ,
					COV_EnntorFliar14Prev,
					COV_EntorLaboral14Prev,
					COV_EntorAsistencial14Prev,
					COV_ContacOtros14Prev,
					COV_ContactoCerc14Prev,
					COV_ContacPersoOtros ,
					COV_ContEstrechoNomApe ,
					COV_ContEstrechoDNI ,
					COV_ContEstrechoArea ,
					COV_MuesAspirado ,
					COV_MuesHisopado ,
					COV_MuesEstupo ,
					COV_MuesBronalv ,
					COV_MuestraOtro ,
					COV_MuestraFecha ,
					COV_MuestraFechaLNR ,
					NomApeNotifica,
					COV_zonriesgo2,
					COV_Anosmia,
					COV_Tabaquismo,
					COV_ExTabaquista,
                    COV_HisopaVigilan,
					COV_usuario, COV_fecmodifica, COV_ipadress )
		VALUES ( ?mf[01],
						?mf[02],
						?mf[03],
						?mf[04],
						?mf[128],
						?mf[09],
						?mf[05],
						?mf[06],
						?mf[07],
						?mf[08],
						?mf[09],
						?mf[10],
						?mf[11],
						?mf[115],
						?mf[12],
						?mf[13],
						?mf[14],
						?mf[15],
						?mf[19],
						?mf[23],
						?mf[27],
						?mf[31],
						?mf[34],
						?mf[16],
						?mf[20],
						?mf[24],
						?mf[28],
						?mf[32],
						?mf[17],
						?mf[21],
						?mf[25],
						?mf[29],
						?mf[33],
						?mf[18],
						?mf[22],
						?mf[26],
						?mf[30],
						?mf[116],
						?mf[35],
						?mf[36],
						?mf[37],
						?mf[41],
						?mf[46],
						?mf[50],
						?mf[54],
						?mf[57],
						?mf[58],
						?mf[44],
						?mf[45],
						?mf[38],
						?mf[42],
						?mf[47],
						?mf[51],
						?mf[55],
						?mf[39],
						?mf[40],
						?mf[43],
						?mf[48],
						?mf[52],
						?mf[56],
						?mf[53],
						?mf[60],
						?mf[61],
						?mf[49],
						?mf[64],
						?mf[117],
						?mf[65],
						?mf[66],
						?mf[67],
						?mf[68],
						?mf[69],
						?mf[62],
						?mf[70],
						?mf[71],
						?mf[72],
						?mf[63],
						?mf[80],
						?mf[85],
						?mf[84],
						?mf[74],
						?mf[98],
						?mf[99],
						?mf[118],
						?mf[103],
						?mf[95],
						?mf[96],
						?mf[81],
						?mf[82],
						?mf[83],
						?mf[97],
						?mf[88],
						?mf[120],
						?mf[89],
						?mf[92],
						?mf[93],
						?mf[119],
						?mf[100],
						?mf[87],
						?mf[94],
						?mf[77],
						?mf[75],
						?mf[76],
						?mf[123],
						?mf[101],
						?mf[78],
						?mf[79],
						?mf[124],
						?mf[91] ,
						?mf[121],
						?mf[129],
						?mf[86],
						?mf[90],
						?mf[102],
						?mf[108],
						?mf[109],
						?mf[122],
						?mf[107],
						?mf[111],
						?mf[113],
						?mf[112],
						?mf[114],
						?mf[104],
						?mf[125],
						?mf[126],
						?mf[127],
   			            ?mf[130],
						?mf[136],
						?mfec,
						?myip )
ENDTEXT

*-- Insercion de datos a la tabla
mret = SQLExec(mcon1, lcmdSQL, 'mwkTemp')

If mret > 0

   mret = SQLExec(mcon1,"SELECT id as lid FROM Zabfichepncov19 WHERE Cov_ipadress = ?myip "+;
      " AND COV_fecmodifica = ?mfec", "mwkedidat" )

   If mret > 0

      Select mwkedidat
      Go Top
      mvid = mwkedidat.lid

      If Reccount('mwkEpidemioCOV19Cont') > 0

         Select mwkEpidemioCOV19Cont
         Scan All

            m.NomApe	= mwkEpidemioCOV19Cont.Con_ApeNom
            m.DNI 	    = mwkEpidemioCOV19Cont.Con_Documento
            m.Telefono  = mwkEpidemioCOV19Cont.Con_Telefono
            m.Domicilio = mwkEpidemioCOV19Cont.Con_ContEstrechoDom
            m.FecUltimo = mwkEpidemioCOV19Cont.Con_ContEstrechoFecha
            m.Tipocont  = mwkEpidemioCOV19Cont.Con_contEstrechoTipo
            m.FechaPasiva = TTOD( mFec )
            m.Comentarios = ''


            mret = SQLExec(mcon1,"INSERT INTO ZabCov19Contacto "+;
               " (CON_Idplanilla, "+;
               "CON_ApeNom, "+;
               "CON_documento, "+;
               "CON_Telefono, CON_ContEstrechoDom, "+;
               "CON_ContEstrechoFecha, "+;
               "CON_ContEstrechoTipo, "+;
               "CON_FecPasiva ,"+;
               "CON_Comentarios) " +;
               " VALUES ( ?mvid, ?m.NomApe, ?m.DNI, ?m.Telefono , ?m.Domicilio, ?m.FecUltimo , ?m.Tipocont, ?m.FechaPasiva, ?m.Comentarios )")

            If mret < 0
               Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
               Messagebox("EN INCORPORACION DE CONTACTOS para nCOV19 " + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
               mrespuesta = .F.
            Endif

         Endscan

      Endif

   Else
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
      Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE F.EPIDEMIOLOGIA nCOV19 "+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
      Return .F.
   Endif

Else

   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox("EN REGISTRO DE F.EPIDEMIOLOGIA nCOV19 "+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
   mrespuesta = .F.

Endif





