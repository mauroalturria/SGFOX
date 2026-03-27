**********************************************************************
* Program....: SP_GRABO_EPICOV19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 18 March 2020, 14:55:13
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 18 March 2020 / 14:55:13
* Purpose....: 		Insercion de datos a tabla de Zabfichepncov19 (Planilla Coronavirus nCOV19)
**********************************************************************
parameters mf, myip

mrespuesta = .T.

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

*Set Step On

lcmdSQL = ''

TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7

		INSERT INTO Zabfichepncov19 (
		            COV_Registrac,
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
					COV_usuario,COV_fecmodifica,COV_ipadress)
		VALUES ( ?mf[01], ?mf[09], ?mf[05], ?mf[06], ?mf[07],
		         ?mf[08], ?mf[09], ?mf[10], ?mf[11], ?mf[115],
				 ?mf[12], ?mf[13], ?mf[14], ?mf[15], ?mf[19],
                 ?mf[23], ?mf[27], ?mf[31], ?mf[34], ?mf[16],
				 ?mf[20], ?mf[24], ?mf[28], ?mf[32], ?mf[17],
				 ?mf[21], ?mf[25], ?mf[29], ?mf[33], ?mf[18],
				 ?mf[22], ?mf[26], ?mf[30], ?mf[116],?mf[35],
                 ?mf[36], ?mf[37], ?mf[41], ?mf[56], ?mf[50],
				 ?mf[54], ?mf[57], ?mf[58], ?mf[44], ?mf[45],
				 ?mf[38], ?mf[42], ?mf[47], ?mf[51], ?mf[55],
				 ?mf[39], ?mf[40], ?mf[43], ?mf[48], ?mf[52],
				 ?mf[56], ?mf[53], ?mf[60], ?mf[61], ?mf[49],
				 ?mf[64], ?mf[117],?mf[65], ?mf[66], ?mf[67],
				 ?mf[68], ?mf[69], ?mf[62], ?mf[70], ?mf[71],
				 ?mf[72], ?mf[63], ?mf[80], ?mf[79], ?mf[84],
				 ?mf[74], ?mf[98], ?mf[99],?mf[118],?mf[104],
				 ?mf[95], ?mf[96], ?mf[81], ?mf[82], ?mf[83],
				 ?mf[97], ?mf[88], ?mf[120],?mf[89],
				 ?mf[92], ?mf[93], ?mf[119],?mf[100],?mf[87],
				 ?mf[94], ?mf[77], ?mf[75], ?mf[76],?mf[123],
				 ?mf[101],
				 ?mf[121],?mf[86], ?mf[90],?mf[102],?mf[108],
				 ?mf[109], ?mf[122], ?mf[107], ?mf[110], ?mf[113],
				 ?mf[112], ?mf[114],	?mf[104],?muse,?mfec,?myip)
ENDTEXT

*-- Insercion de datos a la tabla

mret = SQLExec(mcon1, lcmdSQL, 'mwkTemp')

If mret > 0

	mret = SQLExec(mcon1,"select id as lid from Zabfichepncov19  where COV_usuario=?muse and Cov_ipadress=?myip"+;
		" and COV_fecmodifica=?mfec","mwkedidat")

	If mret > 0

		Select mwkedidat
		Go Top
		mvid = mwkedidat.lid

		If Reccount('mwkContactoPersonas') > 0

			Select mwkContactoPersonas
			Go Top

			Scan All

				m.NomApe	= mwkContactoPersonas.cApellidoNombre
				m.DNI 	    = mwkContactoPersonas.cDni
				m.Telefono  = mwkContactoPersonas.cTelefono
				m.Domicilio = mwkContactoPersonas.cDomicilio
				m.FecUltimo = mwkContactoPersonas.dFechaUltimoContac
				m.Tipocont  = mwkContactoPersonas.cTipo
				m.Comentarios = ''

				mret = SQLExec(mcon1,"INSERT INTO ZabCov19Contacto "+;
					" (CON_Idplanilla, "+;
					"CON_ApeNom, "+;
					"CON_documento, "+;
					"CON_Telefono, CON_ContEstrechoDom, "+;
					"CON_ContEstrechoFecha, "+;
					"CON_ContEstrechoTipo, "+;
					"CON_Comentarios) " +;
					" VALUES ( ?mvid, ?m.NomApe, ?m.DNI, ?m.Telefono , ?m.Domicilio, ?m.FecUltimo , ?m.Tipocont, ?m.Comentarios )")

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




*!*	?m.COV_Camelidos,
*!*				  ?m.COV_Cerdos, ?m.COV_ContEstrechoArea,
*!*				  ?m.COV_ContEstrechoDNI,
*!*				  ?m.COV_ContEstrechoNomApe,
*!*				  ?m.COV_ContacPersoOtros,
*!*				  ?m.COV_ContactoOtros, ?m.COV_hiparterial,
*!*				  ?m.COV_InternaUTI, ?m.COV_MuesAspirado,
*!*				  ?m.COV_MuesBronalv, ?m.COV_MuesEstupo,
*!*				  ?m.COV_MuesHisopado, ?m.COV_MuestraFecha,
*!*				  ?m.COV_MuestraFechaLNR, ?m.COV_MuestraOtro,
*!*				  ?m.NomApeNotifica, ?m.COV_Registrac,
*!*				  ?m.COV_ambulat, ?m.COV_ambulat1,
*!*				  ?m.COV_resulencurso, ?m.COV_resulterminado,
*!*				  ?m.COV_antivencurso, ?m.COV_antivterminado,
*!*				  ?m.COV_antvacunaAntigrip,
*!*				  ?m.COV_antvacunaAntigrip2,
*!*				  ?m.COV_artalgias, ?m.COV_asma,
*!*				  ?m.COV_bajopesogr, ?m.COV_bajopesonac,
*!*				  ?m.COV_bronquiolitis, ?m.COV_cefalea,
*!*				  ?m.COV_COVcentroFechanCOV19,
*!*				  ?m.COV_ciudadcentronCOV19, ?m.COV_coma,
*!*				  ?m.COV_companiaviaje, ?m.COV_concasosconf,
*!*				  ?m.COV_Contactomercados,
*!*				  ?m.COV_convulsiones,
*!*				  ?m.COV_viajoresidioDesde,
*!*				  ?m.COV_dentropaisdonde,
*!*				  ?m.COV_dentropaishasta, ?m.COV_diabetes,
*!*				  ?m.COV_diagbronquitis, ?m.COV_diagespecif,
*!*				  ?m.COV_diagneumonia, ?m.COV_diagsmegripal,
*!*				  ?m.COV_diarrea, ?m.COV_dolorabdominal,
*!*				  ?m.COV_dolorgaganta, ?m.COV_dolortoracico,
*!*				  ?m.COV_embarazo, ?m.COV_endfneurolog,
*!*				  ?m.COV_enferpatica, ?m.COV_enfermprev,
*!*				  ?m.COV_enfoncologica, ?m.COV_enfrenal,
*!*				  ?m.COV_epoc, ?m.COV_estabinternac,
*!*				  ?m.COV_estabprimconsul,
*!*				  ?m.COV_estadorepencurso,
*!*				  ?m.COV_estadorepfallecido,
*!*				  ?m.COV_estadorepfechafallec,
*!*				  ?m.COV_estadorepnorecup,
*!*				  ?m.COV_fecAntibiot, ?m.COV_fecAntiviral,
*!*				  ?m.COV_fechInterna, ?m.COV_fechInternaUti,
*!*				  ?m.COV_fechaingresopais,
*!*				  ?m.COV_fechavacuantigrip1,
*!*				  ?m.COV_fiebremasmenos38, ?m.COV_inisintoma,
*!*				  ?m.COV_inmunSupres, ?m.COV_insufcardiaca,
*!*				  ?m.COV_insufrespirat, ?m.COV_internado,
*!*				  ?m.COV_inyecconjuntival,
*!*				  ?m.COV_irritabconfu, ?m.COV_malestargral,
*!*				  ?m.COV_mialgias, ?m.COV_nac,
*!*				  ?m.COV_ningunaant, ?m.COV_nomcentronCOV19,
*!*				  ?m.COV_obesidad, ?m.COV_odinofagia,
*!*				  ?m.COV_otrosespec, ?m.COV_otrossint,
*!*				  ?m.COV_prematsemana, ?m.COV_prematuridad,
*!*				  ?m.COV_primconsulta, ?m.COV_puerperio,
*!*				  ?m.COV_rechaaliemnt, ?m.COV_requierearm,
*!*				  ?m.COV_rxneumonia, ?m.COV_semanaepi,
*!*				  ?m.COV_taquipnea, ?m.COV_tiraje,
*!*				  ?m.COV_tos, ?m.COV_trabanimales,
*!*				  ?m.COV_trablaborat, ?m.COV_trabsalud,
*!*				  ?m.COV_tuberculosis, ?m.COV_viajoDesde,
*!*				  ?m.COV_viajoDonde, ?m.COV_viajoavion,
*!*				  ?m.COV_viajobarco, ?m.COV_viajodentropais,
*!*				  ?m.COV_viajohasta, ?m.COV_viajoomnibus,
*!*				  ?m.COV_viajoresidio, ?m.COV_vomitos,
*!*				  ?m.COV_contactoconaves
