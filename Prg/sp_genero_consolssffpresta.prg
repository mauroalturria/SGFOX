**********************************************************************
* Program....: SP_GENERO_CONSOLSSFFPRESTA.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 31 Agosto 2020, 10:19:19
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 31 Agosto 2020 / 08:32:19
* Purpose....: Genera Archivo CSV consolidado de Success Factor y Prestadores
*
**********************************************************************
*

*-- Instacio la calse
oConsolidadoSFpresta = Newobject("ConsolidadoSFPresta","...\sp_genero_consolssffpresta.prg"  )
* oConsolidadoSFpresta.CapturaConfig()
* oConsolidadoSFpresta.SubidaAutomatica()
oConsolidadoSFpresta.ArmoSetDatos()

*////////////////////////////////////////////////////////////////////////

Define Class ConsolidadoSFPresta As Custom

   nConexionSQL	= 0 							&& Contiene el Nro. de conexion para esta clase
   dfechaServer = {}							&& Contiene la fecha del servidor
   lDisconnect = .F.							&& Indica si esta conectado y debe desconectar
   *
   cAsuntoMail = ''								&& Contiene el Asunto del mail para enviar
   cMemoMail = ''								&& Cuerpo de _Mail (Datos de procesamiento)
   cRecibe = '' 								&& Quien recibe o destinatarios de Mail
   *
   cLugarDestino = ''							&& Lugar de destino donde se graba el acrchivo generado
   cNombreArchivo = ''							&& Nombre del archivo que se genera
   cSubidaAutomatica = '' 						&& Indica si se sube automaticamente el archivo CSV generado
   *
   cInicioCorrida = '' 						    && Contiene inicio de corrida del programa
   cFinCorrida = ''								&& Contiene la hora del fin de la corrida del programa
   *
   nTotalRegistos = 0 							&& Contiene los registros procesados al generar CSV
   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Iniciio de Procedimiento
   ***************************************************************************************************
   *
   Procedure Init( tcDestino As String , tcNomArchivo As String )

      *-- Verificacion de rigos si esta conextado
      If !Used("mwkserver1")
         Do sp_conexion
         This.lDisconnect = .T.
      Endif

      *-- Guardo la conexion en una propiedad de la clase
      * If mCon1 < 1
         This.nConexionSQL = mCon1
      * Else
      *   RETURN .F. 
      * Endif

      This.dfechaServer = sp_busco_fecha_serv('DD')
      This.cInicioCorrida = Time()
      *
      On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

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
   Procedure ArmoSetDatos()

      lDatosOK = .F.								&& Indica si todo es correcto

      If This.GeneraPrestadores()
         * Messagebox( 'Se Genero datos de Prestadores' )
         Wait 'Se Genero datos de Prestadores ' Window At 10,20 Timeout 5 				       && NOWAIT
         If This.GeneraSSFF()
            * Messagebox( 'Se Genero datos SSFF (Success Factor )' )
            Wait 'Se Genero datos SSFF (Success Factor  ' Window At 10,20 Timeout 5 			&& NOWAIT
            lDatosOK = .T.
         Endif
      Endif

      *-- Cursor fianl conteniendo Prestadores . Se agregan los datos de SSFF
      If Used('mwkFinal') And lDatosOK = .T.
         * Select mwkFinal
         * Browse
         Select mwkZabsf
         * Select * From mwkZabsf Where mwkZabsf.dni Not In ( Select dni From mwkFinal ) Into Cursor mwkZabSF_II

         *-- Inserto los que no estan en el cursor Final para no repetir
         Insert Into mwkFinal ( ;
            Nombre , Apellido , EmailPersonal , EmailCorporativo , AreaDestino , NombreSociedad , CodigoSociedad , ;
            DireccionMedica , AreaNombre , Sector , dni  ) ;
            SELECT  Nombre , Apellido , EmailPersonal , EmailCorporativo , AreaDestino , NombreSociedad , CodigoSociedad , ;
            DireccionMedica , AreaNombre , Sector , dni ;
            From mwkZabsf ;
            WHERE mwkZabsf.dni Not In ( Select mwkFinal.dni From mwkFinal )

         *-- Recuento de datos para informar por mail
         This.nTotalRegistos = Reccount('mwkFinal')

         *-- El metodo tiene ya al area de trabajo seteada
         If This.GraboArchivoCSV( )
            If This.SubidaAutomatica()
               This.EnvioMail()
            Endif
         Endif

      Endif

      *!*	      *-- Me fijo si la subida del archivo es automatica o no
      *!*	      If This.cSubidaAutomatica = 'SI'
      *!*	         This.SubidaAutomatica()
      *!*	      Endif

   Endproc

   ***************************************************************************************************
   *  Procedure : GenraSSFF
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Genera un set de datos de Success Factor
   ***************************************************************************************************
   *
   Procedure GeneraSSFF()

      *//////////////////////////////////////////////
      Private lcCMDSQL, lcCMDSQL_2 , dFechaDesde ,dFechaHasta
      Local llOkSSFF

      *-- Variables
      lcCMDSQL = ''
      lcCMDSQL_2 = ''

      *!* Try

      TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
			SELECT Zabsf.ID, Zabsf.SF_AgrupFun, Zabsf.SF_Apellido, Zabsf.SF_AreaServ,
			  Zabsf.SF_CUIL, Zabsf.SF_CodEstado, Zabsf.SF_CodigoTurno,
			  Zabsf.SF_DetaFterm, Zabsf.SF_Direccion, Zabsf.SF_Dni, Zabsf.SF_Empresa,
			  Zabsf.SF_Estado, Zabsf.SF_FecEmisionMat, Zabsf.SF_FecEntrada,
			  Zabsf.SF_FecHorAdd, Zabsf.FecHorDbUpd, Zabsf.SF_FecTermEmpl,
			  Zabsf.SF_FecVtoMat, Zabsf.SF_Funcion, Zabsf.SF_Legajo, Zabsf.SF_MailEmpr,
			  Zabsf.SF_MailPerson, Zabsf.SF_MailPrinc, Zabsf.SF_Nombre,
			  Zabsf.SF_NroMatricula, Zabsf.SF_Sector, Zabsf.SF_SupDirect, Zabsf.SF_TipoMatricula
		   FROM zabsf
		    WHERE  Zabsf.SF_CodEstado = ( 'A' ) AND  Zabsf.SF_CUIL <> ( "" )
      ENDTEXT

      nReturn = SQLExec(mCon1,lcCMDSQL,"mwkZabsfTemp")

      If nReturn < 0
         Messagebox( "Error de lectura de la tabla mwkZabsfTemp ",0+64,'Aviso al Usuario' )
         llOkSSFF = .F.
         Do log_errores With Error(), Message(), Message(1)
      Endif

      *//////////////////////////////////////////////////////////////////////////
      *    Campos para el Campus
      *//////////////////////////////////////////////////////////////////////////
      *!*		"Nombre",   								"JOSE RICARDO",
      *!*		"Apellido", 								"KOBYLANSKI",
      *!*		"Empresa  E-Mail Dirección de e-mail",   	"TESORERIA@SG.COM.AR",
      *!*		"Personal  E-Mail Dirección de e-mail",  	"",
      *!*		"Nombre de la Posición",  					"Jefe de Tesorería",
      *!*		"Empresa Nombre de Sociedad",  				"Silver Cross América Inc. S.A.",
      *!*		"Empresa Código de Sociedad", 				"SANA",
      *!*		"Dirección Nombre", 						"Dirección de Administración y Finanzas",
      *!*		"Area/Servicio Nombre", 					"Tesorería",
      *!*		"Sector Nombre", 							"Tesorería",
      *!*		"DNI - Documento Nacional de Identidad  Documentos Nacionales" "12505651"

      *-- Ultimo curosr formateado con datos necesarios solamente
      lcCMDSQL_2 = "SELECT "+;
         "mwkZabsfTemp.SF_Nombre as Nombre, "+;
         "mwkZabsfTemp.SF_Apellido AS Apellido, "+;
         "mwkZabsfTemp.SF_MailPerson AS EmailPersonal, "+;
         "mwkZabsfTemp.SF_MailEmpr as EmailCorporativo,  " +;
         "SUBSTR( ALLTRIM( mwkZabsfTemp.SF_Funcion),10 ) AS AreaDestino, "+;
         "substr( ALLTRIM( mwkZabsfTemp.SF_Empresa),5 ) AS NombreSociedad, "+;
         "SUBSTR( ALLTRIM( mwkZabsfTemp.SF_Empresa) ,1,4) as CodigoSociedad, "+;
         "SUBSTR( ALLTRIM( mwkZabsfTemp.SF_Direccion),10 ) AS DireccionMedica , " +;
         "SUBSTR( ALLTRIM( mwkZabsfTemp.SF_AreaServ),10 ) AS AreaNombre,"+;
         "SUBSTR( ALLTRIM( mwkZabsfTemp.SF_Sector ),10 ) AS  Sector, " +;
         "mwkZabsfTemp.SF_Dni AS DNI "+;
         "FROM mwkZabsfTemp INTO CURSOR mwkZabsf readwrite "

      *-- Ejecuto el ultimo Query formateado con los campos necesarios
      &lcCMDSQL_2

      If _Tally <> 0
         Select mwkZabsf
         * LOCATE FOR dni = "23147706"
         * Browse Nowait
         llOkSSFF = .T. 										&& Indica si el proceso esta OK
      Else
         llOkSSFF = .F. 										&& Indica si el proceso esta OK
      Endif


      *!*	      Catch To oError
      *!*	         =Messagebox("Error en : "+Chr(13)+;
      *!*	            [ Error: 		] + Str(oError.ErrorNo) +Chr(13)+;
      *!*	            [ LineNo: 	] + Str(oError.Lineno) +Chr(13)+;
      *!*	            [ Message: 	] + oError.Message 	+Chr(13)+;
      *!*	            [ Procedure: 	] + oError.Procedure +Chr(13)+;
      *!*	            [ Details: 	] + oError.Details 	+Chr(13)+;
      *!*	            [ StackLevel: ] + Str(oError.StackLevel) +Chr(13)+;
      *!*	            [ LineContents: ] + oError.LineContents  +Chr(13)+;
      *!*	            [ UserValue: 	] + oError.UserValue ,48,"Error")
      *!*	      Endtry

      Return llOkSSFF

   Endproc

   ***************************************************************************************************
   *  Procedure : GeneraPrestadores
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Genera un set de datos de Prestadores
   ***************************************************************************************************
   *
   Procedure GeneraPrestadores()

      *-- Defino variables para cargarla la consulta de SQL
      Local lcCMDSQL

      *-- Contiene el comando del query
      lcCMD_SQL = ''
      llConsutaSQL = .T. 					&& Contiene verdadero o falso , si se proceso todo correctamente

      *///////////////////////////// Datos requeridos
      *!*	"Nombre",										"ELMIS DEL CARMEN",
      *!*	"Apellido",										"CUETO OVIEDO",
      *!*	"Empresa  E-Mail Dirección de e-mail",			"eco1008@hotmail.com",
      *!*	"Personal  E-Mail Dirección de e-mail",			"",
      *!*	"Nombre de la Posición",						"Médico de Planta Neonatologia",
      *!*	"Empresa Nombre de Sociedad",					"Silver Cross América Inc. S.A.",
      *!*	"Empresa Código de Sociedad",					"SANA",
      *!*	"Dirección Nombre",								"Dirección Médica",
      *!*	"Area/Servicio Nombre",							"INTERNACION",
      *!*	"Sector Nombre",								"NEONATOLOGIA",
      *!*	"Argentina DNI - Documento Nacional de Identidad  Documentos Nacionales" "DNI"

      lcCMDSQL = ''

      *-- Consulta par a extraccion del primer estracto de datos
      TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
			SELECT Nom as Nombre ,
				Ape as Apellido,
			    Email as EmailPersonal ,
			    EmailCorp as EmailCorporativo ,
			    ' ' as AreaDestino ,
				'Silver Cross América Inc. S.A. ' AS NombreSociedad ,
				'SANA ' AS CodigoSociedad ,
			    'Dirección Médica' as DireccionMedica ,
			    ESP_Descripcion as AreaNombre ,
			    List(DISTINCT rtrim(Area)) as Sector ,
				Substring(Cuil,4,8) AS DNI
			 FROM Prestadores pres
			    Left Join TabProfEsp pesp on pesp.codprof = pres.id
			    left Join TabAreaDes area on area.id = pesp.codarea
			    Left Join Especialid Esp on Pres.CodEsp = ESP_CodEsp
			 WHERE FecPasivaP = '1900-01-01' and Cuil <> ''
			 GROUP BY Cuil
			 ORDER BY Cuil, Area
      ENDTEXT

      nReturn = SQLExec(mCon1,lcCMDSQL,"mwkPrestadoresTemp" )					&& Cursor para de prestadores

      If nReturn < 0
         Messagebox( "Error de lectura de la tabla Consulta Prestadores ",0+64,'Aviso al Usuario' )
         * =Aerr(eros)
         Do log_errores With Error(), Message(), Message(1)
         llConsutaSQL = .F.
      Else

         *////////////////////////////////////////////////////////
         *-- Genero un cursor vacio para contener los datos finales para la salidad del archivo CSV
         Create Cursor mwkFinal ( ;
            Nombre C(40), ;
            Apellido C(60), ;
            EmailPersonal C(40) , ;
            EmailCorporativo C(40), ;
            AreaDestino C(40), ;
            NombreSociedad C(60), ;
            CodigoSociedad C(6), ;
            DireccionMedica C(40), ;
            AreaNombre C(50), ;
            Sector C(60), ;
            dni C(8) )

         * Select * From mwkPrestadoresTemp Where DNI = '99999999' Into Cursor mwkFinal Readwrite

         Select mwkPrestadoresTemp

         Scan
            Select mwkFinal
            Append Blank
            Replace Nombre With mwkPrestadoresTemp.Nombre ,;
               Apellido With mwkPrestadoresTemp.Apellido ,;
               EmailPersonal With mwkPrestadoresTemp.EmailPersonal ,;
               EmailCorporativo With Iif( Isnull( mwkPrestadoresTemp.EmailCorporativo ) , '',  mwkPrestadoresTemp.EmailCorporativo ) ,;
               AreaDestino With ' ' ,;
               NombreSociedad  With 'Silver Cross América Inc. S.A. ' ,;
               CodigoSociedad  With 'SANA ' ,;
               DireccionMedica With 'Dirección Médica' ,;
               AreaNombre With Iif( Isnull( mwkPrestadoresTemp.AreaNombre ) , '', mwkPrestadoresTemp.AreaNombre )

            * Replace Sector With Iif( Isnull(mwkPrestadoresTemp.Sector) , '' , Alltrim( mwkPrestadoresTemp.Sector ) )
            Replace Sector With Iif( Isnull(mwkPrestadoresTemp.Sector) , ' ' , This.OrdenaDatoCampo( Alltrim( mwkPrestadoresTemp.Sector ) ) )

            Replace dni With mwkPrestadoresTemp.dni

         Endscan

         llConsutaSQL = .T.

      Endif

      Return  llConsutaSQL

   Endproc

   ***************************************************************************************************
   *  Funcion : OrdenarDatosCampo
   ***************************************************************************************************
   *  Parameters  :   tcInput : contiene los datos del campo memo
   *  Description :   Ordeno y concateno los valores pasados del campo memo Sector
   ***************************************************************************************************
   *
   Function OrdenaDatoCampo ( tcInput )

      *//////////////////////////////////////////
      * tcInput es el string para evaluar
      * Asigno los resultados por cada valor encontrado dentro del array aValues

      Local lcStringOrdered, lnCount

      lcStringOrdered = '' 							&& Asigno valor vacio

      *-- Puede venir vacio lo contemplo aca y no en la llamada a la funcion
      If Empty(tcInput)
         Return lcStringOrdered
      Else

         lcInput = tcInput 								&& valores 'QUIROFANO , INTERNACION , GUARDIA , AMBULATORIO '
         lnItems = Occurs(",", lcInput)

         Dimension aValues[lnItems+1]

         For nCnt = 1 To lnItems
            *-- Encuentro la primer coma dentro del string
            nCommaPos = At(",",lcInput)
            * Toma el String antes de la coma
            aValues[nCnt] = Left(lcInput, nCommaPos - 1)
            *
            If nCommaPos <> Len(lcInput)
               lcInput = Substr( lcInput, nCommaPos + 1)
            Else
               lcInput = " "
            Endif
         Endfor

         * Tomo el ultimo string , Chequeo que no tenga coma
         If Empty(lcInput)
            Dimension aValues[lnItems]
         Else
            aValues[lnItems+1] = lcInput
         Endif

         *-- Ordeno es Array con los valores encontrados y cuento los elementos
         Asort(aValues)
         lnCount = Alen(aValues,1 )

         *-- Concateno los elementos
         For lnNum = 1 To lnCount
            If lnNum = 1
               lcStringOrdered= Alltrim( aValues[lnNum])
            Else
               lcStringOrdered= lcStringOrdered+ ',' + Alltrim( aValues[lnNum])
            Endif
         Endfor

      Endif

      * lcStringOrdered= Alltrim( aValues[1])+','+ Alltrim(aValues[2]) +','+ Alltrim( aValues[3] ) +','+ Alltrim( aValues[4] )
      * Messagebox( lcStringOrdered)
      Return lcStringOrdered

   Endfunc

   ***************************************************************************************************
   *  Procedure : GraboArchivoCSV
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Gravo los datos en el formato CSV, tomando los parametros del archivo INI
   ***************************************************************************************************
   *
   Procedure GraboArchivoCSV( )

      Local llok

      *-- Lectura de Path de salida y  nombre de datos configurado (Archivo INI )
      If This.CapturaConfig()

         If Used( 'mwkFinal' )
            Select mwkFinal
            * Browse Nowait

            *-- Cargo el Path y el nombre de archivo para guardarlo
            lcOperacion = "Copy to " + Alltrim( This.cLugarDestino ) + Alltrim( This.cNombreArchivo ) + " Type CSV "
            &lcOperacion
            llok = .T.

         Endif

      Else
         Wait 'No se encuentra la Carpeta Destino para la generación del archivo CSV. Revise archivo INI ' Window At 10,20 Timeout 10 			&& NOWAIT
         *-- Capturo error
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         llok = .F.
      Endif

      Return llok

   Endproc


   ***************************************************************************************************
   *  Procedure : CapturaConfig
   ***************************************************************************************************
   * Parameters  :
   * Description :   Lee archivo INI de configuracion para la generacion del archivo Final CSV ( ConfigCSVCosnolid.Ini )
   *
   * Ejemplo : Nombre CSV = Nombre archivo CVS generado - Path Destino = Carpeta donde se guarda el archivo CSV - Upload Automatic = Indica si se sube el archivo automaticamente
   * 			[NombreCSV]
   * 			Data=ConsolidadoSFPresta
   *
   * 			[PathDestino]
   * 			Data=C:\Temp\Edu
   *
   * 			[UploadAutomatic]
   * 			Data=SI
   *
   ***************************************************************************************************
   *
   Procedure CapturaConfig()

      Local lcCarpeta, llReturnOk

      *-- Levanto el PRG para la Lectura del Archivo INI - Podia haber puesto las funciones aca , pero las deje en un PRG
      Set Procedure To ..\prg\sp_readwritini.prg Additive

      *-- Capturo la carpeta donde esta el archivo INI ( Carpeta local )
      lcCarpeta = Fullpath(Curdir())

      If File( lcCarpeta + 'ConfigCSVCosnolid.Ini' )

         *-- Capturo Nombre y Carpeta de destino para la salidad del archivo CSV .
         This.cNombreArchivo = ReadpIni('NombreCSV','Data',lcCarpeta+'ConfigCSVCosnolid.ini' )
         This.cLugarDestino  = ReadpIni('PathDestino','Data',lcCarpeta+'ConfigCSVCosnolid.ini' )
         This.cSubidaAutomatica = ReadpIni('UploadAutomatic','Data',lcCarpeta+'ConfigCSVCosnolid.ini' )

         *-- Controlo la existencia del directorio destino
         If Directory( This.cLugarDestino )
            llReturnOk = .T.
         Else
            *!*	            Messagebox( 'La carpeta de salida no existe , revise el archivo INI. Gracias ',0+16, 'Error' )
            llReturnOk = .F.
         Endif

      Else
         *!*	         Messagebox( 'No se encuentra el archivo INI pra la configurcion de salida , revise el archivo INI. Gracias ',0+16, 'Error' )

         *-- Se encarga el Procdimiento llamante del mensaje sobre la inexistencia de la carpeta destino
         llReturnOk = .F.
      Endif

      *-- Retronamos el valor si se pudo o no levantar la Data
      Return llReturnOk

   Endproc

   ***************************************************************************************************
   *  Procedure : SubidaAutomatica
   ***************************************************************************************************
   * Parameters  :
   * Description :  Subimos el archivo generado automaticamente al Campus
   *			 Gracias Marcelo por el codigo
   ***************************************************************************************************
   *
   Procedure SubidaAutomatica( )

      Local lcArchivoEnvio , lcArchivoBAT , loShell

      */////////
      lcArchivoEnvio = This.cLugarDestino + This.cNombreArchivo + '.CSV'

      *-- Verifico antes de enviar el archivo si se genero y existe , aunque si llegamos a esta instancia salio todo bien
      If This.cSubidaAutomatica = 'SI' .And. File( lcArchivoEnvio )

         lcArchivoBAT = This.cLugarDestino + 'Launch.bat'

         If File(lcArchivoBAT)
            Run /N &lcArchivoBAT
            *!*	         *-- Levantmos el Objeto Shell del sistema operativo para ejecutrar el envio del archivo generado
            *!*	         loShell = Createobject("WScript.Shell")
            *!*	         loShell.Run( lcArchivoBAT, 0, .F.)
            *!*	         loShell = .F.
         Else
            * psftp -pw dax7mkTz sanatorioftp@eabc-vm-file-25.eastus.cloudapp.azure.com -b SendingDataSFTP.scr
            Strtofile( "psftp -pw dax7mkTz sanatorioftp@eabc-vm-file-25.eastus.cloudapp.azure.com -b SendingDataSFTP.scr", This.cLugarDestino + "Launch.Bat" )
            lcArchivoBAT = This.cLugarDestino + 'Launch.bat'
            Run /N &lcArchivoBAT
         Endif

         *-- Indico como corrio el procedimiento
         llReturn = .T.

      Else																&&  Messagebox('Todo Malll ' )
         On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         *-- Indico como corrio el procedimiento
         llReturn = .F.
      Endif

      */////////
      Return   llReturn

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
      loVismControl = Createobject('vism.vismctrl.1')

      If Vartype( loVismControl ) = 'O'

         This.ArmoMail()										&& Armo el Asusnto del eMail y el cuerpo. Viene los datos en propiedades del objeto

         loVismControl.mserver   = Allt( mwktabcfg.OLEServer )
         loVismControl.namespace = Allt( mwktabcfg.OleSpaces )

         *-- Segón como estoy ejecutando busco para el envio de mail
         If ( Version(2) = 2 )
            * Busco los destinatarios para el Mail de reporte
            *-- De Producion
            Do sp_busco_estados With 4,' and Tipo=49 and Estado=1 ','mwkmails'
         Else
            *-- De Desarrollo
            Do sp_busco_estados With 4,' and Tipo=45 and Estado=1 ','mwkmails'
         Endif

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
         loVismControl.mserver  = ""

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
      This.cAsuntoMail = "Archivo CSV consolidado de Success Factor y Prestadores - Ejecución Fecha: " + Dtoc(This.dfechaServer)

      lcCuerpoMail = 'Actualización de datos CAMPUS - Corrida al : ' + Dtoc( This.dfechaServer ) + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Cantidad de Registros Procesados : '+ Alltrim( Str( This.nTotalRegistos ) ) + '<br>'
      * lcCuerpoMail = lcCuerpoMail + 'Cantidad de Registros NO Procesados : '+ Alltrim( Str( This.nTotalRegistosNo ) ) + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Tiempo de Inicio / Fin :' + This.cInicioCorrida + ' / ' + This.cFinCorrida + '<br>' + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Desarrollo de Sistemas ' + '<br>'
      lcCuerpoMail = lcCuerpoMail + 'Sanatorio Güemes ' + '<br>'

      *-- Cargo la propiedad del Objeto para el envio
      This.cMemoMail = lcCuerpoMail

   Endproc

Enddefine





