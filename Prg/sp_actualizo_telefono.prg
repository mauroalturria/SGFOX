**********************************************************************
* Program....: PRG_TABPREFIJOTEL.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 13 February 2019, 10:50:53
* Notice.....: Copyright © 2019, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 13 February 2019 / 10:50:53
* Purpose....: Actualizacion de la tabla TabPrefijoTel con la información que se descarga (a mano) del portal gubernamental:
*              https://www.enacom.gob.ar/
*              Opción: Servicios TIC y postales -> Numeración y Señalización -> Numeración geográfica -> Asignaciones a la fecha
**********************************************************************
*
Local ocActualiza_TabPrefijotel As Object

*-- instanciamos esta clase para probar funcionalidad
ocActualiza_TabPrefijotel = Newobject("cactualiza_tabprefijotel","c:\desaguemes\prg\sp_actualizo_telefono.prg" )
ocActualiza_TabPrefijotel.ProcesoExcel( 'C:\Desaguemes\Numeración Geográfica - 20181213.xlsx' )
*--
* ocActualiza_TabPrefijotel.DepuraBasuraServ()
* ocActualiza_TabPrefijotel.DepuraBasuraExcel()

*!* ocActualiza_TabPrefijotel.CursorTablaPrefijo()

Define Class cActualiza_TabPrefijoTel As Custom

   oFormLauncher = ''											&& contiene formulario objeto
   cPathExcel = '' 												&& Contiene el path de del archivo excel

   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Inicializa el objeto
   ***************************************************************************************************
   *
   Procedure Init( toObjectLauncher )

      *-- Cargo el formulario en una propiedad
      This.oFormLauncher = toObjectLauncher

   Endproc


   ***************************************************************************************************
   *  Procedure : CursorTablaPrefijo
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Crea el cursor para ser evaluado y corregido
   ***************************************************************************************************
   *
   Procedure CursorTablaPrefijo()

      *-- Definicion de varaibles
      Local lcSQL , lnReturn , lOK
      lcSQL = ''

      *-- Arma la consulta al motor y tremos los datos de la tabla
      * TEXT to lcSQL TEXTMERGE NOSHOW pretext 7
      lcSQL = 'SELECT Tabprefijotel.ID, Tabprefijotel.PT_Caracteristica,' + ;
         'Tabprefijotel.PT_CodigoArea, Tabprefijotel.PT_FechaResoluc,' + ;
         'Tabprefijotel.PT_Localidad, Tabprefijotel.PT_Modalidad,' + ;
         'Tabprefijotel.PT_Operador, Tabprefijotel.PT_Prefijo,' + ;
         'Tabprefijotel.PT_Resolucion, Tabprefijotel.PT_Servicio ' + ;
         'FROM TabPrefijoTel ' + ;
         'ORDER BY Tabprefijotel.PT_Operador, Tabprefijotel.PT_Localidad, Tabprefijotel.PT_Modalidad '
      * ENDTEXT

      *-- Ejecutamos y controlamos el resultado (Di error , avisamos y salimos del procedimiento )
      lnReturn = SQLExec( mCon1, lcSQL, 'mwkTabPrefijoTel' ) && mwkDatosExcel
      If lnReturn = -1
         Messagebox("ERROR al intentar consultar la tabla TabPrefijoTel en el Motor de Datos",0+16 ,"Aviso al Usuario")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         lOK = .F.
      Else
         lOK = .T.
      Endif

      * Select curTabPrefijoTel
      * Browse
      Return lOK

   Endproc

   *!*	   ***************************************************************************************************
   *!*	   *  Procedure : Mensaje
   *!*	   ***************************************************************************************************
   *!*	   *  Parameters  :  tcMensaje - Contiene el Mensaje a mostrar
   *!*	   *  Description :  Prueba de instancia de clase objeto
   *!*	   ***************************************************************************************************
   *!*	   *
   *!*	   Procedure mensaje(tcMensaje )
   *!*	      Messagebox( tcMensaje )
   *!*	   Endproc


   ***************************************************************************************************
   *  Procedure : ProcesoExcel
   ***************************************************************************************************
   *  Parameters  :  tcPlanillaExcel - Contiene la planilla de escel en una carpets determinaada pra leer
   *  Description :  Apertura de la planilla de Excel para porcesarla, recorro la planilla y la cargo en cursor
   ***************************************************************************************************
   *
   Procedure ProcesoExcel( tcPlanillaExcel )

      *-- Variables locales ( No del objeto Clase )
      Local lcOperador, lcServicio, lcModalidad, lcLocalidad, lcIndicativo, lnBloque , lcResolucion, ldFecha

      *-- Creo cursor para contener los datos de Excel
      Create Cursor mwkDatosExcel (cOperador C(50), cServicio C(4), cModalidad C(6), cLocalidad C(60) , cIndicativo N(10,0), nBloque N(5,0), cResolucion C(12) , dFecha D )

      *-- Levantamos la aplicacion de Excel
      *!*	      Try
      oExcel = Createobject("Excel.Application")
      *!*	      Catch To oError

      *!*	         =Messagebox("Error en : "+Chr(13)+;
      *!*	            [ Error:         ] + Str(oError.ErrorNo) +Chr(13)+;
      *!*	            [ LineNo:     ] + Str(oError.Lineno) +Chr(13)+;
      *!*	            [ Message:     ] + oError.Message     +Chr(13)+;
      *!*	            [ Procedure:     ] + oError.Procedure +Chr(13)+;
      *!*	            [ Details:     ] + oError.Details     +Chr(13)+;
      *!*	            [ StackLevel: ] + Str(oError.StackLevel) +Chr(13)+;
      *!*	            [ LineContents: ] + oError.LineContents  +Chr(13)+;
      *!*	            [ UserValue:     ] + oError.UserValue ,48,"Error")

      *!*	      Endtry

      *!*	      *-- Controlo que el excel exista para continuar
      *!*	      If Vartype( oError ) = 'O'
      *!*	         Messagebox('No se encuentra instalado Microsoft Excel en el sistema. Se cancela la operación',0+16, 'Aviso al Usuario')
      *!*	         Return .F.
      *!*	      Else

      *-- Verificamos is se ejecuta desde formulario o no  ( se lanza desde aca - Ejecucion )
      If Vartype(This.oFormLauncher) = 'O'
         *-- Mostramos Excel para monitorear segun configuracion del formulario. (Mas de prueba que otra cosa)
         oExcel.Visible = This.oFormLauncher.MuestroExcel
         This.cPathExcel = This.oFormLauncher.txtArchivoExcel.Value

         *-- Abrimos el archivo excel y procesamos los datos
         oWorkbook = oExcel.Workbooks.Open( This.cPathExcel )


      Else
         *-- Paso a variable local el path de la planilla de excel (Esto si es interpretado )
         lcArchivoExcel = Alltrim( tcPlanillaExcel )								&&
         *-- Proceso la planilla de excel
         oWorkbook = oExcel.Workbooks.Open( lcArchivoExcel )
      Endif

      *!*	      Endif

      *-- Aviso que se esta procesando los datos
      Wait Window 'Procesando datos y comparando ' Nowait Timeout 35

      *-- Cargo los datos de la planilla en un cursos para la lectura y y comparacion
      A = 2
      For A = 2 To 45000

         With oExcel.Sheets[1]
            lcOperador   = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
            lcServicio   = Evaluate( '.Range("B'+ Alltrim( Str( A ) ) +':' + 'B' + Alltrim( Str( A ) ) + '").Value' )
            lcModalidad  = Evaluate( '.Range("C'+ Alltrim( Str( A ) ) +':' + 'C' + Alltrim( Str( A ) ) + '").Value' )
            lcLocalidad  = Evaluate( '.Range("D'+ Alltrim( Str( A ) ) +':' + 'D' + Alltrim( Str( A ) ) + '").Value' )
            lcIndicativo = Evaluate( '.Range("E'+ Alltrim( Str( A ) ) +':' + 'E' + Alltrim( Str( A ) ) + '").Value' )
            lnBloque     = Evaluate( '.Range("F'+ Alltrim( Str( A ) ) +':' + 'F' + Alltrim( Str( A ) ) + '").Value' )
            lcResolucion = Evaluate( '.Range("G'+ Alltrim( Str( A ) ) +':' + 'G' + Alltrim( Str( A ) ) + '").Value' )
            ldFecha      = Evaluate( '.Range("H'+ Alltrim( Str( A ) ) +':' + 'H' + Alltrim( Str( A ) ) + '").Value' )

            * If NOT isnull(lcOperador)  				                     	&& Isnull(lcOperador)
            If Not Empty( Alltrim( lcOperador ) )

               If Not Isnull(lcOperador)  					&& Isnull(lcOperador)

                  Select mwkDatosExcel
                  *-- Cargo los datos al cursor generado para contener los datos
                  Append Blank
                  Go Bottom

                  Replace ;
                     mwkDatosExcel.cOperador   With lcOperador,;
                     mwkDatosExcel.cServicio   With lcServicio    ,;
                     mwkDatosExcel.cModalidad  With lcModalidad , ;
                     mwkDatosExcel.cLocalidad  With lcLocalidad   ,;
                     mwkDatosExcel.cIndicativo With Val( lcIndicativo ) ,;
                     mwkDatosExcel.nBloque     With Val( lnBloque ),;
                     mwkDatosExcel.cResolucion With lcResolucion ,;
                     mwkDatosExcel.dFecha      With Ttod( ldFecha ) ;
                     IN mwkDatosExcel

                  Wait Window 'Procesando datos y comparando - Aguarde ' + Alltrim( Str( A ) )  Nowait

               Endif
            Endif


         Endwith

      Endfor

      *-- Levanto la data del motor para comprarar
      If This.CursorTablaPrefijo()
         *-- Lanzo el proceso de compraccion
         Wait Window 'Procesando comparación entre planilla y datos en el sistema ...' Nowait
         This.ProcesarComparacion()

      Else
         Return .F.
      Endif

      *-- matamosel Objeto Excel
      oExcel = .Null.

   Endproc

   ***************************************************************************************************
   *  Procedure : ProcessData
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Proceso los datos ( Metodo de Prueba de instancia de objeto )
   ***************************************************************************************************
   *
   Procedure ProcessData( tcPathExcel  )

      This.cPathExcel = This.oFormLauncher.txtArchivoExcel.Value
      This.ProcesoExcel( lcPathExcel )

   Endproc

   ***************************************************************************************************
   *  Procedure : ProcesarComparacion
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Proceso la comparacion de datos despues de haber levantado el archivo de Excel y el del Motor
   ***************************************************************************************************
   *
   Procedure ProcesarComparacion( )

      *-- Variables locales
      Local lnTotalEncontradas As Number ,lnTotalNoEncontradas As Number, lcmdSQL As String
      Private lcServicio , lcModalidad, lcResolucion, lcIndicativo, lnBloque

      *-- Se supone que el area de trabajo a esta altura esta generada
      If Used('mwkTabPrefijoTel')
         *-- Indexamos datos del motor
         Select mwkTabPrefijoTel
         Index On Alltrim( pt_codigoArea ) + Alltrim( pt_caracteristica) Tag Operador

         *-- Indexamos los datos de Excel
         Select mwkDatosExcel
         * Index On Alltrim( Str( cIndicativo ) ) + Alltrim( Str( nBloque ) ) Tag Operador2
         * SET ORDER TO  Operador
      Else
         Messagebox('El area de trabajo no se encontro o no esta generada ',0+16,'Aviso al Usuario')
      Endif

      *-- Inicializamos varaibles para totalizar proceso
      Store 0 To lnTotalEncontradas , lnTotalNoEncontradas

      *-- Empesamos la comparacion tomando la informacion bajada de la Web , cargada desde Excel
      Select mwkDatosExcel

      *-- Recorremos la tabla y buscamos en el motor de datos si esta el registro
      Scan
         lcCodigoBusca = Alltrim( Str( cIndicativo ) ) + Alltrim( Str( nBloque ) )

         Select mwkTabPrefijoTel
         If Seek( lcCodigoBusca )								&& Se encontro el dato Actualizo el motor


            * Messagebox(' Si encontrado '+Str(AA) )
            lnTotalEncontradas = lnTotalEncontradas + 1

            *-- Cargamos los valores para enviar al motor
            Select mwkDatosExcel
            m.lcOperador =  Alltrim( mwkDatosExcel.cOperador )
            m.lcPrefijo = Alltrim( Str( mwkDatosExcel.cIndicativo ) ) + Alltrim( Str( mwkDatosExcel.nBloque ) )
            m.lcServicio = Alltrim( mwkDatosExcel.cServicio )
            m.lcModalidad = Alltrim( mwkDatosExcel.cModalidad )
            m.lcResolucion = Alltrim( mwkDatosExcel.cResolucion )
            m.lcIndicativo = Alltrim( Str( mwkDatosExcel.cIndicativo ) )
            m.lnBloque = Alltrim( Str( mwkDatosExcel.nBloque) )

            * TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
            lcmdSQL = 'UPDATE TabPrefijoTel SET ' +;
               "pt_Operador = '" + m.lcOperador + "'," +;
               "pt_Prefijo = " + m.lcPrefijo + "," +;
               "pt_servicio = '" + m.lcServicio + "'," +;
               "pt_Modalidad = '" + m.lcModalidad + "'," +;
               "pt_resolucion = '" + m.lcResolucion + "' " + ;
               "WHERE " + ;
               "pt_CodigoArea = " + m.lcIndicativo + " and " + ;
               "pt_Caracteristica = " + m.lnBloque
            * ENDTEXT

         Else													&& No se encontro el datos , Agregamos

            * Messagebox(' No encontrado '+ Str(BB) )
            lnTotalNoEncontradas = lnTotalNoEncontradas + 1

            *-- Carga de parametros
            m.lnId = 0
            m.lcCaracteristica = mwkDatosExcel.nBloque
            m.lcCodigoArea = mwkDatosExcel.cIndicativo
            m.ldFechaResoluc = mwkDatosExcel.dFecha
            m.lcLocalidad  = mwkDatosExcel.cLocalidad
            m.lcModalidad  = mwkDatosExcel.cModalidad
            m.lcOperador   =  mwkDatosExcel.cOperador
            m.lnPrefijo    = Alltrim( Str( mwkDatosExcel.cIndicativo ) ) + Alltrim( Str( mwkDatosExcel.nBloque ) )
            m.lcResolucion = mwkDatosExcel.cResolucion
            m.lcServicio   = mwkDatosExcel.cServicio

            *-- TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
            lcmdSQL = "INSERT INTO TabPrefijoTel VALUES ( '" +;
               m.lcCaracteristica + "'," +;
               m.lcCodigoArea + "," +;
               m.ldFechaResoluc + "," +;
               m.lcLocalidad + "," +;
               m.lcModalidad + "," +;
               m.lcOperador + "," +;
               m.lnPrefijo + "," +;
               m.lcResolucion + "," +;
               m.lcServicio + ')'
            *-- ENDTEXT

         Endif

         *-- Ejecutamos y controlamos el resultado (Di error , avisamos y salimos del procedimiento )
         lnReturn = SQLExec(mCon1, lcmdSQL,'mwkTemp' ) && mwkDatosExcel
         If lnReturn = -1
            Messagebox( ' Error al intentar actualizar datos del motor. ' , 0+64, 'Aviso al Usuario' )
         Else
         Endif

      Endscan

      *-- Para probar el mensaje a pantalla
      *-- lnTotalEncontradas = 10
      *-- lnTotalNoEncontradas = 0

      *-- Aviso de Totales procesados
      Messagebox( 'Se completó la actualización de la Tabla Informativa de Prefijos Telefónicos' + Chr(10) + Chr(10) +;
         'Se contabilizaron :'+ Chr(10) + Chr(10) + 'Total Encontrados : ' + Alltrim( Str( lnTotalEncontradas ) ) + Chr(10) + ;
         'Total No Encontrados : '  + Alltrim( Str( lnTotalNoEncontradas ) ) + Chr(10) + ;
         'Total de registros procesados :' + Alltrim( Str(  lnTotalEncontradas + lnTotalNoEncontradas ) ), 0+64 , 'Aviso al Usuario' )

   Endproc


   *///////////////////////////////////////////////////////////////////////
   *-- No corre en produccion

   Procedure DepuraBasuraServ()

      Local lnCount As Number

      *///////////////////////////////////////////////////////////////// Campos de tabla

      TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
            	SELECT Tabprefijotel.ID,
            	  Tabprefijotel.PT_Caracteristica,
            	  Tabprefijotel.PT_CodigoArea,
            	  Tabprefijotel.PT_FechaResoluc,
            	  Tabprefijotel.PT_Localidad,
            	  Tabprefijotel.PT_Modalidad,
            	  Tabprefijotel.PT_Operador,
            	  Tabprefijotel.PT_Prefijo,
            	  Tabprefijotel.PT_Resolucion,
            	  Tabprefijotel.PT_Servicio
            	 FROM TabPrefijoTel
      ENDTEXT

      *-- Ejecutamos y controlamos el resultado (Di error , avisamos y salimos del procedimiento )
      lnReturn = SQLExec(mCon1, lcmdSQL,'mwkTemp1' ) && mwkDatosExcel
      If lnReturn = -1
         Messagebox( ' Error al intentar actualizar datos del motor. ' , 0+64, 'Aviso al Usuario' )
      Else
         *
      Endif

      *///
      Select mwkTemp1
      Index On Alltrim( pt_codigoArea ) + Alltrim( pt_caracteristica) Tag Operador
      Go Top

      lnCount = 0

      Do While .Not. Eof()
         lcCodigoArea = Alltrim( mwkTemp1.pt_codigoArea )
         lcCaracteristica = Alltrim( mwkTemp1.pt_caracteristica )
         Skip

         If lcCodigoArea = Alltrim( mwkTemp1.pt_codigoArea ) And lcCaracteristica = Alltrim( mwkTemp1.pt_caracteristica )
            lnCount = lnCount + 1

            m.lnId = mwkTemp1.Id

            TEXT TO lcmdSQL_b TEXTMERGE NOSHOW PRETEXT 7
                 DElETE FROM Tabprefijotel WHERE Tabprefijotel.ID = ?m.LnId
            ENDTEXT
            *-- Ejecutamos y controlamos el resultado (Di error , avisamos y salimos del procedimiento )
            lnReturn = SQLExec(mCon1, lcmdSQL_b,'mwkTemp2' ) && mwkDatosExcel
            If lnReturn = -1
               Messagebox( ' Error al intentar Borrar datos del motor. ' , 0+64, 'Aviso al Usuario' )
            Else
               *
            Endif

         Endif


      Enddo

      Messagebox('Total de repetidos :' + Alltrim(Str( lnCount )) )

   Endproc


Enddefine




*!*	*////////////////////////////////////////////////////////////////////////////////////////////////////////////////


