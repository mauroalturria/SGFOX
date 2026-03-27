**********************************************************************
* Program....: SP_GRABO_SOPORTE_NUTRI.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 18 January 2021, 09:07:20
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 18 January 2021 / 09:07:20
* Purpose....:   Grabo evolucion de soporte Nutriciona del Paciente ( Cabecera y Detalle )
**********************************************************************
*
* tnIDevol = Identificador de Evolucion ( Ejemplo : 192333 )
* tnModoParenteral = Id de tabla TabEstados - Tipo 53 Prop. 25
* tcIpAdress = Direccion IP de la PC que ingresa datos ( 172.16.1.7 )
* tcCambioCabecera = Indica si los datos de cabecera cambiaron para generar una nueva (SI / NO )
*
Parameters tnIdEvol , tcIpAddress , tcCambioCabecera

Private pnUsuario, pdFecha, pcIpAdress, pnIdCabecera

*-- Seteamos variables
m.pnIdUsuario = Iif(Used('mwkusuarios'),mwkusuarios.Id ,mwkusuario.Id)
m.pdFechaHora  = Sp_Busco_Fecha_Serv('DT')
m.pcIpAdress = tcIpAddress
m.nIdEvol = tnIdEvol

If tcCambioCabecera = 'SI' 						&& Si cambio algun dato de cabecera genero una nueva , sino solo cargo Detalle relacionado con cabecera

   Select mwkZabSoportNutriCab
   Scatter Memvar
   m.SPN_EvalGlobSub = Alltrim( mwkZabSoportNutriCab.SPN_EvalGlobSub )

   *-- Datos a Insertar
   lcmdSQL = ''

   *////////////////////////////////////// Cabecera de soporte Nutricional

   *-- Inserción de valores de cabecera
   TEXT TO lcmdSQL TEXTMERGE NOSHOW PRETEXT 7
		INSERT INTO ZabSoportnutriCab ( CodAmbito,
		  SPN_EvalGlobSub, SPN_IdCab, SPN_IdEvol, SPN_IdTipoIngreso, SPN_NRS2002, SPN_Oncologico, SPN_Renal,
		  SPN_FechaEval, SPN_FechaReg, SPN_IDUsuario , SPN_IpAdress )
		VALUES ( ?m.CodAmbito, ?m.SPN_EvalGlobSub, ?m.SPN_IdCab, ?m.nIdEvol, ?m.SPN_IdTipoIngreso, ?m.SPN_NRS2002,
		  ?m.SPN_Oncologico, ?m.SPN_Renal, ?m.SPN_FechaEval, ?m.pdFechaHora , ?m.pnIdUsuario, ?m.pcIpAdress )
   ENDTEXT

   lnReturn = SQLExec( mcon1, lcmdSQL, 'mwkTempCab')

   If lnReturn <= 0
      =Aerror(mError)
      Messagebox("ERROR AL GUARDAR LA EVOLUCION DE SOPORTE NUTRICIONAL (Cab)"+Chr(10)+ Alltrim(mError(3)),16,"ERROR")
      *      Messagebox("ERROR AL GUARDAR LA EVOLUCION DE SOPORTE NUTRICIONAL (Cab)",16,"ERROR")
      Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()
      Return .F.
   Endif

   *-- Busco el ID otrogado a la cabecera
   lnReturn = SQLExec( mcon1, "SELECT Id as lId FROM ZabSoportNutriCab WHERE SPN_IdUsuario = ?m.pnIdUsuario AND SPN_IpAdress = ?m.pcIpAdress"+;
      " AND SPN_FechaReg = ?m.pdFechaHora Order by ZabSoportNutriCab.Id Desc ", "mwkIDCab" )
   Select mwkIDCab
   Go Top

   *////////////////////////////////////// Detalle de soporte Nutricional
   Select mwkZabSoportNutriDet
   Scatter Memvar

   *-- Verifico el contenido de campo y formatos
   m.SPN_FechaEval = Iif( m.SPN_FechaEval = {//}, .Null., m.SPN_FechaEval )
   m.SPN_FechaIni = Iif( m.SPN_FechaIni = {//}, .Null. , m.SPN_FechaIni )
   m.SPN_FecColParente = Iif( m.SPN_FecColParente = {//}, .Null., m.SPN_FecColParente )
   m.SPN_FecExtracion = Iif( m.SPN_FecExtracion = {//}, .Null., m.SPN_FecExtracion )
   m.SPN_FecMetaAlcanzar = Iif( m.SPN_FecMetaAlcanzar = {//}, .Null., m.SPN_FecMetaAlcanzar )
   m.SPN_FecMetaAlcanzo = Iif( m.SPN_FecMetaAlcanzo = {//}, .Null. ,m.SPN_FecMetaAlcanzo )
   m.SPN_FecAltaSopor = Iif( m.SPN_FecAltaSopor = {//}, .Null., m.SPN_FecAltaSopor )
   m.SPN_FecAltaConSopor = Iif( m.SPN_FecAltaConSopor = {//}, .Null. ,m.SPN_FecAltaConSopor )

   m.pnIdCabecera = mwkIDCab.lId				&& Asigno número de Id de la cabecera
   lcmdSQL2 = ''

   *-- Insercion de valores de cabecera
   TEXT TO lcmdSQL2 TEXTMERGE NOSHOW PRETEXT 7
	INSERT INTO ZabsoportnutriDet ( SPN_IdEvol, SPN_IdCab,
			  SPN_Peso, SPN_Talla,SPN_Imc, SPN_FechaEval, SPN_FechaIni,
			  SPN_TipoSoporte,SPN_AcceEnteral,SPN_AcceParenteral,SPN_FecColParente,
			  SPN_FecExtracion,SPN_MotivExtraccion,SPN_ReqCaloriPerdida,
			  SPN_ReqCaloriManten,SPN_ReqCaloriReplecion,SPN_TipoMetCalori,
			  SPN_TipoMetProteica,SPN_FecMetaAlcanzar,SPN_FecMetaAlcanzo,
			  SPN_FecAltaSopor, SPN_MotivoAlta,SPN_FecAltaConSopor,
			  SPN_VolumIndicEvol,SPN_FlujoIndicEvol, SPN_EnteRGE, SPN_EnteVomitos,
			  SPN_EnteDiarrea,SPN_EnteConstipacion,SPN_EnteDistAbdom,SPN_EnteSalAccSNG,
			  SPN_EnteOclusAcceso,SPN_EntePeristomia,SPN_EnteInfecOstomet,
			  SPN_ParenIRCBacteria,SPN_ParenIRCNoBacteria,SPN_ParenSecPurulenta,
			  SPN_ParenObstCateter,SPN_ParenSalCateter,SPN_ObsPlanNutric, SPN_IDUsuario,
			  SPN_IpAdress )
	   VALUES ( ?m.nIdEvol, ?m.pnIdCabecera,
			  ?m.SPN_Peso, ?m.SPN_Talla, ?m.SPN_Imc, ?m.SPN_FechaEval, ?m.SPN_FechaIni,
			  ?m.SPN_TipoSoporte, ?m.SPN_AcceEnteral, ?m.SPN_AcceParenteral, ?m.SPN_FecColParente,
			  ?m.SPN_FecExtracion, ?m.SPN_MotivExtraccion, ?m.SPN_ReqCaloriPerdida,
			  ?m.SPN_ReqCaloriManten, ?m.SPN_ReqCaloriReplecion, ?m.SPN_TipoMetCalori,
			  ?m.SPN_TipoMetProteica, ?m.SPN_FecMetaAlcanzar, ?m.SPN_FecMetaAlcanzo ,
			  ?m.SPN_FecAltaSopor, ?m.SPN_MotivoAlta, ?m.SPN_FecAltaConSopor,
			  ?m.SPN_VolumIndicEvol, ?m.SPN_FlujoIndicEvol, ?m.SPN_EnteRGE, ?m.SPN_EnteVomitos,
			  ?m.SPN_EnteDiarrea, ?m.SPN_EnteConstipacion, ?m.SPN_EnteDistAbdom, ?m.SPN_EnteSalAccSNG,
			  ?m.SPN_EnteOclusAcceso, ?m.SPN_EntePeristomia, ?m.SPN_EnteInfecOstomet,
			  ?m.SPN_ParenIRCBacteria, ?m.SPN_ParenIRCNoBacteria, ?m.SPN_ParenSecPurulenta,
			  ?m.SPN_ParenObstCateter, ?m.SPN_ParenSalCateter, ?m.SPN_ObsPlanNutric, ?m.pnIdUsuario,
			  ?m.pcIpAdress )
   ENDTEXT

   *-- Insercion de datos a la tabla
   lnReturn = SQLExec( mcon1, lcmdSQL2, 'mwkTempDet')

   If lnReturn <= 0
      =Aerror(mError)
      Messagebox("ERROR AL GUARDAR LA EVOLUCION DE SOPORTE NUTRICIONAL (Det)"+Chr(10)+ Alltrim(mError(3)),16,"ERROR")
      * Messagebox("ERROR AL GUARDAR LA EVOLUCION DE SOPORTE NUTRICIONAL (Det)",16,"ERROR")
      Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()

      *-- Borro cabcera si no se pudo grabar detalle
      lnReturnCab = SQLExec( mcon1, "DELETE FROM ZabSoportNutriCab WHERE ZabSoportNutriCab.Id = ?m.pnIdCabecera ", 'mwkTempCab')
      If lnReturnCab <= 0
         =Aerror(mError)
         Messagebox("ERROR al Anular Cabecera ",16,"ERROR")
         Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()
      Endif

      Return .F.
      llCintinuo = .F.
   Else
      llCintinuo = .T.
   Endif

Else			&& Si no hay cambio en Cabecera solo detalle

   Select mwkZabSoportNutriDet
   Scatter Memvar
   * Cargo el identificador de cabecera ( Relacional )
   m.pnIdCabecera = mwkZabSoportNutriDet.SPN_IdCab 				&& Id cabecera que no cambia

   *-- Verifico el contenido de campo y formatos
   m.SPN_FechaEval = Iif( m.SPN_FechaEval = {//}, .Null., m.SPN_FechaEval )
   m.SPN_FechaIni = Iif( m.SPN_FechaIni = {//}, .Null. , m.SPN_FechaIni )
   m.SPN_FecColParente = Iif( m.SPN_FecColParente = {//}, .Null., m.SPN_FecColParente )
   m.SPN_FecExtracion = Iif( m.SPN_FecExtracion = {//}, .Null., m.SPN_FecExtracion )
   m.SPN_FecMetaAlcanzar = Iif( m.SPN_FecMetaAlcanzar = {//}, .Null., m.SPN_FecMetaAlcanzar )
   m.SPN_FecMetaAlcanzo = Iif( m.SPN_FecMetaAlcanzo = {//}, .Null. ,m.SPN_FecMetaAlcanzo )
   m.SPN_FecAltaSopor = Iif( m.SPN_FecAltaSopor = {//}, .Null., m.SPN_FecAltaSopor )
   m.SPN_FecAltaConSopor = Iif( m.SPN_FecAltaConSopor = {//}, .Null. ,m.SPN_FecAltaConSopor )

   lcmdSQL2 = ''
   *-- Insercion de valores de cabecera
   TEXT TO lcmdSQL2 TEXTMERGE NOSHOW PRETEXT 7
		INSERT INTO ZabsoportnutriDet ( SPN_IdEvol, SPN_IdCab,
			  SPN_Peso, SPN_Talla,SPN_Imc, SPN_FechaEval, SPN_FechaIni,
			  SPN_TipoSoporte,SPN_AcceEnteral,SPN_AcceParenteral,SPN_FecColParente,
			  SPN_FecExtracion,SPN_MotivExtraccion,SPN_ReqCaloriPerdida,
			  SPN_ReqCaloriManten,SPN_ReqCaloriReplecion,SPN_TipoMetCalori,
			  SPN_TipoMetProteica,SPN_FecMetaAlcanzar,SPN_FecMetaAlcanzo,
			  SPN_FecAltaSopor, SPN_MotivoAlta,SPN_FecAltaConSopor,
			  SPN_VolumIndicEvol,SPN_FlujoIndicEvol, SPN_EnteRGE, SPN_EnteVomitos,
			  SPN_EnteDiarrea,SPN_EnteConstipacion,SPN_EnteDistAbdom,SPN_EnteSalAccSNG,
			  SPN_EnteOclusAcceso,SPN_EntePeristomia,SPN_EnteInfecOstomet,
			  SPN_ParenIRCBacteria,SPN_ParenIRCNoBacteria,SPN_ParenSecPurulenta,
			  SPN_ParenObstCateter,SPN_ParenSalCateter,SPN_ObsPlanNutric, SPN_IDUsuario,
			  SPN_IpAdress )
	   VALUES ( ?m.nIdEvol, ?m.pnIdCabecera,
			  ?m.SPN_Peso, ?m.SPN_Talla, ?m.SPN_Imc, ?m.SPN_FechaEval, ?m.SPN_FechaIni ,
			  ?m.SPN_TipoSoporte, ?m.SPN_AcceEnteral, ?m.SPN_AcceParenteral, ?m.SPN_FecColParente,
			  ?m.SPN_FecExtracion, ?m.SPN_MotivExtraccion, ?m.SPN_ReqCaloriPerdida,
			  ?m.SPN_ReqCaloriManten, ?m.SPN_ReqCaloriReplecion, ?m.SPN_TipoMetCalori,
			  ?m.SPN_TipoMetProteica, ?m.SPN_FecMetaAlcanzar, ?m.SPN_FecMetaAlcanzo ,
			  ?m.SPN_FecAltaSopor, ?m.SPN_MotivoAlta, ?m.SPN_FecAltaConSopor,
			  ?m.SPN_VolumIndicEvol, ?m.SPN_FlujoIndicEvol, ?m.SPN_EnteRGE, ?m.SPN_EnteVomitos,
			  ?m.SPN_EnteDiarrea, ?m.SPN_EnteConstipacion, ?m.SPN_EnteDistAbdom, ?m.SPN_EnteSalAccSNG,
			  ?m.SPN_EnteOclusAcceso, ?m.SPN_EntePeristomia, ?m.SPN_EnteInfecOstomet,
			  ?m.SPN_ParenIRCBacteria, ?m.SPN_ParenIRCNoBacteria, ?m.SPN_ParenSecPurulenta,
			  ?m.SPN_ParenObstCateter, ?m.SPN_ParenSalCateter, ?m.SPN_ObsPlanNutric, ?m.pnIdUsuario,
			  ?m.pcIpAdress )
   ENDTEXT

   *-- Insercion de datos a la tabla
   lnReturn = SQLExec( mcon1, lcmdSQL2, 'mwkTempDet')

   If lnReturn <= 0
      =Aerror(mError)
      Messagebox("ERROR AL GUARDAR LA EVOLUCION DE SOPORTE NUTRICIONAL (Det2)",16,"ERROR")
      Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()

      *-- Borro cabcera si no se pudo grabar detalle
      lnReturnCab = SQLExec( mcon1, "DELETE FROM ZabSoportNutriCab WHERE ZabSoportNutriCab.Id = ?m.pnIdCabecera ", 'mwkTempCab')
      If lnReturnCab <= 0
         =Aerror(mError)
         Messagebox("ERROR al Anular Cabecera ",16,"ERROR")
         Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()
      Endif
      llCintinuo = .F.
      Return .F.
   Else
      llCintinuo = .T.
   Endif

Endif


*//////////////////////////////////
* tnModoEnteral, tnModoParenteral

*!*	Select mwkTabintAVNTemp
*!*	m.FechaInicio = Iif( mwkTabintAVNTemp.AVN_FechaIni = {//}, .Null., mwkTabintAVNTemp.AVN_FechaIni )
*!*	m.FechaFin = Iif( mwkTabintAVNTemp.AVN_FechaFin = {//}, .Null., mwkTabintAVNTemp.AVN_FechaFin )

m.FechaInicio = m.SPN_FechaIni
m.FechaFin = IIF( !ISNULL( m.SPN_FecAltaSopor ), m.SPN_FecAltaSopor, m.SPN_FecAltaConSopor )
*!*	
*If Empty( mwkTabintAVNTemp.AVN_FechaFin )
IF EMPTY( m.FechaFin ) OR ISNULL( m.FechaFin ) 
   * If EMPTY( mwkTabintavnTemp.AVN_FechaFin ) 					&& Solo Insert , sino Update de registro
   Select mwkTabintAVNTemp
   Scan
      Scatter Memvar
      lcSQLScrip = ''
      TEXT to lcSQLScrip textmerge noshow pretext 7
		   INSERT INTO Tabintavn (  AVN_Complica, AVN_FechaH,
		         AVN_FechaFin, AVN_FechaIni, AVN_IdEvol,
		         AVN_Modo, AVN_Motivo, AVN_Tipo, AVN_Usuario )
		         Values ( ?m.AVN_complica, ?m.AVN_fechaH,
		         ?m.AVN_FechaFin, ?m.AVN_fechaini, ?m.nIdEvol,
		         ?m.AVN_modo, ?m.AVN_motivo, ?m.AVN_tipo , ?m.AVN_usuario )
      ENDTEXT

      *-- Ejecutamos la consulta al motor
      If SQLExec( mcon1, lcSQLScrip, 'mwkTabIntAvnTemp' ) = 1
         * Browse de tabla
         * Browse Title "Cursor ZabISeg " Nowait
      Else
         =Aerror(lcArrayError)
         Messagebox("ERROR EN LA INSERCION DE DATOS PARA Tabintavn "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
         *-- Fallo la consulta al motor
         Return  .F.
      Endif
   Endscan

Else  								&& Solo Update por que finaliza

   lcSQLScrip = ''
   TEXT to lcSQLScrip textmerge noshow pretext 7
	   UPDATE Tabintavn SET Tabintavn.AVN_FechaFin = ?m.FechaFin
	   WHERE Tabintavn.AVN_FechaIni = ?m.FechaInicio AND
	         Tabintavn.AVN_IdEvol = ?m.nIdEvol
   ENDTEXT
   *-- Ejecutamos la consulta al motor
   If SQLExec( mcon1, lcSQLScrip, 'mwkTabIntAvnTemp' ) = 1
      * Browse de tabla
      * Browse Title "Cursor ZabISeg " Nowait
   Else
      =Aerror(lcArrayError)
      Messagebox("ERROR EN LA INSERCION DE DATOS PARA Tabintavn "+Chr(13)+ Alltrim(Str(lcArrayError(1))) + ' ' + lcArrayError(2) , 48, 'Aviso al Usuario - SQL Connect Message' )
      *-- Fallo la consulta al motor
      Return  .F.
   Endif

Endif



