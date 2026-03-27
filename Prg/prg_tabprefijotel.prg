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

*--
ocActualiza_TabPrefijotel = Newobject("cactualiza_tabprefijotel","..\prg\prg_tabprefijotel.prg" )
ocActualiza_TabPrefijotel.ProcesoExcel( 'C:\Desaguemes\Numeración Geográfica - 20181213.xlsx' )

*!* ocActualiza_TabPrefijotel.CursorTablaPrefijo()

Define Class cActualiza_TAbPrefijoTel As Custom

   oFormLauncher = ''														&& contiene formulario objeto

   ***************************************************************************************************
   *  Procedure : Init
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Inicializa el objeto
   ***************************************************************************************************
   *
   Procedure Init( toObjectLauncher As Object ) As VOID

      *-- Cargo el formulario en una propiedad
      * This.oFormLauncher = toObjectLauncher

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
      Local lcSQL As String , lnReturn As Number
      lcSQL = ''

      *-- Arma la consulta al motor y tremos los datos de la tabla
      TEXT to lcSQL TEXTMERGE NOSHOW pretext 7
		SELECT Tabprefijotel.ID, Tabprefijotel.PT_Caracteristica,
		  Tabprefijotel.PT_CodigoArea, Tabprefijotel.PT_FechaResoluc,
		  Tabprefijotel.PT_Localidad, Tabprefijotel.PT_Modalidad,
		  Tabprefijotel.PT_Operador, Tabprefijotel.PT_Prefijo,
		  Tabprefijotel.PT_Resolucion, Tabprefijotel.PT_Servicio
		 FROM TabPrefijoTel
		 ORDER BY Tabprefijotel.PT_Operador, Tabprefijotel.PT_Localidad, Tabprefijotel.PT_Modalidad
      ENDTEXT

      *-- Ejecutamso y controlamos el resultado (Di error , avisamos y salimos del procedimiento )
      lnReturn = SQLExec(mcon1,lcSQL,'curTabPrefijoTel' )
      If lnReturn = -1
         Messagebox("ERROR al intentar consultar la tabla TabPrefijoTel ",0+16 ,"Aviso al Usuario")
         Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
         Return .F.
      Endif

      * Select curTabPrefijoTel
      * Browse

   Endproc

   *!*	   ***************************************************************************************************
   *!*	   *  Procedure : Mensaje
   *!*	   ***************************************************************************************************
   *!*	   *  Parameters  :  tcMensaje - Contiene el Mensaje a mostrar
   *!*	   *  Description :  Prueba de instancia de clase objeto
   *!*	   ***************************************************************************************************
   *!*	   *
   *!*	   Procedure mensaje(tcMensaje as String ) as VOID
   *!*	      Messagebox( tcMensaje )
   *!*	   Endproc


   ***************************************************************************************************
   *  Procedure : PorcesoExcel
   ***************************************************************************************************
   *  Parameters  :  tcPlanillaExcel - Contiene la planilla de escel en una carpets determinaada pra leer
   *  Description :  Apertura de la planilla de Excel para porcesarla, recorro la planilla y la cargo en cursor
   ***************************************************************************************************
   *
   Procedure ProcesoExcel( tcPlanillaExcel As String )

      Set Step On
      *-- Variables locales ( No del objeto Clase )
      LOCAL lcOperador, lcServicio, lcModalidad, lcLocalidad, lcIndicativo, lnBloque , lcResolucion, ldFecha    

      *-- Creo cursor para contener los datos de Excel
      Create Cursor mwkDatosExcel (cOperador C(50), cServicio C(4), cModalidad C(6), cLocalidad C(60) , cIndicativo N(10,0), nBloque N(5,0), cResolucion C(12) , dFecha D )

      *-- Levantamos la aplicacion de Excel
      oExcel = Createobject("Excel.Application")
      oExcel.Visible = .T.

      *-- Paso a variable local el path de la planilla de excel (Esto si es interpretado )
      lcArchivoExcel = Alltrim( tcPlanillaExcel )								&& Esto si esta interpretado

      *-- Abrimos el archivo excel y rocesamos los datos
      * oWorkbook = oExcel.Workbooks.Open( this.oFormLauncher.txtArchivoExcel.Value )
      oWorkbook = oExcel.Workbooks.Open( lcArchivoExcel )

SET STEP ON 

      A = 2
      For A = 2 To 500

         With oExcel.Sheets[1]
            lcOperador   = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
            lcServicio   = Evaluate( '.Range("B'+ Alltrim( Str( A ) ) +':' + 'B' + Alltrim( Str( A ) ) + '").Value' )
            lcModalidad  = Evaluate( '.Range("C'+ Alltrim( Str( A ) ) +':' + 'C' + Alltrim( Str( A ) ) + '").Value' )
            lcLocalidad  = Evaluate( '.Range("D'+ Alltrim( Str( A ) ) +':' + 'D' + Alltrim( Str( A ) ) + '").Value' )
            lcIndicativo = Evaluate( '.Range("E'+ Alltrim( Str( A ) ) +':' + 'E' + Alltrim( Str( A ) ) + '").Value' )
            lnBloque     = Evaluate( '.Range("F'+ Alltrim( Str( A ) ) +':' + 'F' + Alltrim( Str( A ) ) + '").Value' )
            lcResolucion = Evaluate( '.Range("G'+ Alltrim( Str( A ) ) +':' + 'G' + Alltrim( Str( A ) ) + '").Value' )
            ldFecha      = Evaluate( '.Range("H'+ Alltrim( Str( A ) ) +':' + 'H' + Alltrim( Str( A ) ) + '").Value' )

            Select mwkDatosExcel
            *-- Cargo los datos al cursor generado para contener los datos
            Append Blank
            Go Bottom

            Replace ;
               mwkDatosExcel.cOperador   With lcOperador,;
               mwkDatosExcel.cServicio   With lcServicio    ,;
               mwkDatosExcel.cModalidad  With lcModalidad , ;
               mwkDatosExcel.cLocalidad  With lcLocalidad   ,;
               mwkDatosExcel.cIndicativo With VAL( lcIndicativo ) ,;
               mwkDatosExcel.nBloque     With VAL( lnBloque ),;
               mwkDatosExcel.cResolucion With lcResolucion ,;
               mwkDatosExcel.dFecha      WITH TTOD( ldFecha ) ;
               IN mwkDatosExcel

         Endwith

      Endfor


   Endproc

   ***************************************************************************************************
   *  Procedure : ProcessData
   ***************************************************************************************************
   *  Parameters  :
   *  Description :  Proceso los datos ( Metodo de Prueba de instancia de objeto )
   ***************************************************************************************************
   *
   Procedure ProcessData( tcPathExcel As String  ) As VOID

      Set Step On
      This.oFormLauncher.txtArchivoExcel.Value

   Endproc

Enddefine




*!*	*////////////////////////////////////////////////////////////////////////////////////////////////////////////////



*!*	*//////////////////////////////////////////////////////////////////////////////////////////////////
*!*	*  Apertura de la planilla de Excel para porcesarla
*!*	*//////////////////////////////////////////////////////////////////////////////////////////////////

*!*	*-- Levantamos la aplicacion de Excel
*!*	oExcel = Createobject("Excel.Application")
*!*	* oExcel.Visible = .T.

*!*	*-- oExcel.SheetsInNewWorkbook = 4
*!*	lcArchivoExcel = Alltrim( Thisform.txtDirectorioArchivo.Value )
*!*	*-- oWorkbook = oExcel.Workbooks.Open("c:\desaadmin\mpf_mixto\asis\Temp\Justificaciones.xlsx")
*!*	oWorkbook = oExcel.Workbooks.Open( lcArchivoExcel )

*!*	A = 2

*!*	For A = 2 To 500
*!*	   With oExcel.Sheets[1]
*!*	      lCeldaA = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
*!*	      If Isnull( lCeldaA )
*!*	         Exit
*!*	      Else

*!*	         Legajo = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
*!*	         * ? Evaluate( '.Range("B'+ Alltrim( Str( A ) ) +':' + 'B' + Alltrim( Str( A ) ) + '").Value' )

*!*	         *-- Si es Personal o Telefonico la Justificación
*!*	         If Evaluate( '.Range("B'+ Alltrim( Str( A ) ) +':' + 'B' + Alltrim( Str( A ) ) + '").Value' ) = 0
*!*	            lnOrigen = 'P'
*!*	         Else
*!*	            lnOrigen = 'T'
*!*	         Endif

*!*	         *-- Evaluo si el codigo es e vacaciones
*!*	         lCeldaC = Evaluate( '.Range("C'+ Alltrim( Str( A ) ) +':' + 'C' + Alltrim( Str( A ) ) + '").Value' )
*!*	         If Inlist( lCeldaC, 'L0051','L0052','L0053','L0054','L0055','L0056','L0057','L0058','L0059','L0060','L0061' )
*!*	            Select ConceptoAsis
*!*	            Locate For CNPA_ID = xlResults.Codigo_concepto
*!*	            If Found()
*!*	               lnjas_vacaciones = cnpa_vac
*!*	            Else
*!*	               lnjas_vacaciones = '0'
*!*	            Endif
*!*	         Else
*!*	            lnjas_vacaciones = '0'
*!*	         Endif

*!*	         Codigo_concepto = Evaluate( '.Range("C'+ Alltrim( Str( A ) ) +':' + 'C' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Desde           = Evaluate( '.Range("D'+ Alltrim( Str( A ) ) +':' + 'D' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Hasta           = Evaluate( '.Range("E'+ Alltrim( Str( A ) ) +':' + 'E' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Observacion     = Evaluate( '.Range("F'+ Alltrim( Str( A ) ) +':' + 'F' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Ausencia__0_o_1_= Evaluate( '.Range("G'+ Alltrim( Str( A ) ) +':' + 'G' + Alltrim( Str( A ) ) + '").Value' )
*!*	         LLT             = Evaluate( '.Range("H'+ Alltrim( Str( A ) ) +':' + 'H' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Ret_a_hora      = Evaluate( '.Range("I'+ Alltrim( Str( A ) ) +':' + 'I' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Faltante        = Evaluate( '.Range("J'+ Alltrim( Str( A ) ) +':' + 'J' + Alltrim( Str( A ) ) + '").Value' )
*!*	         Exceso_Horario  = Evaluate( '.Range("K'+ Alltrim( Str( A ) ) +':' + 'K' + Alltrim( Str( A ) ) + '").Value' )

*!*	         Select curJustifasis

*!*	         *-- Verifico algunos datos que pueden estar cargados mal ( Fechas )
*!*	         If Vartype( Desde ) <> 'D' And Vartype( Desde ) <> 'T'
*!*	            Desde = Ctot( Desde )
*!*	         Endif

*!*	         If Vartype( Hasta ) <> 'D' And Vartype( Hasta ) <> 'T'
*!*	            Hasta = Ctot( Hasta )
*!*	         Endif

*!*	         *-- Cargo los datos al cursor generado para contener los datos
*!*	         Append Blank
*!*	         Go Bottom
*!*	         Replace leg_id With Legajo ,;
*!*	            curJustifasis.CNPA_ID          With Codigo_concepto,;
*!*	            curJustifasis.jas_ausencia     With Alltrim( Str( Ausencia__0_o_1_ )) ,;
*!*	            curJustifasis.jas_exehor       With Substr( Exceso_Horario,2,5 ) , ;
*!*	            curJustifasis.jas_faltahor     With Substr( Faltante,2,5 ) ,;
*!*	            curJustifasis.jas_fechaautor   With Datetime() ,;
*!*	            curJustifasis.jas_fechadesde   With Desde ,;
*!*	            curJustifasis.jas_fechahasta   With Hasta ,;
*!*	            curJustifasis.jas_observ       With Alltrim( Observacion ) ,;
*!*	            curJustifasis.jas_retanthor    With Substr( Ret_a_hora,2,5 ) ,;
*!*	            curJustifasis.jas_tarde        With Substr( LLT,2,5 ) , ;
*!*	            curJustifasis.jas_vacaciones   With lnjas_vacaciones,;
*!*	            curJustifasis.jas_origen       With lnOrigen,;
*!*	            curJustifasis.usr_id           With oApp.usr_id,;
*!*	            curJustifasis.jas_timestamp    With Datetime() ;
*!*	            IN curJustifasis

*!*	      Endif

*!*	   Endwith

*!*	Endfor

*!*	*-- Cerramos excel que se abrio recientemente
*!*	oExcel.Quit

*!*	*-- Matamos el objeto excel
*!*	oExcel = .Null.


*!*	*////////////////////////////////////////////////////////////////////////////////////
*!*	*   Envio de datos al motor
*!*	*////////////////////////////////////////////////////////////////////////////////////

*!*	Private nNumAutoId As Number

*!*	Select curJustifasis
*!*	Scan
*!*	   Scatter Memvar

*!*	   Wait Windows 'Legajo Procesado : ' + Alltrim(Str(m.leg_id)) Nowait Noclear

*!*	   *-- Obtengo el ID proximo para la carga
*!*	   lcmdSQL_Id = "Select Max( justifasis.jas_id )+1 as NumAuto FROM justifasis"
*!*	   *-- Ejecuto la instruccion SQL para crear un cursor de Justificaciones de Asistencia
*!*	   lnValorTetorno = ExecSql( lnConexion , lcmdSQL_Id, 'curTempID')

*!*	   Select curTempID
*!*	   m.nNumAutoId = Iif( Vartype( curTempID.Numauto ) = 'N' , curTempID.Numauto , Val( curTempID.Numauto ) )

*!*	   TEXT to lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
*!*				Insert into justifasis
*!*				    (justifasis.jas_id ,
*!*				    justifasis.leg_id          ,
*!*	                justifasis.cnpa_id         ,
*!*	                justifasis.jas_ausencia    ,
*!*	                justifasis.jas_exehor      ,
*!*	                justifasis.jas_faltahor    ,
*!*	                justifasis.jas_fechaautor  ,
*!*	                justifasis.jas_fechadesde  ,
*!*	                justifasis.jas_fechahasta  ,
*!*	                justifasis.jas_observ      ,
*!*	                justifasis.jas_retanthor   ,
*!*	                justifasis.jas_tarde       ,
*!*	                justifasis.jas_vacaciones  ,
*!*	                justifasis.jas_origen      ,
*!*	                justifasis.usr_id          ,
*!*	                justifasis.jas_timestamp )
*!*				values (
*!*	    			  ?m.nNumAutoId		  ,
*!*				      ?m.leg_id 		  ,
*!*				      ?m.CNPA_ID		  ,
*!*				      ?m.jas_ausencia     ,
*!*				      ?m.jas_exehor       ,
*!*				      ?m.jas_faltahor     ,
*!*				      ?m.jas_fechaautor   ,
*!*				      ?m.jas_fechadesde   ,
*!*				      ?m.jas_fechahasta   ,
*!*				      ?m.jas_observ       ,
*!*				      ?m.jas_retanthor    ,
*!*				      ?m.jas_tarde        ,
*!*				      ?m.jas_vacaciones   ,
*!*				      ?m.jas_origen       ,
*!*				      ?m.usr_id           ,
*!*				      ?m.jas_timestamp    )
*!*	   ENDTEXT

*!*	   *-- Ejecuto la instruccion SQL para crear un cursor de Justificaciones de Asistencia
*!*	   lnValorTetorno = ExecSql( lnConexion , lcmdSQL, 'curTemp')

*!*	Endscan

*!*	Messagebox('Proceso de Importación de datos se encuentra realizado ',0+64, 'Aviso al Usuario'  )


*!*	*-- Refresco el formulario
*!*	Thisform.Refresh()












