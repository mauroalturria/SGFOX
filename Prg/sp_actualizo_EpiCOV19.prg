**********************************************************************
* Program....: SP_ACTUALIZO_EPICOV19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 19 March 2020, 07:03:41
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 19 March 2020 / 07:03:41
* Purpose....: Actualizacion de tabla   ZabFichEpnCov19 ; ( Cabecera ) Contactos (Detalle) : ZabCov19Contacto
**********************************************************************
*

*
* Actualizacion de Ficha Epidemiologica & Contactos
*
Lparameters mf

muse = mwkusuario.idusuario
mfec = sp_busco_fecha_serv('DT')

mRet = SQLExec(mcon1,"UPDATE TabFichEp SET " +;
   "COV_ambulat = ?mf[09],"+;
   "COV_inisintoma = ?mf[05],"+;
   "COV_semanaepi = ?mf[06],"+;
   "COV_primconsulta = ?mf[07],"+;
   "COV_estabprimconsul = ?mf[08],"+;
   "COV_ambulat1 = ?mf[09],"+;
   "COV_internado = ?mf[10],"+;
   "COV_fechInterna = ?mf[11],"+;
   "COV_estabinternac  = ?mf[115],"+;
   "COV_InternaUTI = mf[12],"+;
   "COV_fechInternaUti = ?mf[13],"+;
   "COV_requierearm = ?mf[14],"+;
   "COV_fiebremasmenos38 = ?mf[15],"+;
   "COV_taquipnea = ?mf[19],"+;
   "COV_diarrea = ?mf[23],"+;
   "COV_artalgias = ?mf[27],"+;
   "COV_malestargral = ?mf[31],"+;
   "COV_coma = ?mf[34],"+;
   "COV_tos = ?mf[16],"+;
   "COV_tiraje 	= ?mf[20],"+;
   "COV_vomitos = ?mf[24],"+;
   "COV_mialgias = ?mf[28],"+;
   "COV_rxneumonia = ?mf[32],"+;
   "COV_dolorgaganta = ?mf[17],"+;
   "COV_insufrespirat = ?mf[21],"+;
   "COV_dolorabdominal = ?mf[25],"+;
   "COV_cefalea = ?mf[29],"+;
   "COV_inyecconjuntival = ?mf[33],"+;
   "COV_odinofagia = ?mf[18],"+;
   "COV_dolortoracico = ?mf[22],"+;
   "COV_rechaaliemnt = ?mf[26],"+;
   "COV_irritabconfu = ?mf[30],"+;
   "COV_convulsiones = ?mf[116],"+;
   "COV_otrossint = ?mf[35],"+;
   "COV_enfermprev = ?mf[36],"+;
   "COV_inmunSupres = ?mf[37],"+;
   "COV_diabetes = ?mf[41],"+;
   "COV_obesidad = ?mf[56],"+;
   "COV_embarazo = ?mf[50],"+;
   "COV_puerperio = ?mf[54],"+;
   "COV_prematuridad = ?mf[57],"+;
   "COV_prematsemana = ?mf[58],"+;
   "COV_bajopesonac = ?mf[44],"+;
   "COV_bajopesogr = ?mf[45],"+;
   "COV_endfneurolog = ?mf[38],"+;
   "COV_enferpatica = ?mf[42],"+;
   "COV_enfrenal = ?mf[47],"+;
   "COV_hiparterial = ?mf[51],"+;
   "COV_insufcardiaca = ?mf[55],"+;
   "COV_enfoncologica = ?mf[39],"+;
   "COV_bronquiolitis = ?mf[40],"+;
   "COV_nac = ?mf[43],"+;
   "COV_epoc = ?mf[48],"+;
   "COV_asma = ? mf[52],"+;
   "COV_tuberculosis = ?mf[56],"+;
   "COV_ningunaant = ?mf[53],"+;
   "COV_otrosespec = ?mf[60],"+;
   "COV_fecAntibiot = ?mf[61],"+;
   "COV_resulencurso = ?mf[49],"+;
   "COV_resulterminado =  ?mf[64],"+;
   "COV_fecAntiviral = ?mf[117],"+;
   "COV_antivencurso = ?mf[65],"+;
   "COV_antivterminado = ?mf[66],"+;
   "COV_estadorepencurso = ?mf[67], "+;
   "COV_estadorepnorecup = ?mf[68], "+;
   "COV_estadorepfallecido = ?mf[69], "+;
   "COV_estadorepfechafallec = ?mf[62],"+;
   "COV_diagsmegripal = ?mf[70],"+;
   "COV_diagbronquitis = ?mf[71],"+;
   "COV_diagneumonia = ?mf[72],"+;
   "COV_diagespecif = ?mf[63], "+;
   "COV_trabsalud = ?mf[80],"+;
   "COV_trablaborat = ?mf[79],"+;
   "COV_trabanimales = ?mf[84],"+;
   "COV_antvacunaAntigrip = ?mf[74], "+;
   "COV_fechavacuantigrip1 = ?mf[98], "+;
   "COV_antvacunaAntigrip2 = ?mf[99],"+;
   "COV_viajoresidio = ?mf[118],"+;
   "COV_viajoDonde = ?mf[104],"+;
   "COV_viajoDesde = ?mf[95], "+;
   "COV_viajohasta = mf[96], "+;
   "COV_viajoavion = ?mf[81],"+;
   "COV_viajobarco = ?mf[82],"+;
   "COV_viajoomnibus = ?mf[83], "+;
   "COV_fechaingresopais = ?mf[97], "+;
   "COV_companiaviaje = ?mf[88], "+;
   "COV_viajodentropais = ?mf[120],"+;
   "COV_dentropaisdonde = ?mf[89],"+;
   "COV_viajoresidioDesde = ?mf[104], "+;
   "COV_dentropaishasta = ?mf[92], "+;
   "COV_concasosconf = ?mf[93], "+;
   "COV_nomcentronCOV19 = ?mf[119],"+;
   "COV_ciudadcentronCOV19 = ?mf[100],"+;
   "COV_COVcentroFechanCOV19 = ?mf[87],"+;
   "COV_Cerdos = ?mf[94], "+;
   "COV_contactoconaves = ?mf[77], "+;
   "COV_Camelidos = ?mf[75], "+;
   "COV_Contactomercados = ?mf[76],"+;
   "COV_ContactoOtros = ?mf[101],"+;
   "COV_ContacPersoOtros = ?mf[121], "+;
   "COV_ContEstrechoNomApe = ?mf[86], "+;
   "COV_ContEstrechoDNI = ?mf[90],"+;
   "COV_ContEstrechoArea = ?mf[102],"+;
   "COV_MuesAspirado = ?mf[108], "+;
   "COV_MuesHisopado = ?mf[109], "+;
   "COV_MuesEstupo = ?mf[122], "+;
   "COV_MuesBronalv = ?mf[107], "+;
   "COV_MuestraOtro = ?mf[110], "+;
   "COV_MuestraFehca = ?mf[113], "+;
   "COV_MuestraFehcaLNR = ?mf[112], "+;
   "NomApeNotifica = ?mf[114]),"+;
   " WHERE COV_Registrac = ?mf[01]")

If mRet > 0
   If Used('mwkContactoPersonas')

      If Used('mwkEdiDat')
         Use In mwkEdiDat
      Endif

      mRet = SQLExec( mcon1,"SELECT Id as lid FROM ZabCov19Contacto WHERE COV_usuario=?muse AND COV_ipadress=?myip"+;
         " and COV_fecmodifica=?mfec","mwkedidat")

      If mRet > 0
         Select mwkEdiDat
         Go Top

         mvid = mwkEdiDat.lid
         mRet = SQLExec( mcon1,"DELETE FROM ZabCov19Contacto where CON_IdPlanilla =? mvid" )

         If mRet < 0
            Messagebox("EN ACTUALIZACION DE CONTACTOS"+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
         Else
            If Reccount('mwkContactoPersonas') > 0
               Select mwkContactoPersonas
               Scan
                  m.NomApe	  = mwkContactoPersonas.cApellidoNombre
                  m.DNI 	  = mwkContactoPersonas.cDni
                  m.Telefono  = mwkContactoPersonas.cTelefono
                  m.Domicilio = mwkContactoPersonas.cDomicilio
                  m.FecUltimo = mwkContactoPersonas.dFechaUltimoContac
                  m.Tipocont  = mwkContactoPersonas.cTipo
                  m.Comentarios = ''

                  mRet = SQLExec(mcon1,"INSERT INTO ZabCov19Contacto "+;
                     " (  CON_Idplanilla, "+;
                     "CON_ApeNom, "+;
                     "CON_documento, "+;
                     "CON_Telefono, CON_ContEstrechoDom, "+;
                     "CON_ContEstrechoFecha, "+;
                     "CON_ContEstrechoTipo, "+;
                     "CON_Comentarios; ) " +;
                     " VALUES ( ?mvid ?m.NomApe, ?m.DNI, m.Telefono , ?m.Domicilio, ?m.FecUltimo , ?m.Tipocont, ?m.Comentarios )")

                  If mRet < 0
                     Messagebox("EN INCORPORACION DE CONTACTOS"+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
                  Endif
               Endscan
            Endif
         Endif
      Else
         *
         Messagebox("EN BUSQUEDA DE IDENTIFICADOR DE F.EPIDEMIOLOGIA"+Chr(10)+ "AVISE A SISTEMAS",16,"ERROR")
      Endif
   Endif
Else
   mpaso = .F.
   Messagebox("EN ACTUALIZACION DE F.EPIDEMIOLOGIA"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif


