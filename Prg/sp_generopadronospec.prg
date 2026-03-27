**********************************************************************
* Program....: SP_GENEROPADRONOSPEC.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 22 October 2021, 09:51:45
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 22 October 2021 / 09:51:45
* Purpose....:  Genera el padron de OSPCE , mediante archivos pasados y lo incorpora a la tabla General( PADCABE) y tablas Derivadas
*               Instanciado por el Formulario frmPadronOSPEC.scx
**********************************************************************
*

*!*	*-- Obtenemos el directorio por defecto donde se ejecuta el programa
*!*	cDireDefa 	= Fullpath(Curdir())

*!*	*--Instancio la clase para procesar los mails de web
*!*	oConsultaPadronOSPEC = Newobject("cGeneroPadronOSPEC",cDireDefa + "sp_GeneroPadronOspec.prg")
*!*	oConsultaPadronOSPEC.GeneroDatos()
*!*	oConsultaPadronOSPEC.DesConexionMotor()

*!*	*-- Falla el borrado de la carga por integridad referencial
*!*	oConsultaPadronOSPEC.Borrar_Carga()

*-- Defino la clase de Generacion e incorporacion al padron de los datos de OSPEC
Define Class cGeneroPadronOSPEC As Custom && ControlConexion
	cPAthArchivo  = '' 				&& Indica el path de busqueda o donde esta situado el ejecutable
	lDisconnect  = .F.				&& Indica si esta conectado
	nConexionSQL = 0 				&& Contiene Nro. Conexion al motor
	dFechaServer = {}				&& Contiene Fecha Servidor
	dFechaInicio = '' 				&& Contiene la fecha de Inicio del proceso (Lanzamiento del ejecutable )
	dFechaFinal = '' 				&& Contiene la fecha de Final del proceso (Lanzamiento del ejecutable ) - Se calcula antes del envio del mail
	nContadorArchivos = 0 			&& Contiene el total de archivos prcesados
	nDatosNovedades = 0 				&& Contieen los datos nuevos que se incorporarn al Padron
	nDatosExistentes = 0 			&& Contiene los datos de los ya existentes en el padron
	nVeces = 0

***************************************************************************************************
*  Procedure : Init
***************************************************************************************************
*  Parameters  :
*  Description :   Iniciio de Procedimiento
***************************************************************************************************
*
	Procedure Init()

*-- Seteo formato de fecha , esta haciendo lio
	Set Date Dmy

*-- Directorio donde reside el Ejecutable
	This.cPAthArchivo = Fullpath(Curdir())

*-- Verificacion de rigos si esta conextado
	If !Used("mwkserver1")
		Do sp_conexion
		This.lDisconnect = .T.
	Endif

*-- Guardo la conexion en una propiedad de la clase
	This.nConexionSQL = mCon1

*-- Busco la Fecha del Servidor y Guardo en Propiedad de la clase - Mato cursor generado
	This.dFechaServer = sp_busco_fecha_serv('DD')
	If Used('MWKFecServ')
		Use In(Select('MWKFecServ'))
	Endif

*-- Fecha Inicio Proceso o lanzamiento del ejecutable
	This.dFechaInicio = Dtoc( This.dFechaServer )+" - "+Time() 		&& +" - Inicio Proceso "

*-- Control de Errores
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
	Use In( Select('mwkDatosExcel') )

	If This.lDisconnect = .T.
		Do sp_Desconexion() 										&& WITH thisform.name
	Endif

	Endproc

*///////////////////////////////

***************************************************************************************************
*  Procedure : GeneroDatos
***************************************************************************************************
*  Parameters  :
*  Description :   Obtengo datos de lso archivos enviados - excel  y los incorporo al motor de datos
***************************************************************************************************
*
	Procedure GeneroDatos( tcArchivoExcel As String ,nVeces As Integer)
*-- Subo a Tablas del motor PADCABE , PADDOCUMENTOS , PADDOMICILIO

	This.nVeces = nVeces

	If This.ObtengoDatosExcel( tcArchivoExcel )

		If This.ProcesoFinal()
			Wait Windows 'Proceso Finalizado con Éxito para el Archivo : ' + tcArchivoExcel Timeout 10
		Else
			Messagebox("Se cancela la actualización.",16,"Verificar")
		Endif

	Else
*-- No se obtubieron datos de Excel
	Endif

	Endproc

***************************************************************************************************
*  Procedure : ObtengoDatosEcxel
***************************************************************************************************
*  Parameters  :
*  Description :   Leo los datos del Excel y cargo en cursos para procesarlos
***************************************************************************************************
*
	Procedure ObtengoDatosExcel( tcArchivoExcel As String )

*-- Cargo otros datos para búsqueda y reemplazo
	This.OtrasTablas()

*-- Cursor para contener datos de planilla Excel - CUIDADO La fecha de nacimiento se convierte mal
	Create Cursor mwkDatosExcel( cApellido C(50) , cApeyNom C(50), nCUIL N(15), nCredencial I, nDocumento I, nEntidad I, ;
		dFecEgreso D, dFecIngreso D,;
		dFecNac D, nGrupoFamiliar N(10), cDomicilio C(50), cLocalidad C(50), cOficina C(50), cNombre C(50) , nNroAfiliado N(10) , ;
		nPlan I , cSexo C(12), nTipoDocumento I )

	Private llProceso_Ok As Logical
*
	Local lnNroAfiliado ,;
		lcNombre           ,;
		lcSexo			  ,;
		lcDocumento_Tipo   ,;
		lcDocumento_Nro    ,;
		ldFechaNacimiento  ,;
		lcDomicilio        ,;
		lcLocalidad        ,;
		lcOficina

	llProceso_Ok = .F.

*//////////////////////////////////////////////////////////////////////////////////////////////////
*  Apertura de la planilla de Excel para prorcesarla
*//////////////////////////////////////////////////////////////////////////////////////////////////

*-- Levantamos la aplicacion de Excel
	oExcel = Createobject("Excel.Application")
* oExcel.Visible = .T.

*-- oExcel.SheetsInNewWorkbook = 4
* lcArchivoExcel = Getfile("XLS")

*-- Como ahora es automatico los nombre de los archivos vienen por parámetros
	lcArchivoExcel = tcArchivoExcel

*-- oWorkbook = oExcel.Workbooks.Open("C:\desaguemes\Padron_OSPEC\Documentos\PADRONCAPITAL_0921.xls")
	oWorkbook = oExcel.Workbooks.Open( lcArchivoExcel )

	A = 6
	For A = 6 To 1000
		With oExcel.Sheets[1]
			lCeldaA = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
*-- Antes (Primera Planilla) If Isnull( lCeldaA ) Or lCeldaA == 'num. benef.'
			If Isnull( lCeldaA ) Or Lower(lCeldaA) == 'numero'
* Exit
				Loop 					&& Devuelvo el control al For
			Else

				lnNroAfiliado      = Evaluate( '.Range("A'+ Alltrim( Str( A ) ) +':' + 'A' + Alltrim( Str( A ) ) + '").Value' )
				lcNombre           = Evaluate( '.Range("B'+ Alltrim( Str( A ) ) +':' + 'B' + Alltrim( Str( A ) ) + '").Value' )
				lcSexo			  = Evaluate( '.Range("C'+ Alltrim( Str( A ) ) +':' + 'C' + Alltrim( Str( A ) ) + '").Value' )
				lcDocumento_Tipo   = Evaluate( '.Range("D'+ Alltrim( Str( A ) ) +':' + 'D' + Alltrim( Str( A ) ) + '").Value' )
				lcDocumento_Nro    = Evaluate( '.Range("E'+ Alltrim( Str( A ) ) +':' + 'E' + Alltrim( Str( A ) ) + '").Value' )
				ldFechaNacimiento  = Evaluate( '.Range("F'+ Alltrim( Str( A ) ) +':' + 'F' + Alltrim( Str( A ) ) + '").Value' )
				lcDomicilio        = Evaluate( '.Range("G'+ Alltrim( Str( A ) ) +':' + 'G' + Alltrim( Str( A ) ) + '").Value' )
				lcLocalidad        = Evaluate( '.Range("H'+ Alltrim( Str( A ) ) +':' + 'H' + Alltrim( Str( A ) ) + '").Value' )
				lcOficina          = Evaluate( '.Range("I'+ Alltrim( Str( A ) ) +':' + 'I' + Alltrim( Str( A ) ) + '").Value' )

				Select mwkDatosExcel
*-- Cargo los datos al cursor generado para contener los datos
				Append Blank
				Go Bottom

*   Create Cursor mwkDatosExcel( cApellido C(50) , cApeyNom C(50), nCUIL N(15), nCredencial I, nDocumento I, nEntidad I, dFecEgreso D, dFecIngreso D,;
*      dFecNac D, nGrupoFamiliar N(10), cDomicilio C(50), cLocalidad C(50), cOficina C(50), cNombre C(50) , nNroAfiliado N(10) , nPlan I , cSexo C(12), nTipoDocumento I )

				Replace ;
					nNroAfiliado  With Int( Val( lnNroAfiliado ) ) ,;
					nGrupoFamiliar With Int( Val( lnNroAfiliado ) ) ,;
					cApeyNom With lcNombre         ,;
					cSexo With Alltrim( lcSexo )   ,;
					nDocumento With lcDocumento_Nro

*-- Busco el código del documento
				If Not Empty(lcDocumento_Tipo)
					Select mwkDocumentos
					Locate For Alltrim( Abrevio ) = Alltrim( lcDocumento_Tipo )
					If Found()
						Replace nTipoDocumento With mwkDocumentos.Id In mwkDatosExcel
					Else
						Replace nTipoDocumento With 0
					Endif
				Endif

				Select mwkDatosExcel							&& Cursor con datos pasados de Excel

*-- Domicilio puede venir en cero
				If .Not. Isnull(lcDomicilio )
					If Vartype( lcDomicilio ) = 'N'
						Replace cDomicilio With ''
					Else
						Replace cDomicilio With Upper( lcDomicilio )
					Endif
				Endif

*-- Localidad puede venir en cero
				If .Not. Isnull( lcLocalidad )
					If Vartype( lcLocalidad ) = 'N'
						Replace cLocalidad With ''
					Else
*-- Substraigo el principal string antes de la coma - Ejemplo : CAPITAL FEDERAL, CABA, CIUDAD AUTONOMA DE BS AS
*-- Si no se encunetra la coma reemplazo lo que contenga el campo
						lcLocalidad1 = Iif( At(',',lcLocalidad  ) = 0 , ;
							lcLocalidad ,  ;
							SUBSTR( lcLocalidad  ,1, At(',', lcLocalidad  )-1 ) )
*-- Reemplazo en el cursor final
						Replace cLocalidad With Upper( lcLocalidad1 )
					Endif
				Endif

*-- La fecha Nacimiento puede venir vacia
				If Empty( ldFechaNacimiento ) Or Isnull( ldFechaNacimiento )
					Replace dFecNac  With {  /  /    }
				Else
					Replace dFecNac  With  Ctod( ldFechaNacimiento )
				Endif

* CTOD( SUBSTR( ldFechaNacimiento,1,2 ) + '/' + SUBSTR(ldFechaNacimiento,4,2) +'/' + SUBSTR(ldFechaNacimiento,7,4) )
				Replace ;
					cOficina With  lcOficina         ,;
					nEntidad With 5 ,;
					dFecEgreso With Ctod('01/01/2100') ,;
					dFecIngreso With This.dFechaServer
			Endif

		Endwith

	Endfor

*-- Si proceso Ok cambio la bandera
	llProceso_Ok = .T.
*-- Cerramos excel que se abrio recientemente
	oExcel.Quit
*-- Matamos el objeto excel
	oExcel = .Null.

*-- Retorno si se proceso o no para seguir
	Return llProceso_Ok

	Endproc

***************************************************************************************************
*  Procedure : ProcesoFinal
***************************************************************************************************
*  Parameters  :
*  Description :   Cuando tengo los datos de excel proceso la información enviandola al motor de datos
***************************************************************************************************
*
	Function ProcesoFinal( )

	Local lOk
	Local nNroAfiliadoBusca

* -- Marcelo Torres, 06/10/2023
* -- Ponemos fecha de hoy a todos los registros de la entidad en PADCABE
	Wait Windows "Actualizando Fecha de Egreso, aguarde ..." Nowait

* -- Pasivamos la primera vez (vienen Capital y Conurbano
	If This.nVeces = 1
		lcCMDSQL = "update PadCabe set FecEgreso = ?This.dFechaServer " +;
			"WHERE Entidad = 5 and FecEgreso = '2100-01-001'"

		lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL )

		If lnReturn < 0
			=Aerror(lcArrayError)
			Messagebox("Fallo la Pasivación General (PadCabe) " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

	Endif

*-- Envio los datos de excel al Motor
	lOk = .T.
	nNroAfiliadoBusca = 0

*!*		If Used("mwkDatosExcel")
*!*			Messagebox("en uso")
*!*		Endif

	Select mwkDatosExcel
* GO top

	Scan
		Scatter Memvar
		Wait Windows ' Procesando Nro. de Afiliado : ' + Alltrim( Str( mwkDatosExcel.nNroAfiliado  )) Nowait Timeout 10
*-- Contiene el total de archivos procesados
		This.nContadorArchivos =  This.nContadorArchivos + 1

*//////////////
* 	Verifico que el Afiliado no este ya cargado en el padron
		m.nNroAfiliadoBusca = mwkDatosExcel.nNroAfiliado
		m.nDocumentoBusca = mwkDatosExcel.nDocumento

*-- Se da el caso de el grupo familiar por eso el control haciendolo por Nro de Afiliado solamente no carga los demas registros , controlo por Nro de documento tambien
		lcCMDSQL = 'SELECT * FROM PadCabe WHERE PadCabe.NroAfiliado = ?m.nNroAfiliadoBusca AND Padcabe.Documento = ?m.nDocumentoBusca and FecEgreso = ?This.dFechaServer '
		lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadcabe_Temp")

*-- Controlo si se ejecuto el comado SQL
		If lnReturn < 0
			=Aerror(lcArrayError)
			Messagebox("Fallo la consulta de datos (PadCabe) " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			lOk = .F.
			Exit
		Endif
*

		Select mwkPadcabe_Temp
		If Reccount('mwkPadcabe_Temp') > 0						&& Esta Cargado el Usuario
*-- Es usuario ya esta cargado
			Wait Windows ' El Afiliado ya existe en el Padrón (PadCabe) Controlando Otros Datos : ' + Alltrim( Str( mwkDatosExcel.nNroAfiliado  )) Nowait Timeout 10
* Use In(Select('mwkPadcabe_Temp'))

*-- Controlo los datos y tablas anexas
			This.ControlDatosPadCabe()
*-- Controlo la existencia de datos en otras tablas
			liIdPadCabe = mwkPadcabe_Temp.Id
			This.ControlPadAnexos( liIdPadCabe )

* Marcelo Torres, 06/10/2023
* Cambiamos la fecha de Egreso a 2100
			lcCMDSQL = "update PadCabe set FecEgreso = '2100-01-01' WHERE ID = ?liIdPadCabe"
			lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL)

			If lnReturn < 0
				=Aerror(lcArrayError)
				Messagebox("Fallo la Actualización de datos (PadCabe) " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				lOk = .F.
				Exit
			Endif

			This.nDatosExistentes = This.nDatosExistentes + 1 			&& Contiene los datos de los ya existentes en el padrón

		Else

*/////////////
*-- Cargamos el usuario por que no existe en el padron
			TEXT to lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
				INSERT INTO PadCabe ( NroAfiliado,
						ApeyNom,
						Documento,
					    Entidad,
						TipoDocumento,
						FecNac,
						FecEgreso,
						FecIngreso,
						GrupoFamiliar,
						Plan )
				VALUES ( ?m.nNroAfiliado ,
		                 ?m.cApeyNom ,
		                 ?m.nDocumento ,
		                 ?m.nEntidad ,
		                 ?m.nTipoDocumento ,
		                 ?m.dFecNac ,
		                 ?m.dFecEgreso ,
		                 ?m.dFecIngreso ,
		                 ?m.nNroAfiliado, 0 )
			ENDTEXT

			lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadcabe_Update")
*-- Controlo si se ejecuto el comado SQL
			If lnReturn < 0
				=Aerror(lcArrayError)
				Messagebox("Fallo la inserción de datos (PadCabe) " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
				lOk = .F.
				Exit
			Else

*-- Controlo la cantidad de datos nuevos ( Novedades ) incorporados
				This.nDatosNovedades = This.nDatosNovedades + 1  										&& Contieen los datos nuevos que se incorporarn al Padron

*-- Identificador de ultima carga para relacionar PADDomicilio y PADDocumento
				lcCMDSQL= "SELECT Id FROM Padcabe WHERE Padcabe.nroAfiliado = ?m.nNroAfiliado AND Padcabe.Documento = ?m.nDocumento AND Padcabe.FecIngreso = ?m.dFecIngreso "
				lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadcabeTempID")

*-- Asignamos el valor del Id devuelto en la consulta
				lidIdentificador = mwkPadcabeTempID.Id

*//////////////////
*-- Insercion de tabla anexa Documentos
				TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
            		INSERT INTO PadDocumentos ( Documento, FechaDesde, FechaHasta, IdPadCabe, TipoDocumento )
				                    VALUES( ?m.nDocumento, ?m.dFecIngreso, ?m.dFecEgreso, ?lidIdentificador, ?m.nTipoDocumento  )
				ENDTEXT

				lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadcDocumentosTemp")

				If lnReturn < 0
					=Aerror(lcArrayError)
					Messagebox("Fallo la Inserción de datos en PadDocumentos " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					lOk = .F.
					Exit
				Endif

*-- Saco la localidad para cargarla en el campo
				If Upper( Alltrim( m.cLocalidad ) ) <> 'CAPITAL FEDERAL'

*-- Si no se encunetra la coma reemplazo lo que contenga el campo
					lcLocalidad = Iif( At(',', m.cLocalidad ) = 0 , ;
						m.cLocalidad ,  ;
						SUBSTR( m.cLocalidad  ,1, At(',', m.cLocalidad  )-1 ) )

* Antes : lcLocalidad = Substr( m.cLocalidad , 1, ( At( ',' , m.cLocalidad , 1 )) -1 ) 					&& Monte Grande

*-- Busco el código postal por localidad
					Select mwkLocalidades
					Locate For Alltrim( mwkLocalidades.Descrip ) = Upper( Alltrim( lcLocalidad ) )
					If Found()
						lcCodPostal = mwkLocalidades.CodPostal
					Else
						lcCodPostal = '0'
					Endif

				Else
*-- SI no tengo que descomponer el string para sacar la localidad, la coloco directamente
					lcLocalidad = Alltrim( m.cLocalidad )
					lcCodPostal = '1001'
				Endif

*//////////////////
*-- Ingresamos los datos en PadDomicilio
				TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
					INSERT INTO PadDomicilio ( Codigo, Domicilio , FechaDesde, FechaHasta, IdPadCabe,  Localidad , Provincia )
					VALUES ( ?lcCodPostal, ?m.cDomicilio , ?m.dFecIngreso, ?m.dFecEgreso , ?lIdIdentificador , ?lcLocalidad , 'BUENOS AIRES' )
				ENDTEXT

				lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadDomicilioTemp")

				If lnReturn < 0
					=Aerror(lcArrayError)
					Messagebox("Fallo la Inserción de datos en PadDomicilio " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					lOk =.F.
					Exit
				Endif

*//////////////////
*-- Ingresamos los datos en PadVigencia
				TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
		             INSERT INTO PadVigencia ( FechaDesde, FechaHasta, IdPadCabe )
						VALUES ( ?m.dFecIngreso, ?m.dFecEgreso , ?lIdIdentificador )
				ENDTEXT

				lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadVigenciaTemp")

				If lnReturn < 0

					=Aerror(lcArrayError)
					Messagebox("Fallo la Inserción de datos en PadVigencia " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					lOk =.F.
					Exit
				Endif

*//////////////////
*-- Ingresamos los datos en Padotrosdatos
				lcCMDSQL = ''
				TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
                INSERT INTO Padotrosdatos ( Campo, Contenido, FechaDesde, FechaHasta, IdPadCabe )
               					   VALUES ( 'OBRASOC' , 'OSPEC' , ?m.dFecIngreso, ?m.dFecEgreso , ?lIdIdentificador )
				ENDTEXT

				lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadotrosdatosTemp")

				If lnReturn < 0
					=Aerror(lcArrayError)
					Messagebox("Fallo la Inserción de datos en PadVigencia " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					lOk = .F.
					Exit
				Endif


			Endif

*//////////////
		Endif    && Fin de si esxite el afiliado cargado o no

	Endscan

	Return lOk

	Endfunc

***************************************************************************************************
*  Procedure : ControlDatosPadCabe
***************************************************************************************************
*  Parameters  :
*  Description :   Se encontro el Afiliado asi que controlo los datos que pueden variar y ls tablas anexas
***************************************************************************************************
*
	Procedure ControlDatosPadCabe( )

*-- Declaracion de variables
	Local llOkDatos

	llOkDatos = .T.

*-- Saco del la consulta PadCabe_Temp el ID pra hacer Udpdate
	Select mwkPadcabe_Temp
	lidIdentificador = mwkPadcabe_Temp.Id

*-- Selecciono los datos levantados de Excel y hago Update de datos quepuedan haber cambiado
	Select mwkDatosExcel
	Scatter Memvar

*-- Saco la localidad para cargarla en el campo
	If Upper( Alltrim( m.cLocalidad ) ) <> 'CAPITAL FEDERAL'
		lcLocalidad = Substr( m.cLocalidad , 1, ( At( ',' , m.cLocalidad , 1 )) -1 ) 					&& Monte Grande
* ? SUBSTR( m.cDomicilio , AT( ',' , m.cDomicilio ,1 ) + 2 , AT( ',' , m.cDomicilio , 2 ) - AT( ',' , m.cDomicilio , 1 ) )
*-- Busco el código postal por localidad
		Select mwkLocalidades
		Locate For Alltrim( mwkLocalidades.Descrip ) = Upper( Alltrim( lcLocalidad ) )
		If Found()
			lcCodPostal = mwkLocalidades.CodPostal
		Else
			lcCodPostal = '0'
		Endif
	Else
*-- SI no tengo que descomponer el string para sacar la localidad la coloco directamente
		lcLocalidad = Alltrim( m.cLocalidad )
		lcCodPostal = '1001'
	Endif

*-- Verifico si el registro esta dado de alta
	lnReturn =  SQLExec( This.nConexionSQL, ;
		'SELECT IdPadCabe FROM PadDomicilio WHERE PadDomicilio.IdPadCabe = ?lIdIdentificador ', ;
		"mwkPadDomicilioTemp1")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la Inserción de datos en PadDomicilio " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		llOkDatos = .F.
	Endif

	lcCMDSQL = ''
	If Reccount("mwkPadDomicilioTemp1") = 0
*-- Ingresamos los datos en PadDomicilio
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
					INSERT INTO PadDomicilio ( Codigo, Domicilio , FechaDesde, FechaHasta, IdPadCabe,  Localidad , Provincia )
					VALUES ( ?lcCodPostal, ?m.cDomicilio , ?m.dFecIngreso, ?m.dFecEgreso , ?lIdIdentificador , ?lcLocalidad , 'BUENOS AIRES' )
		ENDTEXT
	Else
*-- Hacemos Update de los datos en PadDomicilio
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
					UPDATE PadDomicilio SET
					Codigo = ?lcCodPostal,
					Domicilio = ?m.cDomicilio ,
					Localidad = ?lcLocalidad
					Where PadDomicilio.IdPadCabe = ?lIdIdentificador
		ENDTEXT
	Endif

	lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadDomicilioTemp2")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la Inserción de datos en PadDomicilio " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif

	Return llOkDatos

	Endproc

***************************************************************************************************
*  Procedure : ControlPadAnexos
***************************************************************************************************
*  Parameters  :
*  Description :   Se encontro el Afiliado asi que controlo los datos que pueden variar y ls tablas anexas
***************************************************************************************************
*
	Procedure ControlPadAnexos( tiIdPadCabe As Image )

	Private liPadcabeID

	llOkDatos = .T.

*-- Paso el parametros a la variable privada pra armar la consultas
	m.liPadcabeID = tiIdPadCabe
	lnReturn = SQLExec( This.nConexionSQL, "SELECT PadDocumentos.IdPadCabe FROM PadDocumentos WHERE PadDocumentos.IDPadcabe = ?m.liPadcabeID " ,"mwkPadDocumentosTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la consulta para PadDocumentos " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif

	If Reccount('mwkPadDocumentosTemp') = 0
*//////////////////
*-- Insercion de tabla anexa Documentos
		TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
            		INSERT INTO PadDocumentos ( Documento, FechaDesde, FechaHasta, IdPadCabe, TipoDocumento )
				                    VALUES( ?m.nDocumento, ?m.dFecIngreso, ?m.dFecEgreso, ?m.liPadcabeID, ?m.nTipoDocumento  )
		ENDTEXT
	Else
		TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
            		UPDATE PadDocumentos SET
            		Documento = ?m.nDocumento,
            		FechaDesde = ?m.dFecIngreso,
            		FechaHasta = ?m.dFecEgreso,
             		TipoDocumento = ?m.nTipoDocumento
             		WHERE PadDocumentos.IDPAdCabe = ?m.liPadcabeID
		ENDTEXT
	Endif

	lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadDocumentosTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Falló la Actualización - PadDocumentos " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif

*///////////////
*-- Ingresamos los datos en PadVigencia
	lnReturn = SQLExec( This.nConexionSQL, "SELECT PadVigencia.IdPadCabe FROM PadVigencia WHERE PadVigencia.IDPadcabe = ?m.liPadcabeID " ,"mwkPadVigenciaTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la consulta para PadVigencia " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif
*
	lcCMDSQL  = ''
	If Reccount('mwkPadVigenciaTemp') = 0
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
		             INSERT INTO PadVigencia ( FechaDesde, FechaHasta, IdPadCabe )
						VALUES ( ?m.dFecIngreso, ?m.dFecEgreso , ?m.liPadcabeID )
		ENDTEXT
	Else
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
		             UPDATE PadVigencia SET
		             FechaDesde = ?m.dFecIngreso,
		             FechaHasta = ?m.dFecEgreso
		             WHERE PadVigencia.IDPAdCabe = ?m.liPadcabeID
		ENDTEXT
	Endif

	lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadVigenciaTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Falló la Actualización - PadVigencia " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif
*///////////////
*-- Controlamos los datos de Padotrosdatos

	lnReturn = SQLExec( This.nConexionSQL, "SELECT Padotrosdatos.IdPadCabe FROM Padotrosdatos WHERE Padotrosdatos.IDPadcabe = ?m.liPadcabeID " ,"mwkPadotrosdatosTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la consulta para Padotrosdatos " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif

	lcCMDSQL  = ''
	If Reccount('mwkPadotrosdatosTemp' ) = 0
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
                INSERT INTO PadOtrosDatos ( Campo, Contenido, FechaDesde, FechaHasta, IdPadCabe )
               					   VALUES ( 'OBRASOC' , 'OSPEC' , ?m.dFecIngreso, ?m.dFecEgreso , ?m.liPadcabeID )
		ENDTEXT
	Else
		TEXT TO lcCMDSQL TEXTMERGE  NOSHOW  PRETEXT 7
                UPDATE PadOtrosDatos SET
                Campo = 'OBRASOC' ,
                Contenido = 'OSPEC' ,
                FechaDesde = ?m.dFecIngreso,
                FechaHasta = ?m.dFecEgreso
                WHERE Padotrosdatos.IDPAdCabe = ?m.liPadcabeID
		ENDTEXT
	Endif

	lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL ,"mwkPadotrosdatosTemp")

	If lnReturn < 0
		=Aerror(lcArrayError)
		Messagebox("Fallo la Actualización - PadOtrosDatos " + Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
* Return .F.
		llOkDatos = .F.
	Endif

	Return llOkDatos

	Endproc

***************************************************************************************************
*  Procedure    : OtrasTablas
***************************************************************************************************
*  Parameters  :
*  Description :   Traigo datos de tablas anexa - Documentos, Codigo Postal
***************************************************************************************************
*
	Procedure OtrasTablas()

*-- Armmamos estructura de tabla TabDocumentos para llenarla posteriormente
	lcCMD_SQL = "SELECT TabDocumentos.ID, TabDocumentos.Abrevio, TabDocumentos.Codigovax, TabDocumentos.Descrip FROM TabDocumentos "

*-- Ejecuto la consulta al motor
	lnReturn1 = SQLExec( This.nConexionSQL , lcCMD_SQL , 'mwkDocumentos')

	If lnReturn1 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para Documentos "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

*-- Traemos la tabla de Localidades
	lcCMD_SQL3 = "SELECT CodPostal, Descrip, IdProvincia FROM TabLoca1 "+ ;
		" WHERE Idprovincia = 2 "+;
		" ORDER BY Descrip "

*-- Ejecutamos la Consulta
	lnReturn3 = SQLExec( This.nConexionSQL , lcCMD_SQL3 , 'mwkLocalidades')

	If lnReturn3 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para Localidades "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Return .T.

	Endproc


***************************************************************************************************
*  Procedure : EnvioMail
***************************************************************************************************
*  Parameters  :
*  Description :   Envio un mail con las notificaciones de los procesos de actualizacion
***************************************************************************************************
*
	Procedure ArmoMail()

*-- Verifico si esta corriendose compilado o interpretado - Envio de mails
	If ( Version(2) = 2 )
		Do sp_busco_estados With 4,' and Tipo = 49 and Estado = 1 ','mwkmails'				&& Desarrollo
	Else
		Do sp_busco_estados With 4,' and Tipo = 45 and Estado=1 ','mwkmails'				&& Prodcucción
	Endif

*-- Fianal del proceso par reportar
	This.dFechaFinal = Dtoc( This.dFechaServer )+" - "+Time()      									&& +" - Fin Proceso "

*-- Asunto del correo para identificarlo
	mAsunto = "Proceso Automático OBRA SOCIAL OSPEC - Fecha : " +  Dtoc( This.dFechaServer ) && Dtoc( This.dFechaServer )

*-- Armo el cuerpo del mail Mail
	memomail = ''
	memomail = memomail + '' + '<br>'
	memomail = memomail + 'INCORPORACION DEL PADRON DE LA OBRA SOCIAL OSPEC, AL PADRON DEL SISTEMA CEDI '+'<br>'
	memomail = memomail + '--------------------------------------------------------------'+'<br>'
	memomail = memomail + 'Fecha Procesos de Datos   : '  + Alltrim( Dtoc( This.dFechaServer ) )+'<br>'
	memomail = memomail + 'Total de Datos Procesados : ' + Alltrim( Str( This.nContadorArchivos ) ) + '<br>'
	memomail = memomail + 'Total de Datos con Novedades  : ' + Alltrim( Str( This.nDatosNovedades ) ) + '<br>'
	memomail = memomail + 'Total de Datos sin Novedades  : ' +  Alltrim( Str( This.nDatosExistentes ) ) + '<br>'
	memomail = memomail + '' + '<br>'
	memomail = memomail + 'Tiempo - Inicio : ' + This.dFechaInicio + ' Final de Proceso : ' + This.dFechaFinal

* Strtofile( memomail , 'CuerpoMail.txt' )
	Strtofile( memomail , 'Cuerpo_HTM.HTM' )

*-- Para todos los que estan en el listado de recibir mail
	Select mwkmails
	Scan

		mRecibe = Alltrim( mwkmails.Descrip )
*-- Para no llenarle la casilla de Mail de Carmen con tantas corridas valido el Mail
		If mRecibe  <> Alltrim( 'calvarez@sg.com.ar ' )
			Wait Windows 'Envio de Mail para :' + mRecibe Timeout 10
*-- Paso los valores para quien recibe el mail
			If This.EnvioViaMail( mRecibe , mAsunto, memomail )
				Return .T.
			Else
				Return .F.
			Endif
		Endif

	Endscan

	Endproc

***************************************************************************************************
*  Procedure : EnvioviaMail
***************************************************************************************************
*  Parameters  :
*  Description :   Envio un mail con archivo comprimido
***************************************************************************************************
*
	Procedure EnvioViaMail( mRecibe , mAsunto, memomail )
* Parameters mRecibe , mAsunto, MemoMail

	Local loCfg, loMsg, lcFile, loErr, lcNomArchivo As String

	llOkEnvio = .T.

*-- Creo el Objeto CDO para las salidas de mail
	Try
		loCfg = Createobject("CDO.Configuration")

		With loCfg.Fields
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
			.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
			.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "dl380@sg.com.ar"
			.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "servidor380"
			.Update()
		Endwith

		loMsg = Createobject ("CDO.Message")

		With loMsg
			.Configuration = loCfg

*-- Remitenete y destinatarios
			.From = "dl380@sg.com.ar"        	     				&& Acá poné lo que quieras mostrar al destinatario
* .To   = 'etkachuk@sg.com.ar'  						&& Acá va el destinatario

			.To = mRecibe 											&& lcListaDestinatarios
			.Cc   = '' 												&& lccopia Acá va si querés copiar a alguien

*///////////////////////////////////////////////// Saque la confiramcion de lectura 12/08/2021
*!*	      *- Notificación de lectura
*!*	      .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
*!*	      .Fields("urn:schemas:mailheader:return-receipt-to") = .From
*!*	      .Fields.Update()

*- Prioridad		-1=Low, 0=Normal, 1=High
			.Fields("urn:schemas:httpmail:priority") = 1
			.Fields("urn:schemas:mailheader:X-Priority") = 1

*- Importancia     0=Low, 1=Normal, 2=High
			.Fields("urn:schemas:httpmail:importance") = 2
			.Fields.Update()

*-- Tema
			.Subject = mAsunto      && Titulo o Cabecera del Mail

			lcFile = Strtofile( memomail , Fullpath( Curdir() ) + "Cuerpo_HTM.HTM" )
			lcFileHTML = Filetostr( Fullpath( Curdir() ) + "Cuerpo_HTM.HTM")

*--- Si se quiere usar HTML, se agrega el contenido HTML
			If !Empty(lcFileHTML)
* lcHTML = Fullpath( Curdir() ) + "Cuerpo_HTM.HTM"
* .CreateMHTMLBody("file://" + lcHTML, 31 )

* .CreateMHTMLBody("file://" + lcFileHTML, 31 )

*-- Formato HTML desde la Web
&&  .CreateMHTMLBody( MemoMail , 0)
&& .TextBody = MemoMail
				.HTMLBody = memomail

			Endif

*-- Archivo adjunto
			If File( lcFileHTML )
*   .AddAttachment( lcHTML )
			Endif

*-- Envio el mensaje
			.Send() 										&&  Envío

		Endwith

	Catch To oError

		=Messagebox("No se pudo enviar el Mail verifique la composición del mismo " + Chr(13) + ;
			"Mensaje: " + oError.Message+Chr(13)+;
			"Error #:"+Transform(oError.ErrorNo)+Chr(13)+;
			"Line  #:"+Transform(oError.Lineno)+Chr(13)+;
			"Error #:"+Transform(oError.LineContents),48,"Error")

*-- Enviamos el Ojeto oError para grabar el Log de Errores
* Do lcPathDefault + log_errores With Transform(oError.ErrorNo), oError.Message, Transform(oError.Lineno), Program(), Transform(oError.LineContents)

* menviado = 0
		llOkEnvio = .F.

	Finally

		loMsg = .Null.
		loCfg = .Null.
	Endtry

*-- Devuelvo el estado del envio
	Return llOkEnvio
	Endproc

*/////////////////////////////////////////////////////////////////////////////////

***************************************************************************************************
*  Procedure : BorraEnCascada
***************************************************************************************************
*  Parameters  :
*  Description :   Borro los datos ingresado en cascada para no llenar de basura las tablas en el motor
***************************************************************************************************
*
	Procedure BorraEnCascada()

* select * from PadCabe order by Id desc
	Delete From Padcabe Where documento = 96058164 && DNI 96058164

* select * from PAddocumentos order by Id desc
	Delete From PAddocumentos Where documento = 96058164

*  Select * from Paddomicilio order by Id desc 		- delete from Paddomicilio where id = 2139932
	Delete From Paddomicilio Where Id = 2139932

* select * from PadVigencia order by Id desc
	Delete From PadVigencia Where IDpadCabe = 1438452


	Endproc


***************************************************************************************************
*  Procedure : Borrar_carga
***************************************************************************************************
*  Parameters  :
*  Description :   Borro los datos ingresado Por Tablas hasta llegar a PAdCabe
***************************************************************************************************
*
	Procedure Borrar_Carga()

	lcCMD_SQL1 = "Delete From Paddomicilio " +;
		" Where Paddomicilio.IDpadCabe In ( Select Padcabe.Id From Padcabe Where Padcabe.cuil Is Null ) "

*-- Ejecutamos la Consulta
	lnReturn1 = SQLExec( This.nConexionSQL , lcCMD_SQL1 , 'mwkPaddomicilio')

	If lnReturn1 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para Paddomicilio "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	lcCMD_SQL2 = "Delete From PadVigencia "+;
		" Where PadVigencia.IDpadCabe In (Select Padcabe.Id From Padcabe Where Padcabe.cuil Is Null ) "

*-- Ejecutamos la Consulta
	lnReturn2 = SQLExec( This.nConexionSQL , lcCMD_SQL2 , 'mwkPadVigencia')

	If lnReturn2 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para PadVigencia "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	lcCMD_SQL3 = "Delete From PADOtrosDatos "+;
		"Where PADOtrosDatos.IDpadCabe In ( Select Padcabe.Id From Padcabe Where Padcabe.cuil Is Null ) "

*-- Ejecutamos la Consulta
	lnReturn3 = SQLExec( This.nConexionSQL , lcCMD_SQL3 , 'mwkPADOtrosDatos')

	If lnReturn3 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para Localidades "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	lcCMD_SQL3 = "Delete From PAddocumentos "+;
		"Where PAddocumentos.IDpadCabe In ( Select Padcabe.Id From Padcabe Where Padcabe.cuil Is Null ) "

*-- Ejecutamos la Consulta
	lnReturn3 = SQLExec( This.nConexionSQL , lcCMD_SQL3 , 'mwkPAdDocumentos')

	If lnReturn3 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para Localidades "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	lcCMD_SQL4 = "Delete from PAdcabe " +;
		"where PadCabe.Cuil is Null AND " +;
		"FecIngreso = '2022-01-10' and " + ;
		"PAdCabe.Id Not in ( Select IDpadcabe from PadVigencia ) "

*-- Ejecutamos la Consulta
	lnReturn4 = SQLExec( This.nConexionSQL , lcCMD_SQL4 , 'mwkPadCabe_Temp')

	If lnReturn4 < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
		=Aerror(lcArrayError)
		Messagebox("Fallo la Consulta para PadCabe_Temp "+ Chr(13) + Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Endproc

Enddefine







