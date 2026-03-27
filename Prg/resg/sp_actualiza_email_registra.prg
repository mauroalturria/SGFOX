**********************************************************************
* Program....: SP_ACTUALIZA_EMAIL_REGISTRA.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 19 June 2020, 10:35:53
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 19 June 2020 / 10:35:53
*
* Purpose....:  Todos los correos que los afiliados cargan en la página web migren automáticamente al sistema nuestro de Turnos.
**********************************************************************
*
*-- Ejecuto la clase
* oActualizaViaWeb = Newobject("ActualizaViaWeb","...\sp_actualiza_email_registra.prg")
* oActualizaViaWeb.EnvioMailProceso()
* oActualizaViaWeb.ArmoSetdatos()
* oActualizaViaWeb.VerificoProcesados()
* oActualizaViaWeb.Arregla_Datos


Define Class ActualizaViaWeb As Custom

   nConexionSQL	= 0 							&& Contiene el Nro. de conexion para esta clase
   dfechaServer = {}							&& Contiene la fecha del servidor
   lDisconnect = .F.							&& Indica si esta conectado y debe desconectar
   *
   cAsuntoMail = ''								&& Contiene el Asunto del mail para enviar
   cMemoMail = ''								&& Cuerpo de _Mail (Datos de procesamiento)
   cRecibe = '' 								&& Quien recibe o destinatarios de Mail
   *
   nTotalRegistos = 0 							&& Contiene el total de registros procesados
   nTotalRegistosNo = 0 						&& Contiene el total de registros NO procesados (Diferencia en el control de datos )
   *
   cInicioCorrida = '' 						    && Contiene inicio de corrida del programa
   cFinCorrida = ''								&& Contiene la hora del fin de la corrida del programa
   *
   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Iniciio de Procedimiento
   ***************************************************************************************************
   *
   Procedure Init()

      *-- Verificacion de rigos si esta conextado
      If !Used("mwkserver1")
         Do sp_conexion
         This.lDisconnect = .T.
      Endif

      *-- Guardo la conexion en una propiedad de la clase
      This.nConexionSQL = mCon1

      This.dfechaServer = sp_busco_fecha_serv('DD')
      This.cInicioCorrida = Time()

   Endproc

   ***************************************************************************************************
   *  Procedure : Unload
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Descargando la clase y cerrando
   ***************************************************************************************************
   *
   Procedure Unload()

      *-- Cierro el area de trabajo generada , para que no explote todo por el aire
      Use In(Select('mwkRegistraWeb'))

      If This.lDisconnect = .T.
         Do sp_Desconexion() 										&& WITH thisform.name
      Endif

   Endproc

   ***************************************************************************************************
   *  Procedure : ArmoSetdatos
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Traigo los datos de Web y del motor , para poder ser porcesado
   ***************************************************************************************************
   *
   Procedure ArmoSetdatos()

      *-- Defino variables para cargarla la consulta de SQL
      Local lcCMDSQL

      llConsutaSQL = .T. 					&& Contiene verdadero o falso , si se proceso todo correctamente

      *-- Verifico si los datos de respaldo para el proceso esta levantado o creado
      If This.ObtengoProcesados()

         Wait Window At 20,20 Nowait "Obteniendo datos Procesados..." Timeout 30

         lnTotalRegistos = 0
         lcCMDSQL = ''

         *!*	         TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
         *!*					SELECT MAX(TabwRegistra.TWR_FecHorAdd) AS TWR_FechorAdd,
         *!*					  Tabwregistra.TWR_Registra, Registracio.REG_nroregistrac,
         *!*					  Registracio.REG_numdocumento, Tabwregistra.TWR_Documento,
         *!*					  Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento,
         *!*					  Tabwregistra.TWR_Mail, Registracio.REG_email,
         *!*					  Tabwregistra.TWR_fechoradd, Registracio.REG_fecregistra,
         *!*					  Registracio.REG_nombrepac,	Registracio.REG_numdocumento
         *!*					 FROM Tabwregistra
         *!*					    INNER JOIN Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac
         *!*					    INNER JOIN TabWLoginLog ON (  Tabwloginlog.TWL_Registra = Tabwregistra.ID
         *!*					   AND  ( Tabwloginlog.TWL_tipo ) = ( 1 ) ) AND  {fn year(Tabwregistra.twr_fechoradd)} >= ( 2020 )
         *!*					 GROUP BY Tabwregistra.TWR_Registra
         *!*	         ENDTEXT

         TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
                SELECT MAX(TabwRegistra.TWR_FecHorAdd) AS TWR_FechorAdd,
 				  Tabwregistra.TWR_Registra, Registracio.REG_nroregistrac,
 				  Registracio.REG_numdocumento, Tabwregistra.TWR_Documento,
 				  Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento,
 				  Tabwregistra.TWR_Mail, Registracio.REG_email,
 				  Tabwregistra.TWR_fechoradd, Registracio.REG_fecregistra,
 				  Registracio.REG_nombrepac, Registracio.REG_numdocumento,
                  Tabwregtel.TWT_Nro, Registracio.REG_Telefonos, Tabwregtel.TWL_Registra, Tabwregtel.TWT_Tipo
 				 FROM Tabwregistra
                    INNER Join Tabwregtel   ON  Tabwregistra.Id = Tabwregtel.TWL_Registra
 				    INNER JOIN Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac
 				    INNER JOIN TabWLoginLog ON (  Tabwloginlog.TWL_Registra = Tabwregistra.ID
 				   AND ( Tabwloginlog.TWL_tipo ) = ( 1 ) ) AND  {fn year(Tabwregistra.twr_fechoradd)} >= ( 2020 )
                    WHERE  Tabwregtel.TWT_Tipo = ( 3 )
 				 GROUP BY Tabwregistra.TWR_Registra
         ENDTEXT

         *--
         nReturn = SQLExec(mCon1,lcCMDSQL,"mwkNoEnProducc" )					&& Cursor para contener lo qu eno stan dados de alta en produccion pero si en Web
         nReturn = SQLExec(mCon1,lcCMDSQL,"mwkRegistraWebTemp")			        && Cursor para procesar datos

         If nReturn < 0
            * Messagebox( "Error de lectura de la tabla Registra Web ",0+64,'Aviso al Usuario' )
            =Aerr(eros)
            * Do Log_errores With Error(), Message(), Message(1)
            llConsutaSQL = .F.
         Else
            Select mwkRegistraWebTemp
            *-- Controlo que solo se procesen lo que no fueron anteriormente o los nuevos
            Select * From mwkRegistraWebTemp ;
               WHERE mwkRegistraWebTemp.REG_nroregistrac Not In (Select mwkRegistraWebproc.REG_nroregistrac From mwkRegistraWebproc ) ;
               INTO Cursor mwkRegistraWeb
            * Browse

            *-- Verifico que el resultado contenga datos para seguir procesando
            If _Tally > 0
               This.ProcesaDatos()
            Else
               llConsutaSQL = .T.
            Endif

         Endif				&& Si se obtuvo datos del motor via Query

      Endif 				&& Si se proceso los datos anteriores o se creo el XML

      *-- Control de si se ejectuo correctamente para seguir o abortar
      Return llConsutaSQL

   Endproc

   ***************************************************************************************************
   *  Procedure : ProcesaDatos
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Procesamos los datos traidos de la Web y del motor filtrados por los ya procesados
   ***************************************************************************************************
   *
   Procedure ProcesaDatos()

      Local lcmdSQL_Update, lnReturn, llConsutaSQL
      Private cMailWeb , nNroDocumento

      llProcesoOK = .T. 									&& Contiene si se proceso el procedimiento de cambio de mail

      This.nTotalRegistos = 0 								&& Contiene la cantidad de registros procesados (Informacion requeriada via eMail)
      lcmdSQL_Update = ''								    && Contiene elinea de comando de Update a Motor

      If Used( 'mwkRegistraWeb' )
         Select mwkRegistraWeb

         Wait Window At 20,20 Nowait "Comparando y Actualizando nuevos Datos..." Timeout 30

         Scan && For Empty( mwkRegistraWeb.reg_email ) Or Alltrim( Upper(mwkRegistraWeb.reg_email)) = 'NO TIENE' Or Isnull(mwkRegistraWeb.reg_email)

            *!*	            If Alltrim(Lower(mwkRegistraWeb.twr_mail)) <> Alltrim(Lower(mwkRegistraWeb.reg_email)) Or ;
            *!*	                  ISNULL( mwkRegistraWeb.reg_email )

            This.nTotalRegistos = This.nTotalRegistos + 1
            * Wait Windows lnTotalRegistos

            * Select mwkRegistraWebproc
            *-- Cargo el registo para control de datos porcesados (lo paso a XML antes de terminar)
            Insert Into mwkRegistraWebproc (TWR_FecHorAdd, TWR_Registra, ;
               TWR_Apellido, TWR_Documento, ;
               TWR_FecHorAdd, twr_mail, ;
               REG_nombrepac, REG_fecregistra, ;
               REG_numdocumento, reg_email ) ;
               values( mwkRegistraWeb.TWR_FecHorAdd, mwkRegistraWeb.TWR_Registra, ;
               mwkRegistraWeb.TWR_Apellido, mwkRegistraWeb.TWR_Documento, ;
               mwkRegistraWeb.TWR_FecHorAdd, mwkRegistraWeb.twr_mail, ;
               mwkRegistraWeb.REG_nombrepac, mwkRegistraWeb.REG_fecregistra, ;
               mwkRegistraWeb.REG_numdocumento, mwkRegistraWeb.reg_email )

            m.cMailWeb = Alltrim( mwkRegistraWeb.twr_mail )
            m.cTelefono = ALLTRIM( mwkRegistraWeb.TWT_Nro) 
            m.nRegistracion = mwkRegistraWeb.TWR_Registra

            *--- Hago el Update de datos en el Motor (Registracio)
            *!*	               lcmdSQL_Update = 'UPDATE Registracio SET Registracio.REG_email = ?m.cMailWeb ' + ;
            *!*	                  'WHERE Registracio.REG_numdocumento = ?m.nNrodocumento '

            lcmdSQL_Update = 'UPDATE Registracio SET Registracio.REG_email = ?m.cMailWeb ,' + ;
               ' Registracio.REG_Telefonos = ?m.cTelefono ' + ;
               'WHERE Registracio.REG_nroregistrac = ?m.nRegistracion'

            lnReturn = SQLExec(mCon1, lcmdSQL_Update,"mwkTemp")
            If lnReturn < 1
               =Aerr(eros)
               Do Log_errores With Error(), Message(), Message(1)
               * Messagebox( "Error de escritura de la tabla Registracio ",0+64,'Aviso al Usuario' )
               llProcesoOK = .F.
               Exit
            Endif

            *!*	            Else
            *!*	               *-- Cargo los registros no procesados
            *!*	               This.nTotalRegistosNo = This.nTotalRegistosNo + 1

            *!*	               *-- Cargo el registo para control de datos porcesados (lo paso a XML antes de terminar)
            *!*	               Insert Into mwkRegistraWebproc (TWR_FecHorAdd, TWR_Registra, ;
            *!*	                  TWR_Apellido, TWR_Documento, ;
            *!*	                  TWR_FecHorAdd, twr_mail, ;
            *!*	                  REG_nombrepac, REG_fecregistra, ;
            *!*	                  REG_numdocumento, reg_email ) ;
            *!*	                  values( mwkRegistraWeb.TWR_FecHorAdd, mwkRegistraWeb.TWR_Registra, ;
            *!*	                  mwkRegistraWeb.TWR_Apellido, mwkRegistraWeb.TWR_Documento, ;
            *!*	                  mwkRegistraWeb.TWR_FecHorAdd, mwkRegistraWeb.twr_mail, ;
            *!*	                  mwkRegistraWeb.REG_nombrepac, mwkRegistraWeb.REG_fecregistra, ;
            *!*	                  mwkRegistraWeb.REG_numdocumento, mwkRegistraWeb.reg_email )

            *!*	            Endif

         Endscan

         *-- Si salio de escan sin errores
         If llProcesoOK = .T.
            *-- Armo el mail con la informacion a notificar y Guardo los datos procesados
            * This.EnvioMail()
            * Select mwkRegistraWebproc
            * Browse
            Wait Window At 20,20 Nowait "Guardando Datos Procesados ..." Timeout 30
            This.GuardoDatosXML('mwkRegistraWebproc')
         Endif

      Endif 					&&  Si hay area de trabajo IF Used

   Endproc

   ***************************************************************************************************
   *  Procedure : EnvioMail
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Envio un mail con las notificaciones de los procesos de actualizacion
   ***************************************************************************************************
   *
   Procedure EnvioMail()

      *-- Levanto el cubo para enviar los correos
      loVismControl = Createobject('VISM.VisMCtrl.1')

      If Vartype( loVismControl ) = 'O'

         This.ArmoMail()										&& Armo el Asusnto del eMail y el cuerpo. Viene los datos en propiedades del objeto

         loVismControl.Mserver   = Allt( mwktabcfg.OLEServer )
         loVismControl.NameSpace = Allt( mwktabcfg.OlESpaces )

         * Busco los destinatarios para el Mail de reporte
         Do sp_busco_estados With 4,' and Tipo=49 and Estado=1 ','mwkmails'

         If Used('mwkmails')

            * lcAsuntoMail = "Correos de Afiliados de página Web migrados automáticamente al sistema de Turnos al " + Dtoc(This.dfechaServer)
            * lcMemoMail = 'Esta es una prueba de Correo . Eduardo '

            Select mwkmails
            Scan 										&& All
               This.cRecibe = Alltrim( mwkmails.Descrip )

               loVismControl.Code = "D SEND^%ZMAIL("+ '"' + This.cRecibe + '"' +',"'+ This.cAsuntoMail + '","'+ This.cMemoMail + '","","","1" )'
               loVismControl.ExecFlag = 1
               loVismControl_ok	= loVismControl.p0

            Endscan

            If Empty(loVismControl_ok)
               * Messagebox("Se guardó la información y se envíó mail correctamente.",64,"Notificación")
            Else
               * Messagebox("ENVIO CON ERRORES - AVISE A SISTEMAS",16,"ENVIO")
               =Aerr(eros)
            Endif

         Endif

         mRespcose1 = loVismControl.p2
         loVismControl.Mserver  = ""

      Endif

      *-- Elimino el objeto VismControl
      loVismControl = .Null.

   Endproc

   ***************************************************************************************************
   *  Procedure : ArmoMail
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Arma el cuerpo del e-mail para notificar el proceso
   ***************************************************************************************************
   *
   Procedure ArmoMail()

      Local lcCuerpoMail

      *-- Coloco el tiempo que tardo el proceso y lo envio por mail
      This.cFinCorrida = Time()

      lcCuerpoMail = ''
      *-- Colocolos datos del porceso para envio de e-mail
      This.cAsuntoMail = "Correos de Afiliados de página Web migrados automáticamente al Sistema de Turnos. Fecha: " + Dtoc(This.dfechaServer)

      lcCuerpoMail = 'Actualización de datos (Corrida) al : ' + Dtoc( This.dfechaServer ) + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Cantidad de Registros Procesados : '+ Alltrim( Str( This.nTotalRegistos ) ) + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Cantidad de Registros NO Procesados : '+ Alltrim( Str( This.nTotalRegistosNo ) ) + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Tiempo de Inicio / Fin :' + This.cInicioCorrida + ' / ' + This.cFinCorrida + '<br>' + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Desarrollo de Sistemas ' + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Sanatorio Güemes ' + '<br>'

      *-- Cargo la propiedad del Objeto para el envio
      This.cMemoMail = lcCuerpoMail


   Endproc

   ***************************************************************************************************
   *  Procedure : ObtengoProcesados
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Se Verifica los datos ya procesados y si existen los obtengo y cargo en cursor ( En teoria es semanal y Automatico)
   ***************************************************************************************************
   *
   Procedure ObtengoProcesados()

      Local lProcesoOk , lcCMDSQL
      lProcesoOk = .T.

      *-- Verifco que el archivo de respaldo para el porceso esta creado , sino es la primera vez
      If File( Fullpath(Curdir()) + 'WebRegitac.xml' )
         *-- Levando el set de datos de los porcesados anteriormente
         Xmltocursor('WebRegitac.xml','mwkRegistraWebproc',512)
         Select mwkRegistraWebproc
         * Browse
      Else

         *!*	         *-- Creo el set de datoa para control de procesos
         *!*	         lcCMDSQL = 'SELECT MAX(Tabwregistra.TWR_FecHorAdd) AS TWR_FecHorAdd, Tabwregistra.TWR_Registra,'+;
         *!*	            'Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento, '+;
         *!*	            'Tabwregistra.TWR_FecHorAdd, Tabwregistra.TWR_Mail, '+;
         *!*	            'Registracio.REG_nombrepac, Registracio.REG_fecregistra, '+;
         *!*	            'Registracio.REG_numdocumento, Registracio.REG_email '+;
         *!*	            'FROM '+;
         *!*	            'Tabwregistra '+;
         *!*	            'INNER JOIN Registracio Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac '+;
         *!*	            'AND  Registracio.REG_numdocumento = Tabwregistra.TWR_Documento '+;
         *!*	            'WHERE  Registracio.REG_numdocumento = ( 99999999 ) '+;
         *!*	            'GROUP BY Tabwregistra.TWR_Registra '

         *!*	         lcCMDSQL = 'SELECT MAX(Tabwregistra.TWR_FecHorAdd) AS twr_fechoradd,TWR_Registra,'+;
         *!*	            'Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento,'+;
         *!*	            'Tabwregistra.TWR_FecHorAdd, Tabwregistra.TWR_Mail,'+;
         *!*	            'Registracio.REG_nombrepac, Registracio.REG_fecregistra,'+;
         *!*	            'Registracio.REG_numdocumento, Registracio.REG_email '+;
         *!*	            'FROM Tabwregistra '+;
         *!*	            'INNER JOIN Registracio Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac '+;
         *!*	            'AND  Registracio.REG_numdocumento = Tabwregistra.TWR_Documento '+;
         *!*	            'INNER JOIN TabWLoginLog Tabwloginlog '+;
         *!*	            'ON (  Tabwloginlog.TWL_Registra = Tabwregistra.ID '+;
         *!*	            'AND  ( twl_tipo ) = ( 1 ) ) '+;
         *!*	            'AND  {fn year(Tabwregistra.twr_fechoradd)} = ( 1900 ) '+;
         *!*	            'GROUP BY Tabwregistra.TWR_Registra '

         TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
				SELECT  MAX(TabwRegistra.TWR_FecHorAdd) AS TWR_FechorAdd,
				  Tabwregistra.TWR_Registra, Registracio.REG_nroregistrac,
				  Registracio.REG_numdocumento, Tabwregistra.TWR_Documento,
				  Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento,
				  Tabwregistra.TWR_Mail, Registracio.REG_email,
				  Tabwregistra.TWR_fechoradd, Registracio.REG_fecregistra,
				  Registracio.REG_nombrepac,	Registracio.REG_numdocumento
				 FROM Tabwregistra
				    INNER JOIN Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac
				    INNER JOIN TabWLoginLog ON (  Tabwloginlog.TWL_Registra = Tabwregistra.ID
				   AND  ( Tabwloginlog.TWL_tipo ) = ( 1 ) ) AND  {fn year(Tabwregistra.twr_fechoradd)} = ( 1900 )
				 GROUP BY Tabwregistra.TWR_Registra

         ENDTEXT

         *-- Consulto para crear cursor vacio y guardarlo como xml
         nReturn = SQLExec(mCon1,lcCMDSQL,"mwkRegistraWebTemp")

         If nReturn < 0
            * Messagebox( "Error de lectura de la tabla Registra Web ",0+64,'Aviso al Usuario' )
            =Aerr(eros)
            Do Log_errores With Error(), Message(), Message(1)
            lProcesoOk = .F.
         Else
            *-- Creo el XML para el tratamiento de datos
            Select mwkRegistraWebTemp
            Cursortoxml("mwkRegistraWebTemp", "WebRegitac.xml", 1, 512, 0, "1")
            *
            Xmltocursor('WebRegitac.xml','mwkRegistraWebproc',512)
            Select mwkRegistraWebproc

            *-- Cierro el area de trabajo generada , para que no explote todo por el aire
            Use In(Select('mwkRegistraWebTemp'))
         Endif

      Endif

      Return lProcesoOk

   Endproc


   ***************************************************************************************************
   *  Procedure : GuardoDatosXML
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Se guarda los datos procesados para no procesarlos nuevamente
   ***************************************************************************************************
   *
   Procedure GuardoDatosXML( tcTabla )

      lPocesoOK = .T.
      If Empty( tcTabla )
         lPocesoOK = .F.
      Else
         Select &tcTabla
         Cursortoxml( tcTabla, "WebRegitac.xml", 1, 512, 0, "1")
      Endif

      Return lPocesoOK

   Endproc
   ***************************************************************************************************
   *  Procedure : ReportoError
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Reporto Error manualmente
   ***************************************************************************************************
   *
   Procedure ReportoError( tnError , tcMsg , tcMsg1 , tcProg, tnLineNro )

      *!*	      lnError  = tnError
      *!*	      lcMsg    = tcMsg
      *!*	      lcMsg1   = tcMsg1
      *!*	      lcProg   = 'sp_actualiza_email_Registra'
      *!*	      lnLinNro = tnLineNro

      *!*	      *-- Envio error Manualmente
      Do Log_errores With lnError, lcMsg, lcMsg1, lcProg, lnLinNro

      * Do Log_errores With Error(), Message(), Message(1)

   Endproc

   ***************************************************************************************************
   *  Procedure : Arregla_Datos
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Solo lo uso para voltear dato de mail en Registracion y poder volver a procesar
   ***************************************************************************************************
   *
   Procedure Arregla_Datos()

      Local cMailWeb

      * Xmltocursor('Tabwloginlog_05072020.xml','mwkTabwloginlog',512)
      * Xmltocursor('WebRegitac_05072020.xml','mwkWebRegitac',512)
      * Xmltocursor('RegistracionProd_05072020.xml','mwkRegistracionProd',512)

      m.cMailWeb = .Null.

      *!*	      lcmdSQL_Delete = 'DELETE FROM Tabwloginlog '
      *!*	      *-- Consulto para crear cursor vacio y guardarlo como xml
      *!*	      nReturn = SQLExec(mCon1,lcmdSQL_Delete,"mwkTabwloginlogTemp")

      *!*	      If nReturn < 0
      *!*	         Messagebox(" ERRORES - AVISE A SISTEMAS",16,"ENVIO")
      *!*	         Return .F.
      *!*	      Else
      *!*	         Xmltocursor('Tabwloginlog_05072020.xml','mwkTabwloginlog',512)
      *!*	         Select mwkTabwloginlog
      *!*	         Scan
      *!*	            Scatter Name oTest

      *!*	            TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
      *!*				INSERT INTO TabWLoginLog (
      *!*				  Tabwloginlog.ID, Tabwloginlog.TWL_FecHorAdd,
      *!*				  Tabwloginlog.TWL_Mensaje, Tabwloginlog.TWL_Registra,
      *!*				  Tabwloginlog.TWL_Tipo
      *!*				  value (
      *!*				  oTest.ID, oTest.TWL_FecHorAdd,
      *!*				  oTest.TWL_Mensaje, oTest.TWL_Registra,
      *!*				  oTest.TWL_Tipo )
      *!*	            ENDTEXT

      *!*	         Endscan


      *!*	         Release oTest

      *!*	      Endif

      *!*	      Select mwkTabwloginlog


      lcmdSQL_Update = 'UPDATE Registracio SET Registracio.REG_email = ?m.cMailWeb ' + ;
         'WHERE Registracio.REG_nroregistrac in '+;
         '( Select Tabwregistra.TWR_Registra from Tabwregistra WHERE '+;
         ' {fn year(Tabwregistra.twr_fechoradd)} >= ( 2020 ) )'

      *-- Consulto para crear cursor vacio y guardarlo como xml
      nReturn = SQLExec(mCon1,lcmdSQL_Update,"mwkRegistracioTemp")

      If nReturn < 0
         Messagebox("ENVIO CON ERRORES - AVISE A SISTEMAS",16,"ENVIO")
         Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
      Else

         TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
			SELECT  Registracio.REG_nroregistrac, REG_email ,
			  Registracio.REG_numdocumento,
			  Registracio.REG_fecregistra,
			  Registracio.REG_nombrepac, Registracio.REG_numdocumento
			 FROM Registracio
			 WHERE  Registracio.REG_email IS NULL OR Registracio.REG_email = ( 'NO TIENE' ) AND {fn year(Registracio.REG_fecregistra)} >= ( 2020 )
         ENDTEXT

         *-- Consulto para crear cursor vacio y guardarlo como xml
         nReturn = SQLExec(mCon1,lcCMDSQL,"mwkRegistraTemp")
      Endif

   Endproc

Enddefine




*!*	SELECT Tabwregistra.TWR_fechoradd,;
*!*	  Tabwregistra.TWR_Registra, Registracio.REG_nroregistrac,;
*!*	  Registracio.REG_numdocumento, Tabwregistra.TWR_Documento,;
*!*	  Tabwregistra.TWR_Apellido, Tabwregistra.TWR_Documento,;
*!*	  Tabwregistra.TWR_Mail, Registracio.REG_email,;
*!*	  Registracio.REG_nombrepac, Registracio.REG_fecregistra,;
*!*	  Registracio.REG_numdocumento;
*!*	 FROM Tabwregistra  ;
*!*	    INNER JOIN Registracio Registracio ON  Tabwregistra.TWR_Registra = Registracio.REG_nroregistrac;
*!*	   AND  Registracio.REG_numdocumento = Tabwregistra.TWR_Documento ;
*!*	    INNER JOIN TabWLoginLog Tabwloginlog ON (  Tabwloginlog.TWL_Registra = Tabwregistra.ID;
*!*	   AND  ( twl_tipo ) = ( 1 ) ) AND  {fn year(Tabwregistra.twr_fechoradd)} >= ( 2020 );
*!*	 WHERE  Registracio.REG_email IS NULL;
*!*	 GROUP BY Tabwregistra.TWR_Registra
