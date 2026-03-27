**********************************************************************
* Program....: SP_GENEROPAGOFACIL.PRG
* Version....: 1.0
* Author.....: Eduardo E. Tkachuk
* Date.......: 04 June 2021, 20:42:35
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 04 June 2021 / 20:42:35
* Purpose....:		Genera un archivo TXT con datos de afiliados (Padrón OSUTHGRA ) y lo
*                   envia comprimido a Pago Facil via mail o via SFTP
**********************************************************************
* Main IniOperacionCarga
*
Define Class cGeneroPagoFacil As Custom

	nConexionSQL	= 0 							&& Contiene el Nro. de conexion para esta clase
	dFechaServer = {}							&& Contiene la fecha del servidor
	lDisconnect = .F.							&& Indica si esta conectado y debe desconectar
*
	cAsuntoMail = ''								&& Contiene el Asunto del mail para enviar
	cMemoMail = ''								&& Cuerpo de _Mail (Datos de procesamiento/archivo)
	cCuentaMail1 = '' 							&& Quien recibe o destinatarios de Mail
	cCuentaMail2 = '' 							&& Quien recibe o destinatarios de Mail
	cCuentaMail3 = '' 							&& Quien recibe o destinatarios de Mail
*
	cViaFTP  = 'OFF' 							&& Contiene si se envia via FTP (ON/OFF)
	cViaMail = 'OFF' 						    && Contiene si se envia via Mail (ON/Off)
*
	cFormatoEnvio = '' 						    && Contiene elformato de envio Zip o archivo comprimirdo PGP
*
	cPAthArchivo = '' 						    && Contiene el PAth o carpeta donde reside el Ejecutabe
*
	cNombreArchivo = '' 							&& Contiene el nombre del Archivo físico tanto .ONL como Zip
	CRLF = Chr(13)+Chr(10)						&& Corresponde a saltos de line y retorno de carro

***************************************************************************************************
*  Procedure : Init
***************************************************************************************************
*  Parameters  :
*  Description :   Iniciio de Procedimiento
***************************************************************************************************
*
	Procedure Init()

*-- Directorio donde reside el Ejecutable
	This.cPAthArchivo = Fullpath(Curdir())

*-- Verificacion de rigos si esta conextado
	If !Used("mwkserver1")
		Do sp_conexion
		This.lDisconnect = .T.
	Endif

*-- Guardo la conexion en una propiedad de la clase
	This.nConexionSQL = mCon1

	This.dFechaServer = sp_busco_fecha_serv('DD')
* This.cInicioCorrida = Time()

	Endproc

*//////////////////////////////////
***************************************************************************************************
*  Procedure : GeneroDatosEnvio
***************************************************************************************************
* Parameters  :
* Description : Genero los datos para enviar y configuro el medio de envio
***************************************************************************************************
*
	Procedure GeneroDatosEnvio()

*//////////////////////////////////////////////////////////////////////
*!*
*!*		En la tabla SQLUser.PadOtrosDatos, en CAMPO = 'OBRASOC' en CONTENIDO aparece los planes de los afiliados, estos son los planes existentes para cada obra social
*!*		con el IdPadCabe del afiliado de la tabla PadCabe, obtenes el dato que necesitas si es gastro o monotributo
*!*		GASTRO = gastronómico general
*!*		GASMBA = monotributo
*!*		ambas son entidad 948

*/////////////////////////////////////////////////////////////////////
*!* CODIGO DE SEPSA : (Código de entidad) 90063000

	* Set Step On

*-- Variables locales
	Local lcCMD_SQL As String , lnReturn As Number , lcCMDSQL As String , lcAnioEnDias As String

*-- Capturo la configuracion de los datos a enviar
	If This.CapturaConfiguracion()

*-- Creo los cursores Finales con los datos de Salida
		This.CreoCursoresSalida()

*-- Armamos el set de datos de Afiliados por fecha de Egreso (OSUTHGRA y Monotributistas) para la Entidad 948
		lcCMD_SQL = ''
		TEXT TO lcCMD_SQL TEXTMERGE NOSHOW PRETEXT 7
					SELECT Padcabe.ID,
					  Padcabe.Apellido, Padcabe.ApeyNom, Padcabe.CUIL, Padcabe.Credencial,
					  Padcabe.Documento, Padcabe.Entidad, Padcabe.FecEgreso,
					  Padcabe.FecIngreso, Padcabe.FecNac, Padcabe.GrupoFamiliar,
					  Padcabe.Nombre, Padcabe.NroAfiliado, Padcabe.NroAfiliadoAlternativo,
					  Padcabe.Plan, Padcabe.PlanAlternativo, Padcabe.Sexo,
					  Padcabe.TipoDocumento,Padcabe.Plan, PadCabe.TipoBeneficiario
					 FROM  Padcabe
					 WHERE Padcabe.Entidad = 948
					   AND  Padcabe.FecEgreso = '2100-01-01'

		ENDTEXT
*!*			SELECT Padotrosdatos.Campo, Padotrosdatos.Contenido,
*!*						  Padotrosdatos.FechaHasta, Padotrosdatos.IdPadCabe, Padcabe.ID,
*!*						  Padcabe.Apellido, Padcabe.ApeyNom, Padcabe.CUIL, Padcabe.Credencial,
*!*						  Padcabe.Documento, Padcabe.Entidad, Padcabe.FecEgreso,
*!*						  Padcabe.FecIngreso, Padcabe.FecNac, Padcabe.GrupoFamiliar,
*!*						  Padcabe.Nombre, Padcabe.NroAfiliado, Padcabe.NroAfiliadoAlternativo,
*!*						  Padcabe.Plan, Padcabe.PlanAlternativo, Padcabe.Sexo,
*!*						  Padcabe.TipoDocumento,Padcabe.Plan
*!*						 FROM PadOtrosDatos
*!*						    INNER JOIN Padcabe ON  Padcabe.ID = Padotrosdatos.IdPadCabe
*!*						 WHERE  Padotrosdatos.Campo = 'OBRASOC'
*!*						   AND  Padotrosdatos.Contenido IN ('GASMBA','GASTRO')
*!*						   AND  Padcabe.Entidad = 948
*!*						   AND  Padcabe.FecEgreso = '2100-01-01'
*!*						 GROUP BY Padotrosdatos.IDPadCabe
*-- Cuidado sacar despues de pruebas
* Messagebox('Cuidado que se filtro por Cuit ' , 0+64, 'Aviso a el Usuario' ) -- Antes filtrado por And Padcabe.CUIL = '27243938398'

*-- Ejecuto la consulta al motor
		lnReturn = SQLExec( This.nConexionSQL, lcCMD_SQL , 'mwkPadCabe' )

		If lnReturn < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
			=Aerror(lcArrayError)
			Messagebox("Fallo la Consulta de generación para mwkPadCabe  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Else
			Select mwkPadCabe
* Browse Nowait
		Endif

*////////////////////////////////// Msj. De silvia
*     Eduardo, hay que agregar un filtro más para ver los tipos de bonos disponibles.
*     2021-06-23 lo tenés que reemplazar por alguna variable que represente la fecha del día de la corrida.
* Ejemplo :	       	AND ( '2021-06-23' )  between TabBono.Fecvigend and TabBono.Fecvigenh
*  					AND ( '2021-06-23' ) between TabBonoEnti.Fecvigend and TabBonoEnti.Fecvigenh

		Private FechaProceso
		m.FechaProceso = This.dFechaServer

*-- Armamos el set de datos de Bonos por entidad y rango de fecha
		lcCMDSQL = ''
		TEXT TO lcCmdSQL TEXTMERGE NOSHOW PRETEXT 7
				SELECT Tabbono.ID, Tabbono.CodMotivo, Tabbono.Denominacion,
				  Tabbono.Importe, Tabbono.TipoBono, Tabbono.Usuario, Tabbono.fechagraba,
				  Tabbono.fecvigend, Tabbono.fecvigenh, Tabbono.idbonoasoc, Tabbonoenti.ID,
				  Tabbonoenti.Usuario, Tabbonoenti.codent, Tabbonoenti.fechagraba,
				  Tabbonoenti.fecvigend, Tabbonoenti.fecvigenh, Tabbonoenti.idbono , 0 as nRegistro
				 FROM Tabbono
				    INNER JOIN Tabbonoenti ON  Tabbonoenti.idbono = Tabbono.ID
				   	AND  Tabbonoenti.codent = ( 948 )
				 WHERE  Tabbono.Importe <> ( 0 )
 			       	AND ( ?m.FechaProceso )  between TabBono.Fecvigend and TabBono.Fecvigenh
  					AND ( ?m.FechaProceso ) between TabBonoEnti.Fecvigend and TabBonoEnti.Fecvigenh
				 ORDER BY Tabbono.Denominacion
		ENDTEXT

*-- Ejecuto la consulta al motor
		lnReturn = SQLExec( This.nConexionSQL, lcCMDSQL , 'mwkBonos' )

		If lnReturn < 0
* Messagebox("Fallo la Consulta de las Zabfichepncov19 "+Chr(10)+ "Aviso ",16," Mensaje al Usuario ")
			=Aerror(lcArrayError)
			Messagebox("Fallo la Consulta de generación de mwkBonos  "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Else
			Select mwkBonos
* Browse Nowait
		Endif

	Else
		Messagebox('Avisar que falta archivo de configuración',0+64,'Aviso al Usuario' )
		Return .F.
	Endif

*/////////////////////////////////////////////////////////
* Determino para los dos scaneos l acantidad de dias segun el año - Datos de codigo de barra
*
*-- Determino correctamente la cantidad de dias del año , considerando Bisiesto o no
	If Mod(Year( This.dFechaServer ),4)=0 And (Mod(Year( This.dFechaServer ),100)#0 Or Mod(Year( This.dFechaServer ),400)=0)
		lcAnioEnDias = '366' 			&& Messagebox( 'El año es bisiesto' )
	Else
		lcAnioEnDias = '365'			    && Messagebox( 'El año no es bisiesto' )
	Endif

*/////////////////////////////
*   Realizo dos Scaneos para cargar GASTRO o GASMBA
*/////////////////////////////

*-- Haciendo GASTRO filtro la tabla de bonos
	Select mwkBonos
	Set Filter To Substr(Denominacion,1,13) = 'GASTRONOMICOS'

*--  Armo los datos recorriendo PadCabe
	Select mwkPadCabe
	Scan For Inlist(Nvl( mwkPadCabe.plan,151),0,151)

		mcTipoBeneficiario = Alltrim(Nvl(mwkPadCabe.TipoBeneficiario,""))
		lTipoBenef = (mcTipoBeneficiario = "JUBILADO")  &&si el tipo de beneficiario es Jubilado
		mImporteBono = 0

		Select mwkBonos
		lnNumeroSec = 0
		Scan

*-- Formateo los valores de cada campo para volvarlos al archivo final
			lnNumeroSec = lnNumeroSec + 1
			lnNumeroSeccuencia = Alltrim( Str( Year( This.dFechaServer ) ) )  + Padl( Alltrim(Str( lnNumeroSec ) ),2,'0' )			&& Formateo la fecha segun formato PagoFacil

			lcDocumento =  Alltrim( Str( mwkPadCabe.Documento ) )
			lcDocumento2 = Padl( Alltrim(Str( mwkPadCabe.NroAfiliado, 13 ) ) , 30, '0' )
			lcBonoDenominacion = Alltrim( Substr( mwkBonos.Denominacion , 15, Len(mwkBonos.Denominacion) ) )
			lcNombre 	   = Alltrim( mwkPadCabe.ApeyNom) + '(G)'
			lcFechaVigenD  = Alltrim( Str( Year( This.dFechaServer ) )) + Padl( Alltrim( Str( Month( This.dFechaServer ))), 2, '0' ) + Padl( Alltrim( Str( Day( This.dFechaServer ))), 2, '0' )
			ldFechaVtoReg  = This.dFechaServer + 365
			lcFechaVigenH  = Alltrim( Str( Year( ldFechaVtoReg ) )) + Padl( Alltrim( Str( Month( ldFechaVtoReg ))), 2, '0' ) + Padl( Alltrim( Str( Day( ldFechaVtoReg ))), 2, '0' )

*!*	            *-- Determino correctamente la cantidad de dias del año , considerando Bisiesto o no
*!*	            If Mod(Year( This.dFechaServer ),4)= 0 And (Mod(Year( This.dFechaServer ),100)#0 Or Mod(Year( This.dFechaServer ),400) = 0 )
*!*	               lcAnioEnDias = '366' 			&& Messagebox( 'El año es bisiesto' )
*!*	            Else
*!*	               lcAnioEnDias = '365'			    && Messagebox( 'El año no es bisiesto' )
*!*	            Endif

			If lTipoBenef
				mImporteBono = 0
			Else
				mImporteBono = mwkBonos.Importe
			Endif

SET STEP ON

***         lcCodigoBarra = '3000' + Padl( Chrtran( Alltrim( Str(  mwkBonos.Importe, 10, 2 )), '.', '' ) ,8, '0' )+ ;

			lcCodigoBarra = '3000' + Padl( Chrtran( Alltrim( Str(  mImporteBono, 10, 2 )), '.', '' ) ,8, '0' )+ ;
				Substr( Alltrim(Str( Year( This.dFechaServer ))), 3,2 ) + lcAnioEnDias + ;
				PADL( lcDocumento , 14, '0') + '0' + '000000' + '00' + '00'

			lcCodigoBarra = Chrtran(lcCodigoBarra,',','')


* Tabla mwkCabeceraPositiva es la que pasa a TXT para enviarla
			Insert Into mwkDetallePositiva ( ;
				TipoRegis , IndicPrimario , IndicSecundario , NumSecuencia ,Mensaje ,;
				NombreCliente, CodgioBarras, FechaViegRegist, FechaVtoRegist , TipoPago, Filler ) ;
				Values( '02' , Padl( lcDocumento, 21, '0' ), lcDocumento2 , lnNumeroSeccuencia , lcBonoDenominacion, ;
				lcNombre , Padr( lcCodigoBarra , 55, ' ' ), lcFechaVigenD, lcFechaVigenH, 'T' , '         ' )

		Endscan						&& Fin de tabla Bonos

	Endscan							&& Fin de tabla PatCabe

*-- Saco el filtro aplicado en Gastronomicos
	Select mwkBonos
	Set Filter To

*////////////////////////////

	Select mwkBonos
	Set Filter To Substr(Denominacion,1,15) = 'MONOTRIBUTISTAS'
*
	Select mwkPadCabe
	Scan For  Nvl( mwkPadCabe.plan,151) = 152

		mcTipoBeneficiario = Alltrim(Nvl(mwkPadCabe.TipoBeneficiario,""))
		lTipoBenef = (mcTipoBeneficiario = "JUBILADO")  &&si el tipo de beneficiario es Jubilado
		mImporteBono = 0

		Select mwkBonos
		lnNumeroSec = 0
		Scan

*-- Formateo los valores de cada campo para volvarlos al archivo final
			lnNumeroSec = lnNumeroSec + 1
			lnNumeroSeccuencia = Alltrim( Str( Year( This.dFechaServer ) ) )  + Padl( Alltrim(Str( lnNumeroSec ) ),2,'0' )			&& Formateo la fecha segun formato PagoFacil

			lcDocumento =  Alltrim( Str( mwkPadCabe.Documento ) )
			lcDocumento2 = Padl( Alltrim(Str( mwkPadCabe.NroAfiliado, 13 ) ) , 30, '0' )

			lcBonoDenominacion = Alltrim( Substr( mwkBonos.Denominacion , 17 , Len( mwkBonos.Denominacion ) ) )
			lcNombre = Alltrim( mwkPadCabe.ApeyNom) + '(M)'
			lcFechaVigenD  = Alltrim( Str( Year( This.dFechaServer ) )) + Padl( Alltrim( Str( Month( This.dFechaServer ))), 2, '0' ) + Padl( Alltrim( Str( Day( This.dFechaServer ))), 2, '0' )
			ldFechaVtoReg  = This.dFechaServer + 365
			lcFechaVigenH  = Alltrim( Str( Year( ldFechaVtoReg ) )) + Padl( Alltrim( Str( Month( ldFechaVtoReg ))), 2, '0' ) + Padl( Alltrim( Str( Day( ldFechaVtoReg ))), 2, '0' )

*!*	            *-- Determino correctamente la cantidad de dias del año , considerando Bisiesto o no
*!*	            If Mod(Year( This.dFechaServer ),4)=0 And (Mod(Year( This.dFechaServer ),100)#0 Or Mod(Year( This.dFechaServer ),400)=0)
*!*	               lcAnioEnDias = '366' 			&& Messagebox( 'El año es bisiesto' )
*!*	            Else
*!*	               lcAnioEnDias = '365'			&& Messagebox( 'El año no es bisiesto' )
*!*	            Endif

			If lTipoBenef
				mImporteBono = 0
			Else
				mImporteBono = mwkBonos.Importe
			Endif

*           lcCodigoBarra = '3000' +  Padl( Chrtran( Alltrim( Str(  mwkBonos.Importe ,10, 2 ) ) ,'.','') , 8, '0' ) + ;

* set step on

			lcCodigoBarra = '3000' +  Padl( Chrtran( Alltrim( Str(  mImporteBono ,10, 2 ) ) ,'.','') , 8, '0' ) + ;
				SUBSTR( Alltrim( Str( Year( This.dFechaServer ))),3,2 ) + lcAnioEnDias + ;
				PADL( lcDocumento , 14, '0' ) + '0' + '000000' + '00' + '00'

			lcCodigoBarra = Chrtran(lcCodigoBarra,',','')

* Tabla mwkCabeceraPositiva es la que pasa a TXT para enviarla
			Insert Into mwkDetallePositiva ( ;
				TipoRegis , IndicPrimario , IndicSecundario , NumSecuencia ,Mensaje ,;
				NombreCliente, CodgioBarras, FechaViegRegist, FechaVtoRegist , TipoPago, Filler ) ;
				Values( '02' , Padl( lcDocumento, 21, '0' ), lcDocumento2 , lnNumeroSeccuencia , lcBonoDenominacion, ;
				lcNombre , Padr( lcCodigoBarra, 55, ' ' ) , lcFechaVigenD, lcFechaVigenH, 'T' , '         ' )

		Endscan						&& Fin de tabla Bonos
	Endscan

*-- Saco el filtro aplicado en Monotributistas
	Select mwkBonos
	Set Filter To

*//////////////////////////// Fin de Scan

*-- Cargo datos de cantidad y otros formateado para la salida final en TXT

* TipoRegistro = '01'
	lcCantidaRegistros = Padl( Alltrim( Str( Reccount('mwkDetallePositiva') )), 9, '0' )
	lcFiller = '                                                                                                    ' + ;
		'                                                                        '   && Replicate(' ',172)
	lcFecha = Alltrim(Str(Year(This.dFechaServer) )) + Padl( Alltrim(Str(Month(This.dFechaServer) )), 2 ,'0') + Padl( Alltrim(Str(Day(This.dFechaServer) )),2,'0')

*-- Cargo datos en el cursor de Cabecera de los archivos . Archivo Final para pasar a TXT
	Insert Into mwkCabeceraPositiva ( ;
		TipoRegistro , CantReg , Accion , Utility , Fecha , Filler  ) ;
		Values ( '01' , Padl( lcCantidaRegistros ,9 ,'0'  ), 'T' ,  '90063000' , lcFecha , lcFiller )

*-- Genero los archivos finales hago la compresion y me preparo para el envio según configuración en el .INI
	If This.GeneraArchivoFisico()

*-- Comprimo los dato convirtiendo en ZIP el archivo y envio por mail
* If This.CompresionxShell( This.cNombreArchivo )
		If This.Compresion_ZIP( This.cNombreArchivo )

			Local llOk As Logical

*//////////////////////////////////////////////////////////////
*-- Veo por que medio debe salir el archivo generado
			If This.cViaFTP = 'ON'										&& Via FTP
* This.EnvioViaFTP( This.cNombreArchivo )
				llOk = .T.
			Endif

			If This.cViaMail = 'ON'										&& Via Mail
				This.EnvioViaMail()
				llOk = .T.
			Endif

			If llOk = .F.
				Messagebox( ' Parámetro no valido o mal configurado . Revise el archivo ConfigPagoFacil.ini ', 0+64, 'Aviso al Usuario ' )
				Return .F.
			Endif
		Endif

	Endif
*//////////////////////////////////////////////////////////////

*-- Desconectamos Motor
	This.Desconexionmotor()

	Endproc

***************************************************************************************************
*  Procedure : CapturaConfiguracion
***************************************************************************************************
* Parameters  :
* Description :  Lectura de los parámetros de un punto INI  -cDireDefa contiene directorio por defecto
***************************************************************************************************
*
	Procedure CapturaConfiguracion() As Logical

	Local lcDireDefa As String , llReturnOk As Logical , lcFormatoEnvio1 As String , lcFormatoEnvio2 As String

*-- Capturo donde esta ele ejecutable y demas archivos
	lcDireDefa = Fullpath(Curdir())

	If File(lcDireDefa + 'ConfigPagoFacil.ini')

*-- Cargo la forma de envio del archivo
		This.cViaFTP  = This.ReadIni('configenviodatos','cviaftp'  ,lcDireDefa+'configpagofacil.ini' )
		This.cViaMail = This.ReadIni('configenviodatos','cviamail' ,lcDireDefa+'configpagofacil.ini' )

*-- Cargo las cuentas de mail asignada (son hasta tres)
		This.cCuentaMail1 = This.ReadIni('cuentasmail','cCuentaEmail1'  ,lcDireDefa+'configpagofacil.ini' )
		This.cCuentaMail2 = This.ReadIni('cuentasmail','cCuentaEmail2'  ,lcDireDefa+'configpagofacil.ini' )
		This.cCuentaMail3 = This.ReadIni('cuentasmail','cCuentaEmail3'  ,lcDireDefa+'configpagofacil.ini' )

*-- Verifico los formatos de envio ZIP / Encriptado PGP
		lcFormatoEnvio1 = This.ReadIni('formatoenvio','cformatoZIP'  ,lcDireDefa+'configpagofacil.ini' )
		lcFormatoEnvio2 = This.ReadIni('formatoenvio','cformatoPGP'  ,lcDireDefa+'configpagofacil.ini' )

*-- Configro la seleccio de envio
		This.cFormatoEnvio = Iif( lcFormatoEnvio1 = 'ON', 'ZIP' , 'PGP' )

		llReturnOk = .T.
	Else
*-- Avisar que falta archivo de configuración
		llReturnOk = .F.
	Endif

*-- Retronamos el valor si se pudo o no lebantar la Data
	Return llReturnOk

	Endproc


***************************************************************************************************
*  Procedure : GeneraArchivoFisico
***************************************************************************************************
*  Parameters  :
*  Description :   Genero los archivos de texto para enviar (Cabecer/Detalle). A la union de los dos
*					Cabecera/Detalle con el nombre correcto para enviar
***************************************************************************************************
*
	Procedure GeneraArchivoFisico()

*-- Obtengo nombre final del archivo
	This.cNombreArchivo = This.GeneraNombreArchivo()

	Select mwkCabeceraPositiva					&& La cabecera ya viene fomateada
	Copy To CabeceraPositiva Type Sdf

	Select mwkDetallePositiva
	Copy To DetallePositiva Type Sdf

*-- Formamos la unión de los archivos Cabecera y Detale, con el nuevo nombre de archivo
	oWshShell = Createobject("WScript.Shell")

*-- Armo el Bat con la Instruccion a ejecutar
	cNombreComando = 'Copy '+ This.cPAthArchivo + 'CabeceraPositiva.txt +'+ This.cPAthArchivo + 'DetallePositiva.txt ' + This.cNombreArchivo

*-- Genero un archivo Bat para ejecutar mejor los comandos que desde Fxo
	Strtofile( cNombreComando, "UnionArchivosTXT.bat" )
	oWshShell.Run( "UnionArchivosTXT.bat", 0, .T. )

*--Borramos el Bat creado y ejecutado
* Erase This.cPAthArchivo + 'UnionArchivosTXT.bat'

	oWshShell = .Null.

*!*	      *-- Comprimo los dato convirtiendo en ZIP el archivo y envio por mail
*!*	      This.CompresionxShell( lcNombreArchivo )

	Return .T.

	Endproc


***************************************************************************************************
*  Procedure : GeneraNombreArchvo
***************************************************************************************************
*  Parameters  :
*  Description :   Genero el nombre del archi para enviar . Nombre XXXAAMNN.ONL
***************************************************************************************************
* 	XXX : Codigo de empresa Asignada por SEPSA (Asignado es 90063000 )
* 	AA  : Año de generacion del Archivo
* 	M   : Mes de generacion del Archivo expresado en Letras ('A', Enero, 'B', Febrero / etc. )
* 	NN  : Numero de Proceso de Generacion . Numero correlativo  dentro del mes
* 	ONL : Texto Fijo
***************************************************************************************************
*
	Procedure GeneraNombreArchivo()

	Local lcNombreArch As String, lcAnio As String, lnCantidadVeces As Number

	lcAnio = Substr( Alltrim(Str( Year( This.dFechaServer ))) ,3,2 )

*!*	      Create Cursor mwkPFNomArchivo ( cCodSepsa C(4), cAnioGene C(4) , cMesGene C(1), cNumProc C(3), cExtension C(3) )
*!*	      Insert Into mwkPFNomArchivo Values( '1234' , '2021', 'F', '01' , 'ONL' )
*!*	      * Cursortoxml("mwkPFNomArchivo", This.cPathArchivo + "PFNomArchivo.xml", 1, 512, 0, "mySchema.xsd")
*!*	      Cursortoxml("mwkPFNomArchivo", "C:\desaguemes\Disenio_PagoFacil" + "PFNomArchivo.xml", 1, 512, 0, "mySchema.xsd")

*-- Verifico existencia de archivo de generación de nombre que se almacena en el directorio junto al Exe
	If File( This.cPAthArchivo + "PFNomArchivo.xml" )
		Xmltocursor( This.cPAthArchivo + "PFNomArchivo.xml",'mwkPFNomArchivo',512)
* Select mwkPFNomArchivo

*-- Armo el Nombre del Archivo segun datos cargdos del xml
* lcNombreArch = cCodSepsa+ cAnioGene + cMesGene + cNumProc + cExtension

	Else

		Create Cursor mwkPFNomArchivo ( cCodSepsa C(4), cAnioGene C(4) , cMesGene C(1), cNumProc C(3), cExtension C(4) )
* lnAnio = substr( Alltrim(Str( Year( This.dFechaServer ) ) ) ,3,2 )
		lcSiglaMes = This.ObtengoLetraMes()

		Insert Into mwkPFNomArchivo Values( '3000' , lcAnio, lcSiglaMes , '01' , '.ONL' )
		Cursortoxml("mwkPFNomArchivo", This.cPAthArchivo + "PFNomArchivo.xml", 1, 512, 0, "mySchema.xsd")

		Select mwkPFNomArchivo
		Go Top

* Cursortoxml("mwkPFNomArchivo", "C:\desaguemes\Disenio_PagoFacil" + "PFNomArchivo.xml", 1, 512, 0, "mySchema.xsd")

	Endif

*-- Selecciono el curaor con los datos grabados
	Select mwkPFNomArchivo

*-- Como primera medida controlo el año contra el que esta grabado
	If Alltrim( mwkPFNomArchivo.cAnioGene ) <> Substr( Alltrim(Str( Year( This.dFechaServer ))), 3,2 )
		Replace mwkPFNomArchivo.cAnioGene With lcAnio
	Endif

*-- Obtengo sigla del mes
	lcSiglaMes = This.ObtengoLetraMes()

*-- Controlo el mes si es distinto
	If Alltrim( mwkPFNomArchivo.cMesGene ) <> lcSiglaMes
		Replace mwkPFNomArchivo.cMesGene With Alltrim( lcSiglaMes  )
	Endif

*-- Controlo que el contador de procesos este presente
	If File(This.cPAthArchivo + "PFCantProcMes.xml" )

*-- Controlo cantidad de procesos efectuados en el mes
		Xmltocursor( This.cPAthArchivo + "PFCantProcMes.xml",'mwkPFCantProcMes',512)
		Select mwkPFCantProcMes
		Locate For mwkPFCantProcMes.nMes = Month( This.dFechaServer ) And mwkPFCantProcMes.nAnio = Year( This.dFechaServer )

*-- Si no lo encuantro puede ser que cambio el mes , si esta sumo uno mas al contador y lo tomo para formar el nombre
		If Not Found()
			lnCantidadVeces = 1

*-- Obtengo el numero del Id siguiente y lo guardamos en el XML
			Select Id + 1 As nIdProximo From mwkPFCantProcMes Into Cursor mwkNuevoId
			Insert Into mwkPFCantProcMes Values( mwkNuevoId.nIdProximo , Month( This.dFechaServer ), Year( This.dFechaServer ), lnCantidadVeces )
			Cursortoxml("mwkPFCantProcMes", This.cPAthArchivo + "PFCantProcMes.xml", 1, 512, 0, "mySchema2.xsd")

*-- Actualizo el contador en el Nombre de Archivo
			Update mwkPFNomArchivo Set cNumProc = Padl( Alltrim( Str( lnCantidadVeces ) ) ,2,'0' )

		Else

*-- sumamos para el mismo mes otra cantidad
			lnCantidadVeces = 0
			lnCantidadVeces = mwkPFCantProcMes.nCantVeces + 1
*-- Actuaizamos tabla de Cantidad por mes
			Update mwkPFCantProcMes Set nCantVeces = lnCantidadVeces
*-- Actualizo el contador en el Nombre de Archivo
			Update mwkPFNomArchivo Set cNumProc = Padl( Alltrim( Str( lnCantidadVeces ) ) ,2,'0' )

*-- Selecciono la tabla con el contador de datos actualizado y lo vuelco a disco
			Select mwkPFCantProcMes
			Cursortoxml("mwkPFCantProcMes", This.cPAthArchivo + "PFCantProcMes.xml", 1, 512, 0, "mySchema2.xsd")

		Endif

	Else
*-- Creo cursor y lo guardo en disco por que el xml no existe. contiene cantidad de procesos ejecutados o enviados en el mes
		Create Cursor mwkPFCantProcMes ( Id I, nMes I, nAnio I, nCantVeces I )

*-- Cantidad fija cuando el archivo no existe
		lnCantidadVeces = 1

*-- Cargo valores por defecto segun mes año . El contador es a Uno
		Select mwkPFCantProcMes
		Insert Into mwkPFCantProcMes Values( 1, Month( This.dFechaServer ), Year( This.dFechaServer ), lnCantidadVeces  )

*-- Vuelco los daos a disco (archivo)
		Cursortoxml("mwkPFCantProcMes", This.cPAthArchivo + "PFCantProcMes.xml", 1, 512, 0, "mySchema2.xsd")
*-- Actualizo el contador en el Nombre de Archivo
		Update mwkPFNomArchivo Set cNumProc = Padl( Alltrim( Str( lnCantidadVeces ) ) ,2,'0' )


	Endif

*!*	      *-- Selecciono la tabla con el cntador de datos actualizado y lo vuelco a disco
*!*	      Select mwkPFCantProcMes
*!*	      lnCantidadProc = mwkPFCantProcMes.nCantVeces
*!*	      Cursortoxml("mwkPFCantProcMes", This.cPAthArchivo + "PFCantProcMes.xml", 1, 512, 0, "mySchema2.xsd")

	Select mwkPFNomArchivo
*-- Armo el Nombre del Archivo segun datos cargdos del xml
	lcNombreArch = mwkPFNomArchivo.cCodSepsa + Alltrim( mwkPFNomArchivo.cAnioGene ) + Alltrim( mwkPFNomArchivo.cMesGene ) + Alltrim( mwkPFNomArchivo.cNumProc ) + Alltrim( cExtension )
*-- Actualizo todo lo que inserte en el cursor
	Cursortoxml("mwkPFNomArchivo", This.cPAthArchivo + "PFNomArchivo.xml", 1, 512, 0, "mySchema.xsd")

* Messagebox( lcNombreArch,0+64,'Aviso al usuario' )

	Return lcNombreArch

	Endproc

***************************************************************************************************
*  Procedure : ObtengoLetraMes
***************************************************************************************************
*  Parameters  :
*  Description :   Envio un mail con las notificaciones de los procesos de actualizacion
***************************************************************************************************
*
	Procedure ObtengoLetraMes() As String

	Local lcSiglaMes As String
	lcSiglaMes = ''

*-- Control Numerico dentro del mes
	Do Case
	Case Month( This.dFechaServer ) = 1 			&& Enero
		lcSiglaMes = 'A'
	Case Month( This.dFechaServer ) = 2 			&& Febrero
		lcSiglaMes = 'B'
	Case Month( This.dFechaServer ) = 3 			&& Marzo
		lcSiglaMes = 'C'
	Case Month( This.dFechaServer ) = 4 			&& Abril
		lcSiglaMes = 'D'
	Case Month( This.dFechaServer ) = 5 			&& Mayo
		lcSiglaMes = 'E'
	Case Month( This.dFechaServer ) = 6 			&& Junio
		lcSiglaMes = 'F'
	Case Month( This.dFechaServer ) = 7 			&& Julio
		lcSiglaMes = 'G'
	Case Month( This.dFechaServer ) = 8 			&& Agosto
		lcSiglaMes = 'H'
	Case Month( This.dFechaServer ) = 9 			&& Septiembre
		lcSiglaMes = 'I'
	Case Month( This.dFechaServer ) = 10 			&& Octubre
		lcSiglaMes = 'J'
	Case Month( This.dFechaServer ) = 11 			&& Nobiembre
		lcSiglaMes = 'K'
	Case Month( This.dFechaServer ) = 12 			&& Diciembre
		lcSiglaMes = 'L'
	Endcase

	Return lcSiglaMes

	Endproc

***************************************************************************************************
*  Procedure : EnvioviaMail
***************************************************************************************************
*  Parameters  :
*  Description :   Envio un mail con archivo comprimido pra pago Facil
***************************************************************************************************
*
	Procedure EnvioViaMail()

	Local loCfg, loMsg, lcFile, loErr, lcNomArchivo As String

	llOkEnvio = .T.
	If myip = '172.16.1.7'
		Set Step On
	Endif
*-- Armamo sel Nombre del Archivo generado para el envio
	lcNomArchivo = This.cPAthArchivo + Substr( This.cNombreArchivo,1, Len( This.cNombreArchivo )-4  ) + '.ZIP'             && '300021F10.zip' 				&& archivo adjunto

	Try
		loCfg = Createobject("CDO.Configuration")

		With loCfg.Fields
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 && ó 587
			.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
			.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "dl380@sg.com.ar" 	&& ejemplo: "edu@sg.com.ar"
			.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "servidor380" 		&& ejemplo: "eduardo123"
			.Update()
		Endwith

		loMsg = Createobject ("CDO.Message")

		With loMsg
			.Configuration = loCfg

*-- Remitenete y destinatarios
			.From = "dl380@sg.com.ar" 							&& Acá poné lo que quieras mostrar al destinatario
* .To   = 'etkachuk@sg.com.ar'  						&& Acá va el destinatario

*-- Trabajo sobre los tres correos que nos da Pago Facil para el envio de novedades
			lcListaDestinatarios = Alltrim( This.cCuentaMail1 )						&& Si o si debe contener un correo
			If Not Empty( Alltrim( This.cCuentaMail2 ) )
				lcListaDestinatarios = lcListaDestinatarios +';' + This.cCuentaMail2
			Endif
			If Not Empty( Alltrim( This.cCuentaMail3 ) )
				lcListaDestinatarios = lcListaDestinatarios + ';' + This.cCuentaMail3
			Endif

			.To = lcListaDestinatarios
			.Cc   = '' 												&& lccopia Acá va si querés copiar a alguien

*- Notificación de lectura
			.Fields("urn:schemas:mailheader:disposition-notification-to") = .From
			.Fields("urn:schemas:mailheader:return-receipt-to") = .From
			.Fields.Update()

*- Prioridad		-1=Low, 0=Normal, 1=High
			.Fields("urn:schemas:httpmail:priority") = 1
			.Fields("urn:schemas:mailheader:X-Priority") = 1
*- Importancia     0=Low, 1=Normal, 2=High
			.Fields("urn:schemas:httpmail:importance") = 2
			.Fields.Update()

*-- Tema
			.Subject = 'Envio archivo datos Base positiva para su procesamiento OK - Sanatorio Guemes(90063000)- Padrón OSUTHGRA '

*-- Formato HTML desde la Web
*    .CreateMHTMLBody("Hola", 0)
			.TextBody = 'Se adjunta Archivo : ' + This.cNombreArchivo	+ ' Fecha envio : ' + ;
				CMONTH( This.dFechaServer ) + ' ' + Str(Day( This.dFechaServer ),2) + 'de ' + Alltrim( Str( Year( This.dFechaServer) ) )  		&& mcuerpo

*-- Archivo adjunto
			lcFile = lcNomArchivo  && Acá va el archivo adjunto, fijarse que antes de enviar me aseguro que esté fisicamente el archivo generado.

			If File( lcNomArchivo )
				.AddAttachment( lcFile )
			Endif

*-- Envio el mensaje
			.Send() 										&&  Envío

		Endwith

	Catch To oError
*!*	         Messagebox("No se pudo enviar el Mail a Pago Facil con el Adjunto " + Chr(13) + ;
*!*	            "Error: " + Transform( oError.ErrorNo) + Chr(13) + ;
*!*	            "Mensaje: " + oError.Message , 16, "Error")

		=Messagebox("No se pudo enviar el Mail a Pago Facil con el Adjunto " + Chr(13) + ;
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

***************************************************************************************************
*  Procedure : CreoCursoresSalida
***************************************************************************************************
*  Parameters  :
*  Description :   Creo los cursores finales conteniendo los datos a pasar a archivo fila (txt)
***************************************************************************************************
*
	Procedure CreoCursoresSalida()

	Create Cursor mwkCabeceraPositiva ( TipoRegistro C(2),;
		CantReg C(9), ;
		Accion C(1),;
		Utility C(8), ;
		Fecha C(8) ,;
		Filler C(172) )

	Create Cursor mwkDetallePositiva ( ;
		TipoRegis C(2) , ;
		IndicPrimario C(21), ;
		IndicSecundario C(30) ,;
		NumSecuencia C(6),;
		Mensaje C(20),;
		NombreCliente C(40), ;
		CodgioBarras C(55), ;
		FechaViegRegist C(8),;
		FechaVtoRegist C(8), ;
		TipoPago C(1) ,;
		Filler C(9) )

	Return .T.

	Endproc

***************************************************************************************************
*  Procedure : Encriptacion_PGP
***************************************************************************************************
*  Parameters  :
*  Description :   Encripta los datos con el porducto PGP
***************************************************************************************************
*
*!*			   cClientDNCEmail = "clients.secure.ftp@TheirDomain.com"

*!*			   * --- Define Where KeyRings 'live' ---
*!*			   cPGPKeyDir = Addbs(mcCommonDir) + "PGP Keyrings"
*!*			   cPubRing = Addbs(mcPGPKeyDir) + "PubRing.pkr"
*!*			   cPrivRing = Addbs(mcPGPKeyDir) + "SecRing.skr"

*!*			   * --- Input File = non-encrypted fully-pathed file name ---
*!*			   cInputFile = "C:\Temp\NonEncryptedFile.txt"

*!*			   * --- Output = Destination encrypted fully-pathed file name ---
*!*			   cOutputFile = "C:\Temp\EncryptedFile.pgp"

*!*			   oPGP = Createobject("NSDPGP3Lib.PGP")
*!*			   cRecipientID = oPGP.GetKeyIDFromUserID(cPubRing,cPrivRing, cClientDNCEmail)
*!*			   oPGP.EncryptFile(cPubRing,cPrivRing,cInputFile,cOutputFile,0,0,cRecipientID)
*!*			   cStatus = oPGP.AnalyzeFile(cOutputFile)
*!*			   Release oPGP

*!*	   Procedure Encriptacion_PGP()

*!*	      oPGP = Createobject("NSDPGP3LIB.PGP")        				&& PGP Encryption engine

*!*	      cPublicPGPKeyRing  = "C:\Documents and Settings\Mike\My Documents\PGP\pubring.pkr"
*!*	      cPrivatePGPKeyRing = "C:\Documents and Settings\Mike\My Documents\PGP\secring.skr"
*!*	      nPGPError = 0                && No key found for this email generates a program error, so trap it

*!*	      Try
*!*	         oPGP.EncryptFile(cPublicPGPKeyRing,cPrivatePGPKeyRing,;
*!*	            p_FileName,    p_FileName+".PGP",1,1,;
*!*	            oPGP.GetKeyIDFromUserID( cPublicPGPKeyRing,cPrivatePGPKeyRing,Alltrim(Contact.Email) )     )
*!*	      Catch To oErr
*!*	         nPGPError = oErr.ErrorNo
*!*	         If nPGPError = 1429        && User key not found
*!*	            Messagebox("There is no PGP key for "+Alltrim(Contact.Email)+".  The file "+p_FileName+" will not be sent.",0,;
*!*	               "No PGP Encryption Key",60000)
*!*	         Else
*!*	            nErrAction = Messagebox( "PGP object error:"+ BuildErrorMsg(oErr)50,0+64,"PGP Error" )
*!*	         Endif
*!*	      ENDTRY
*!*
*!*	      p_FileName = p_FileName+".PGP"
*!*	      If nPGPError = 0    && Encryption was successful
*!*	         * .
*!*	         * . etc.
*!*	         * .
*!*	         ENDIF
*!*	      Endproc

***************************************************************************************************
*  Procedure : CompresionxShell
***************************************************************************************************
*  Parameters  : tcNombreArchivo
*  Description : Compresion de archivo usando Shell de Windows
***************************************************************************************************
*
	Procedure CompresionxShell( tcNombreArchivo As String )

*-- Declaro variables locales para  contenes el nombre de archivo y Path de compresion
	Local lcArchivoZIP As String , lcZip As String, llOkProc As Logical
	llOkProc = .T.

*-- Adjunto el Path de busqueda para direccionar la lectura
	lcArchivoAComprimir = Addbs(Fullpath(Curdir()))  + tcNombreArchivo

	lcArchivoZIP = Left(tcNombreArchivo,9) + '.zip'
	lcZip = Addbs(Fullpath(Curdir()))+ lcArchivoZIP

	If File(lcZip) 					&& Borro Zip si existe. Ojo el contador por generacion dentro del mes me indica un nuevo Zip
		Erase lcZip
	Endif

*-- Creo Fichero Encabezado de zip
	Strtofile( Chr(0x50)+Chr(0x4B)+Chr(0x05)+Chr(0x06) + Replicate(Chr(0),18), lcZip )

*-- Instancio el objeto Shell de Windows
	oShell = Createobject("Shell.Application")

	If Type('oShell')='O'

*!* Según Investigué, Microsoft recomienda crear el Objeto oFolder y trabajar con ese objeto
*!* para hacer la instrucción copyHere intenté hacerlo directamente
*!* -oShell.NameSpace("&lcZip").copyHere(laArcDef[lnContArray])-, pero recibía contínuos errores de
*!* fallo de aplicación VFP. asimismo, tuve que crear el objeto oFolder con la macrosubstitución
*!* -oShell.NameSpace("&lcZip")- por que tambien, depurando el programa, detecté que no se
*!* creaba el objeto oFolder colocando la instrucción -oShell.NameSpace("&lcZip")- directamente

		oFolder = oShell.NameSpace("&lcZip")

		Wait Window 'Comprimiendo datos ...' Nowait

		If Type('oFolder')='O'
*-- Copio el contenido en la carpeta de compresion
			oFolder.CopyHere( lcArchivoAComprimir )

*-- Coloco un inkey para no generar tantos shell de Fox
			Inkey(0.5)

			Wait Clear
			oFolder = .Null. 					&& Antes .F.
		Else
			Messagebox('No pudo crearse el Objeto oFolder',16)
			llOkProc = .F.
		Endif
*-- Mato el objeto generado
		oShell = .Null. 						&& antes .F.
	Else
		Messagebox('No pudo crearse el Objeto Shell',16)
		llOkProc = .F.
	Endif

*-- Relentiso el programa para que la compresion de archivos se realizce antes de tratar de enviar via mail
	If llOkProc = .T.
*-- Aviso a patalla
		Wait Window 'Compresión de Archivos Físicos para el envío ' Timeout 20

*-- Retardo el regreso de control hasta que se comprima el achivo
		A = 0
		Do While A = 100
			A = A + 1
		Enddo
	Endif

*-- Retorno si se proceso o no
	Return llOkProc

	Endproc

*!*	*//////////////////////////////////////////////
*!*	  ***************************************************************************************************
*!*	   *  Procedure : Encriptacion_PGP
*!*	   ***************************************************************************************************
*!*	   *  Parameters  :
*!*	   *  Description :   Encripta los datos con el porducto PGP
*!*	   ***************************************************************************************************
*!*	   *
*!*	   Procedure Compresion_ZIP( tcNomArchGen As String , tcArchivoCab As String , tcArchivoDet As String  )

*!*	      #Define SW_SHOW_HIDDEN 0
*!*	      #Define SW_SHOW_NORMAL 1

*!*	      *-- CArgo el directorio actual del ejecutable y donde estarian los archivos a comprimir
*!*	      lcDireDefa = Fullpath( Curdir() )

*!*	      Local lcArchivoNormal, lcArchivoZipeado, lcComando, loShell, lnResultado, llArchivoOK
*!*	      llArchivoOK = .T.

*!*	      lcArchivoZipeado = lcDireDefa + tcNomArchGen					&& "ConsultaZip.ZIP" Archivo a Generar
*!*	      lcArchivoNormal1 = lcDireDefa + tcArchivoCab					&& "ConsultaZip1.LOG" Primer archivo a Comprimir
*!*	      lcArchivoNormal2 = lcDireDefa + tcArchivoDet					&& "ConsultaZip2.LOG" Segundo Archivo a Comprimir

*!*	      *-- Comando para comprimir ( Son dos Archivos )
*!*	      lcComando = "7za a -mx9 -tZIP " + lcArchivoZipeado + " " + lcArchivoNormal1 + " " +lcArchivoNormal1

*!*	      loShell = Createobject("WScript.Shell")
*!*	      Try
*!*	         lnResultado = loShell.Run(lcComando, SW_SHOW_NORMAL, .T.)
*!*	      Catch
*!*	         =Messagebox("No pude comprimir el archivo " + lcArchivoNormal)
*!*	         llArchivoOK = .F.
*!*	      Endtry

*!*	      loShell = .Null.

*!*	      Release loShell

*!*	      Return
*!*	      *
*!*	   Endproc
*!*	*//////////////////////////////////////////////

***************************************************************************************************
*  Procedure : Compresion_ZIP
***************************************************************************************************
*  Parameters  :
*  Description :   Comprime un archivo pasado como parámetro
***************************************************************************************************
*
	Procedure Compresion_ZIP( tcNombreArchivo As String )
*-- ( tcNomArchGen As String , tcArchivoCab As String , tcArchivoDet As String  )

	#Define SW_SHOW_HIDDEN 0
	#Define SW_SHOW_NORMAL 1

	lcArchivoZipeado = Left(tcNombreArchivo,9) + '.zip'
* lcZip = Addbs(Fullpath(Curdir()))+ lcArchivoZIP

*-- Adjunto el Path de busqueda para direccionar la lectura
	lcArchivoNormal1 = Addbs(Fullpath(Curdir()))  + tcNombreArchivo

	llArchivoOK = .T.

*!*	*///
*!*	      lcArchivoZipeado = lcDireDefa + tcNomArchGen					&& "ConsultaZip.ZIP" Archivo a Generar
*!*	      lcArchivoNormal1 = lcDireDefa + tcArchivoCab					&& "ConsultaZip1.LOG" Primer archivo a Comprimir
*!*	      lcArchivoNormal2 = lcDireDefa + tcArchivoDet					&& "ConsultaZip2.LOG" Segundo Archivo a Comprimir

*-- Comando para comprimir
* lcComando = "7za a -mx9 -tZIP " + lcArchivoZipeado + " " + lcArchivoNormal1 + " " +lcArchivoNormal1
	lcComando = "7za a -mx9 -tZIP " + lcArchivoZipeado + " " + lcArchivoNormal1

	loShell = Createobject("WScript.Shell")
	Try
		lnResultado = loShell.Run(lcComando, SW_SHOW_NORMAL, .T.)
	Catch
		=Messagebox("No pude comprimir el archivo " + lcArchivoNormal1)
		llArchivoOK = .F.
	Endtry

	loShell = .Null.

	Release loShell

	Return
*
	Endproc

***************************************************************************************************
*  Procedure : sp_busco_fecha_serv
***************************************************************************************************
*  Parameters  :   DT si es datetime y DD si es date
*  Description :   Consulta la fecha del día en el servidor de datos
*
***************************************************************************************************
*
	Procedure Busco_Fecha_Serv( vr_tipo, tbNoDefa ) As Date HelpString "Consulta la fecha del día en el servidor de datos"

* lnReturn = SQLExec( This.nConexionSQL,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,currENT_timestamp)},SQL_timestamp)} as fechaHora "+;
"from deltfec ","MWKFecServ")

	This.EjecutarSQL( "SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,currENT_timestamp)},SQL_timestamp)} as fechaHora "+;
		"from deltfec ","MWKFecServ")

	Select MWKFecServ
*!*	      If lnReturn < 0
*!*	         =Aerr(eros)
*!*	         Do Log_errores With Error(), Message(), Message(1)
*!*	      Else
	If vr_tipo = 'DT'
		vr_fdia = MWKFecServ.FechaHora
	Else
		vr_fdia = Ttod(MWKFecServ.FechaHora)
	Endif
	Return vr_fdia

*!*	      Endif

	Endproc

***************************************************************************************************
*  Procedure    :   EjecutarSQL
***************************************************************************************************
*  Parameters  :  tcCMDSQL - Comando o sentencia SQL a Ejecutar . tcNombreCursor es el nombre con que se devuelve la sentencia ejecutada
*  Description :
*  Ejemplo     :  This.EjecutarSQL('Sentencia SQL', 'Cursor a generar' )
***************************************************************************************************
*  Faltaría parámetro (.T.) para generar XML y devolverlo. Puede ser en objeto público para todo el sistem .
	Procedure EjecutarSQL( tcCMDSQL As String , tcNombreCursor As String ) As Logical ;
		helpstring " Ejecutamos el comnado SQLExec y Geneamos Cursor pasado como parámetro "

	Local oError As Object, lcSavePathLog As String

	Try
		If This.nConexionSQL > 0
			lnReturn = SQLExec(This.nConexionSQL, tcCMDSQL , tcNombreCursor )
			If lnReturn < 0
				=Aerr(eros)
				Do log_errores With Error(), Message(), Message(1)
			Endif
		Else
			Wait Window "No hay conexión establecida o se corto la conexión "
			Return .F.
		Endif

	Catch To oError

* This.CRLF = Chr(13)+Chr(10)						&& Esto es propiedad de la clase
* Local lcSavePathLog
		lcSavePathLog = Fullpath( Curdir() )

		Strtofile(Replicate('-',100) +This.CRLF+ "Error ocurrido en : " + Transform(Datetime())+ ;
			' #' + [ Error: ] + Str(oError.ErrorNo)	+This.CRLF+;
			[ LineNo: 		] + Str(oError.Lineno) 		+ This.CRLF+;
			[ Message: 		] + oError.Message 			+ This.CRLF+;
			[ Procedure: 	] + oError.Procedure 		+ This.CRLF+;
			[ Details: 		] + oError.Details 			+ This.CRLF+;
			[ StackLevel: 	] + Str(oError.StackLevel) 	+ This.CRLF+;
			[ LineContents: ] + oError.LineContents  	+ This.CRLF+;
			[ UserValue: 	] + oError.UserValue  +This.CRLF , lcSavePathLog + "Errors.log", .T. )

		Do log_errores With oError.ErrorNo , oError.Message , oError.Details, oError.Procedure, oError.Lineno

		Return .F.
	Endtry

	Release cSavePathLog 			&& Libreamos la variable
	Return .T.

	Endproc

***************************************************************************************************
*  Procedure    :   EnvioViaFTP
***************************************************************************************************
*  Parameters  : tcNombreArchivo - Nombre de archivo a colocar en el comando cmd / bat
*  Description :
*  Ejemplo     : Genera un archivo .cmd o .bat y sube el archivo a donde Pago Facil lo indica (Directorio IN)
***************************************************************************************************
*
	Procedure EnvioViaFTP( tcNombreArchivo As String )
*/////////////////////////////////////////////////////////////////////////////////// Comando a *.cmd a generar
*!*		cd C:\Program Files (x86)\WinSCP
*!*
*!*		winscp.com /command "open sftp://u90063000@sftp.pagofacil.com.ar:22/"  "put C:\desaguemes\Disenio_PagoFacil\300021G30.zip /IN/"
*!*		close
*/////////////////////////////////////////////////////////////////////////////////// Comando a *.cmd a generar

*-- Variables locales
	Local lcPath As String , lcArchivoZIP As String , lcLineaComando As String

*-- Path y armado de path y nombre
	lcPath = Fullpath( Curdir() )
	lcArchivoZIP = lcPath + Left(tcNombreArchivo,9) + '.zip'

	lcLineaComando = "cd C:\Program Files (x86)\WinSCP " + Chr(13) + Chr(10) + ;
		'winscp.com /command "open sftp://u90063000@sftp.pagofacil.com.ar:22/"  "put ' + lcArchivoZIP + ' /IN/" ' + Chr(13)+ Chr(10) + ;
		'Exit'

	Strtofile( lcLineaComando, Addbs(Fullpath(Curdir())) +'ScripPagoFacil.bat' )

*-- Cuanto tengo generado el archivo CMD/BAT lo ejecuto para finalizar el envio via FTP
	Declare Integer ShellExecute In shell32.Dll Integer hndWin, String cAction, String cFileName, ;
		STRING cParams, String cDir, Integer nShowWin

	lcAction   = "open"
	lcFileName = Fullpath(Curdir()) + "ScripPagoFacil.bat"
* lcFileName = 'c:\desaguemes\' + "ScripPagoFacil.cmd"
	=ShellExecute(0, lcAction, lcFileName, "", "", 1)


	Return

	Endproc


***************************************************************************************************
*  Procedure    :   EnvioViaFTP
***************************************************************************************************
*  Parameters  :
*  Description :
*  Ejemplo     :
***************************************************************************************************
*
	Procedure EnvioFTP2
	Set Procedure To prg_ftp.prg Additive

	mArchivoftp = 'PDF/' + Alltrim(Str(mVale))+'.pdf'
	mArchivopdf = 'C:\TEMPDOC\VALPRINT\'+Alltrim(Str(mVale))+'_LAB.pdf'

	sz_ftp = Createobject('ftp_service')

	Select mwkconexionlabo
	Go Top In 'mwkconexionlabo'
	mIPServLabo = Alltrim(mwkconexionlabo.Descrip)

	If !sz_ftp.OpenInternet("labopdf", "labopdf",mIPServLabo, "21")
		=Messagebox('No me puedo conectar al servidor de internet',64,'Error en conexion')
	Else
		f2=sz_ftp.GetFtpFile(mArchivoftp,mArchivopdf)
	Endif

	=sz_ftp.CloseInternet()
	Release Procedure prg_ftp.prg Additive
	Release sz_ftp
	Endproc

*-- Prueba con el activex "Microsoft Internet Transfer Control 6.0" te mando el siguiente ejemplo en el cual le paso como parametro el Archivo, y mi control se llama ftp

	Procedure FTPViaTransferControl( cArch )

* Parameters cArch

	Wait Window "Conectando con el Servidor" Nowait
	lcPaso = "ftp://user:pass@200.200.200.200" 		&& parametros usuario, clave y dirección
	lcrutafuen = "c:\"
	lcrutadest = "/carp"
	lcArchivo = cArch

	Wait Window "enviando "+Alltrim(lcArchivo)+" " Nowait

	Thisform.ftp.EXECUTE(lcPaso,"put "+lcrutafuen+Alltrim(lcArchivo)+" "+Alltrim(lcrutadest);
		+"/"+Alltrim(lcArchivo)+"") 				&& Agrega el archivo

	Do While Thisform.ftp.stillexecuting=.T.
		Loop && espera para que termine
	Enddo

	Thisform.ftp.EXECUTE(lcPaso,"quit") 			&& salir

	Wait Window "Cerrando conexión" Nowait

	Do While Thisform.ftp.stillexecuting=.T.
		Loop && espera
	Enddo

	Thisform.ftp.EXECUTE(lcPaso,"close") && cerrar conexion

	Wait Window "Saliendo de la conexion" Nowait
	Do While Thisform.ftp.stillexecuting=.T.
		Loop
	Enddo

	Endproc

***************************************************************************************************
*  Function    :   ReadIni
***************************************************************************************************
*  Parameters  :  ReadIni - Read a private .INI file
*                 Returns the .INI entry 'cEntry' from section 'cSection' or blank if not found
*  Description :
*  Ejemplo     :  ? ReadIni("ODBC 32 bit Drivers", ;
*	           "Microsoft Visual FoxPro Driver (32 bit)", ;
*	           "ODBCINST.INI" )
***************************************************************************************************
*
	Procedure ReadIni ( cSection, cEntry, cINIFile )
* Parameters cSection, cEntry, cINIFile

	Local cDefault, cRetVal, nRetLen
	cDefault = ""
	cRetVal = Space(255)
	nRetLen = Len(cRetVal)

	Declare Integer GetPrivateProfileString In WIN32API ;
		STRING cSection, ;
		String cEntry, ;
		STRING cDefault, ;
		STRING @cRetVal, ;
		INTEGER nRetLen, ;
		STRING cINIFile

	nRetLen = GetPrivateProfileString(cSection,;
		cEntry, ;
		cDefault, ;
		@cRetVal, ;
		nRetLen, ;
		cINIFile)
	Return Left(cRetVal,nRetLen)

	Endproc

***************************************************************************************************
*  Function :   RiteINI
***************************************************************************************************
*  Parameters  :  RitePini - Write an entry in a private .INI file
* 				 returns .T. if successful, .F. if not
*  Description :
*  Ejemplo     :  ? ReadPini("ODBC 32 bit Drivers", ;
*	           "Microsoft Visual FoxPro Driver (32 bit)", ;
*	           "ODBCINST.INI")
***************************************************************************************************
*

	Procedure RiteINI(cSection As String , cEntry As String , cValue As String , cINIFile As String ) As Logical
* Parameters cSection, cEntry, cValue, cINIFile
	Local nRetVal As Number

	Declare Integer WritePrivateProfileString In WIN32API ;
		STRING cSection, ;
		STRING cEntry, ;
		STRING cValue, ;
		STRING cINIFile

	nRetVal = WritePrivateProfileString(cSection, cEntry, cValue, cINIFile)

	Return nRetVal=1

	Endproc

* ---------------------------------------------
	Procedure Desconexionmotor()

	If This.lDisconnect = .T.
		sp_desconexion()
	Endif

	Endproc

Enddefine
