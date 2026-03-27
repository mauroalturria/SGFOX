**********************************************************************
* Program....: SP_UPDATE_EPICOV19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 10 August 2020, 15:48:13
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 10 August 2020 / 15:48:13
* Purpose....:  Actualiza los datos en tabla Zabfichepncov19
**********************************************************************
*
Parameters mf, myip , tId

Private mUse , mFec ,nIdFicha

mRespuesta = .T.

mUse = mwkusuario.idusuario
mFec = sp_busco_fecha_serv('DT')
nIdFicha = tId

lcmdSQL = ''

TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
		UPDATE Zabfichepncov19 SET
			COV_Registrac=?mf[01],
			COV_Ocupacion=?mf[02],
			COV_Domicilio=?mf[03],
			COV_Telefono=?mf[04],
			COV_Pais=?mf[128],
			COV_ambulat=?mf[09],
			COV_inisintoma=?mf[05],
			COV_semanaepi=?mf[06],
			COV_primconsulta=?mf[07],
			COV_estabprimconsul=?mf[08],
			COV_ambulat1=?mf[09],
			COV_internado=?mf[10],
			COV_fechInterna=?mf[11],
			COV_estabinternac=?mf[115],
			COV_InternaUTI=?mf[12],
			COV_fechInternaUti=?mf[13],
			COV_requierearm=?mf[14],
			COV_fiebremasmenos38=?mf[15],
			COV_taquipnea=?mf[19],
			COV_diarrea=?mf[23],
			COV_artalgias=?mf[27],
			COV_malestargral=?mf[31],
			COV_coma=?mf[34],
			COV_tos=?mf[16],
			COV_tiraje=?mf[20],
			COV_vomitos=?mf[24],
			COV_mialgias=?mf[28],
			COV_rxneumonia=?mf[32],
			COV_dolorgaganta=?mf[17],
			COV_insufrespirat=?mf[21],
			COV_dolorabdominal=?mf[25],
			COV_cefalea=?mf[29],
			COV_inyecconjuntival=?mf[33],
			COV_odinofagia=?mf[18],
			COV_dolortoracico=?mf[22],
			COV_rechaaliemnt=?mf[26],
			COV_irritabconfu=?mf[30],
			COV_convulsiones=?mf[116],
			COV_otrossint=?mf[35],
			COV_enfermprev=?mf[36],
			COV_inmunSupres=?mf[37],
			COV_diabetes=?mf[41],
			COV_obesidad=?mf[46],
			COV_embarazo=?mf[50],
			COV_puerperio=?mf[54],
			COV_prematuridad=?mf[57],
			COV_prematsemana=?mf[58],
			COV_bajopesonac=?mf[44],
			COV_bajopesogr=?mf[45],
			COV_endfneurolog=?mf[38],
			COV_enferpatica=?mf[42],
			COV_enfrenal=?mf[47],
			COV_hiparterial=?mf[51],
			COV_insufcardiaca=?mf[55],
			COV_enfoncologica=?mf[39],
			COV_bronquiolitis=?mf[40],
			COV_nac=?mf[43],
			COV_epoc=?mf[48],
			COV_asma=?mf[52],
			COV_tuberculosis=?mf[56],
			COV_ningunaant=?mf[53],
			COV_otrosespec=?mf[60],
			COV_fecAntibiot=?mf[61],
			COV_resulencurso=?mf[49],
			COV_resulterminado=?mf[64],
			COV_fecAntiviral=?mf[117],
			COV_antivencurso=?mf[65],
			COV_antivterminado=?mf[66],
			COV_estadorepencurso=?mf[67],
			COV_estadorepnorecup=?mf[68],
			COV_estadorepfallecido=?mf[69],
			COV_estadorepfechafallec=?mf[62],
			COV_diagsmegripal=?mf[70],
			COV_diagbronquitis=?mf[71],
			COV_diagneumonia=?mf[72],
			COV_diagespecif=?mf[63],
			COV_trabsalud=?mf[80],
			COV_trablaborat=?mf[85],
			COV_trabanimales=?mf[84],
			COV_antvacunaAntigrip=?mf[74],
			COV_fechavacuantigrip1=?mf[98],
			COV_antvacunaAntigrip2=?mf[99],
			COV_viajoresidio=?mf[118],
			COV_viajoDonde=?mf[103],
			COV_viajoDesde=?mf[95],
			COV_viajohasta=?mf[96],
			COV_viajoavion=?mf[81],
			COV_viajobarco=?mf[82],
			COV_viajoomnibus=?mf[83],
			COV_fechaingresopais=?mf[97],
			COV_companiaviaje=?mf[88],
			COV_viajodentropais=?mf[120],
			COV_dentropaisdonde=?mf[89],
			COV_viajoresidioDesde=?mf[92],
			COV_dentropaishasta=?mf[93],
			COV_concasosconf=?mf[119],
			COV_nomcentronCOV19=?mf[100],
			COV_ciudadcentronCOV19=?mf[87],
			COV_centroFechanCOV19=?mf[94],
			COV_Cerdos=?mf[77],
			COV_contactoconaves=?mf[75],
			COV_Camelidos=?mf[76],
			COV_Contactomercados=?mf[123],
			COV_ContactoOtros=?mf[101],
			COV_EnntorFliar14Prev=?mf[78],
			COV_EntorLaboral14Prev=?mf[79],
			COV_EntorAsistencial14Prev=?mf[124],
			COV_ContacOtros14Prev=?mf[91] ,
			COV_ContactoCerc14Prev=?mf[121],
			COV_ContacPersoOtros=?mf[129],
			COV_ContEstrechoNomApe=?mf[86],
			COV_ContEstrechoDNI=?mf[90],
			COV_ContEstrechoArea=?mf[102],
			COV_MuesAspirado=?mf[108],
			COV_MuesHisopado=?mf[109],
			COV_MuesEstupo=?mf[122],
			COV_MuesBronalv=?mf[107],
			COV_MuestraOtro=?mf[111],
			COV_MuestraFecha=?mf[113],
			COV_MuestraFechaLNR=?mf[112],
			NomApeNotifica=?mf[114],
			COV_zonriesgo2=?mf[104],
			COV_Anosmia=?mf[125],
			COV_Tabaquismo=?mf[126],
			COV_ExTabaquista=?mf[127],
			COV_HisopaVigilan=?mf[130],
			COV_usuario=?muse,
			COV_fecmodifica=?mfec,
			COV_ipadress=?myip
		WHERE ID = ?nIdFicha
ENDTEXT

*-- Insercion de datos a la tabla
lnReturn = SQLExec(mcon1, lcmdSQL, 'mwkTemp')

If lnReturn > 0

   mvID = nIdFicha 							&& pasado el ID como parametro

   *!*	   lnReturn = SQLExec(mcon1,"SELECT id as lid FROM Zabfichepncov19  WHERE COV_usuario=?muse AND Cov_ipadress=?myip"+;
   *!*	      " AND COV_fecmodifica = ?mfec", "mwkedidat" )

   *   lnReturn = SQLExec( mcon1, "DELETE FROM ZabCov19Contacto WHERE CON_Idplanilla = ?mvID ", "mwkEdidat" )

   *   If lnReturn > 0

   lnReturn = SQLExec( mcon1, "DELETE FROM ZabCov19Contacto WHERE CON_Idplanilla = ?mvID ", "mwkEdidat" )

   * Select mwkedidat
   * Go Top
   * mvID = nIdFicha 							&& pasado el ID como parametro

   If Reccount('mwkEpidemioCOV19Cont') > 0

      Select mwkEpidemioCOV19Cont
      Go Top

      Scan All

         m.NomApe	 = mwkEpidemioCOV19Cont.CON_ApeNom
         m.DNI 	     = mwkEpidemioCOV19Cont.CON_documento
         m.Telefono  = mwkEpidemioCOV19Cont.CON_Telefono
         m.Domicilio = mwkEpidemioCOV19Cont.CON_ContEstrechoDom
         m.FecUltimo = mwkEpidemioCOV19Cont.CON_ContEstrechoFecha
         m.Tipocont  = mwkEpidemioCOV19Cont.CON_ContEstrechoTipo
         m.Comentarios = ' '


         lnReturn = SQLExec(mcon1,"INSERT INTO ZabCov19Contacto "+;
            "(CON_Idplanilla, "+;
            "CON_ApeNom, "+;
            "CON_documento, "+;
            "CON_Telefono, " +;
            "CON_ContEstrechoDom, "+;
            "CON_ContEstrechoFecha, "+;
            "CON_ContEstrechoTipo, "+;
            "CON_Comentarios) " +;
            " VALUES ( ?mvid, " +;
            " ?m.NomApe, " +;
            " ?m.DNI, " +;
            " ?m.Telefono , " +;
            " ?m.Domicilio, " +;
            " ?m.FecUltimo , " +;
            " ?m.TipoCont, " +;
            " ?m.Comentarios )")

         If lnReturn < 0

            Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
            Messagebox("EN INCORPORACION DE CONTACTOS para nCOV19 " + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
            mRespuesta = .F.

         Endif

      Endscan

   Endif

   *!*	   Else

   *!*	      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   *!*	      Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE F.EPIDEMIOLOGIA nCOV19 "+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
   *!*	      Return .F.

   *!*	   Endif

Else

   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox("EN REGISTRO DE F.EPIDEMIOLOGIA nCOV19 "+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
   mRespuesta = .F.

Endif





