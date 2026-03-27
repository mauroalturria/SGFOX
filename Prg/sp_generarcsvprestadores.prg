**********************************************************************
* Program....: SP_GENERARCSVPRESTADORES.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 03 August 2020, 19:45:49
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 03 August 2020 / 19:45:49
* Purpose....: 	Clase para Generar archivo CSV desde prestadores
*
* Note       :   Si a la llamada para ejecutar el programa se le pasan parametos ( '' ,'C:\desaguemes\','PrestadoresCSV.csv' )
*                el archivo generado se graba en la capeta con ese nombre (Automatico) , sino muestra formulario de captura -Nombre/Carpeta
**********************************************************************
*

*-- Con parámetros fijos para dispararlo de forma automática  ( requiere proyecto único y compilación )
* oGeneraCSVPrestadores = Newobject("GeneraCSVPrestadores","...\sp_generarcsvprestadores.prg", '' ,'C:\desaguemes\','PrestadoresCSV.csv' )

*-- Sin parámetros para dispararlo de forma manual
* oGeneraCSVPrestadores = Newobject("GeneraCSVPrestadores","...\sp_generarcsvprestadores.prg" )
* oGeneraCSVPrestadores.ArmoSetdatos()

* oFrmselecarchivo = NEWOBJECT("frmselecarchivo","...\sp_generarcsvprestadores.prg")
* oFrmselecarchivo.Visible = .T.

Define Class GeneraCSVPrestadores As Custom

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
   *
   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Iniciio de Procedimiento
   ***************************************************************************************************
   *
   Procedure Init( tcDestino As String , tcNomArchivo As String )

      * If Pcount( ) <> 0
      *-- Coloco los parametros enviados em propiedades para determinar uso de forma automatica o ejecutado a mano
      This.cLugarDestino  = Iif( Empty( tcDestino ) , '', tcDestino )
      This.cNombreArchivo = Iif( Empty(tcNomArchivo ) , '' , tcNomArchivo )
      * Endif

      *-- Verificacion de rigos si esta conextado
      If !Used("mwkserver1")
         Do sp_conexion
         This.lDisconnect = .T.
      Endif

      *-- Guardo la conexion en una propiedad de la clase
      This.nConexionSQL = mCon1

      This.dfechaServer = sp_busco_fecha_serv('DD')

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

      *////////
      *  Correccion de Rodrigo
      * La columna "Nombre de la Posición" por ahora dejala vacía  ("" o " " si no te sale poner una string vacía)
      * La columna "Area/Servicio Nombre" debe contener la Especialidad
      * La columna "Sector Nombre" debe contener el campo que te pasé en el query que contiene alguno (o varios ) de los valores AMBULATORIO,GUARDIA, INTERNACION

      *!* Sacado del resultado de la consulta
      *!*		"Nombre",									"MATEO MARIA",
      *!*		"Apellido",									"STURLA FLAVIO",
      *!*		"Empresa  E-Mail Dirección de e-mail",		"drjorrat@gmail.com",
      *!*		"Personal  E-Mail Dirección de e-mail",		"fsturla@silver-cross.com.ar",
      *!*		"Nombre de la Posición",					" ",
      *!*		"Empresa Nombre de Sociedad",				"Silver Cross América Inc. S.A.",
      *!*		"Empresa Código de Sociedad",				"SANA",
      *!*		"Dirección Nombre",							"Dirección Médica",
      *!*		"Area/Servicio Nombre",						"CIRUGIA PLASTICA Y REPARADORA",
      *!*		"Sector Nombre",							"AMBULATORIO",
      *!*		"Argentina DNI - Documento Nacional de Identidad  Documentos Nacionales" "04237919"

      *!* Sacado del archivo de sap
      *!*													"IVANA LOURDES",
      *!*													"TOLABA",
      *!*													"ivana025@hotmail.com",
      *!*													"",
      *!*													"Enfermero de Consultorios Externos Ev.",
      *!*													"Silver Cross América Inc. S.A.",
      *!*													"SANA",
      *!*													"Dirección de Enfermería",
      *!*													"Enfermería",
      *!*													"Internación General",
      *!*													"26031895"

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
         Do Log_errores With Error(), Message(), Message(1)
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
            DireccionMedica C(20), ;
            AreaNombre C(50), ;
            Sector C(60), ;
            DNI C(8) )

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

            Replace DNI With mwkPrestadoresTemp.DNI

         Endscan


         *///////////////////////////////////////////////////////////
         *-- Verifico parametros y grabo archivo
         If  This.GraboArchivoCSV ()
            llConsutaSQL = .T.
         Else
            llConsutaSQL = .F.
         Endif

      Endif

      *-- Control de si se ejectuo correctamente para seguir o abortar
      Return llConsutaSQL

   Endproc

   ***************************************************************************************************
   *  Procedure : GraboArchivoCSV
   ***************************************************************************************************
   *  Parameters  :
   *  Description :   Determino si hay datos para generar automaticamente el archivo o se pide online
   ***************************************************************************************************
   *
   Procedure GraboArchivoCSV( )

      Local    llOk

      llOk = .T.
      *-- Si se pasaron Nombres de archivo como parametros  no muestro formulario
      If !Empty( This.cLugarDestino ) Or !Empty( This.cNombreArchivo )

         If Used( 'mwkFinal' )
            Select mwkFinal
            * Browse Nowait

            *-- Cargo el Path y el nombre de archivo para guardarlo
            lcOperacion = "Copy to " + Alltrim( This.cLugarDestino ) + Alltrim( This.cNombreArchivo ) + " Type CSV "
            * Evaluate( lcOperacion )
            &lcOperacion
            * Copy To PrestadoresCsv1 Type Csv
            * Copy To lcOperacion Type Csv

            llOk = .T.
         Endif
      Else

         *////////
         * No se especifico Archivo y carpeta de salida , se captura
         *-- Levanto formulario de captura de datos
         Select mwkFinal

         Do Form frmPresta11 && Captura Salida 

         *-- El formulario se encarga de grabar el archivo
         *!*	         lcOperacion = "Copy to " + Alltrim( cCarpetaSalida ) + Alltrim( cNombreArchivo ) + " Type CSV "
         *!*	         &lcOperacion
         * Read Events

      Endif

      Return llOk

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
      * cInput es el string para evaluar
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

         *-- Concaeno los elementos
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



Enddefine


