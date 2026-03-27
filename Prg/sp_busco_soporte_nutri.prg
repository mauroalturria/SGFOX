**********************************************************************
* Program....: SP_BUSCO_SOPORTE_NUTRI.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 18 January 2021, 09:36:38
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 18 January 2021 / 09:36:38
* Purpose....:   Busco datos de Soporte Nutricional ( Cabecera/Detalle ) - Solapas Soporte nutricional (Pisos)
**********************************************************************
*
Lparameters tnIdEvol

Private IDEvolData, pdFechaHora
Local lnReturn, lcCMDSQL1, lcCMDSQL2

*-- Si exsiten los cursores los elimino y regenero
If Used('mwkZabSoportNutriCab')
   Use In mwkZabSoportNutriCab
Endif

If Used('mwkZabSoportNutriDet')
   Use In mwkZabSoportNutriDet
Endif

*-- Paso a variable
m.IDEvolData = tnIdEvol

*-- Consultmos la cabecera segun parametro
lcCMDSQL = ''
TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
	SELECT ZabsoportnutriCab.ID ,
	  Zabsoportnutricab.SPN_EvalGlobSub, Zabsoportnutricab.SPN_IdCab,
	  Zabsoportnutricab.SPN_IdEvol, Zabsoportnutricab.SPN_IdTipoIngreso,
	  Zabsoportnutricab.SPN_IpAdress, Zabsoportnutricab.SPN_NRS2002,
	  Zabsoportnutricab.SPN_Oncologico, Zabsoportnutricab.SPN_Renal,
	  Zabsoportnutricab.SPN_FechaEval,
	  Zabsoportnutricab.CodAmbito,
	  Zabsoportnutricab.FecHorDbAdd, Zabsoportnutricab.FecHorDbUpd,
	  Zabsoportnutricab.SPN_IdUsuario
	 FROM ZabSoportNutriCab
       WHERE ZabsoportnutriCab.SPN_IdEvol = ( ?m.IDEvolData ) AND
       ZabsoportnutriCab.ID = ( Select max(ZabSoportNutriCab.Id ) from ZabSoportNutriCab WHERE ZabSoportNutriCab.SPN_IdEvol = ( ?m.IDEvolData ) )
ENDTEXT

*-- Consultamos al motor de datos
lnReturn = SQLExec(mcon1,lcCMDSQL, "mwkZabSoportNutriCab")

If lnReturn <= 0
   Messagebox("ERROR AL CONSULTAR LOS DATOS DE SOPORTE NUTRICIONAL (Cab)",16,"ERROR")
   Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Else
   *-- Si no hay cabecera es registro nuevo , preparo los curores para contener los datos
   If Reccount('mwkZabSoportNutriCab') = 0
      *-- Consigo la Fecha del Servidor
      m.pdFechaHora  = Sp_Busco_Fecha_Serv('DT')
      *-- Cabecera
      lnReturn = SQLExec(mcon1,"SELECT * FROM ZabSoportNutriCab WHERE SPN_IdUsuario = 0 " , "mwkZabSoportNutriCab" )
      Select mwkZabSoportNutriCab
      Append Blank
      Replace SPN_FechaEval With m.pdFechaHora
      *-- Detalleg
      lnReturn = SQLExec(mcon1,"SELECT * FROM ZabSoportNutriDet WHERE SPN_IdUsuario = 0 ","mwkZabSoportNutriDet" )
      Select mwkZabSoportNutriDet
      Append Blank
      Replace SPN_FechaEval With m.pdFechaHora
      Return .T.
   Endif
Endif

*///////////////////
* Si todo esta ok traemos los datos de detalle
Select mwkZabSoportNutriCab
If mwkZabSoportNutriCab.Id <> 0
   *-- Para la buscar datos de detalle asigno varaibles
   m.IdCabecera = mwkZabSoportNutriCab.Id
   * m.IDEvolData = mwkZabSoportNutriCab.SPN_IdEvol

   lcCMDSQL2 = ''
   TEXT TO lcCMDSQL2 TEXTMERGE NOSHOW PRETEXT 7
		SELECT SPN_IdEvol, SPN_IdCab,
			  SPN_Peso, SPN_Talla,
			  SPN_Imc,
			  SPN_FechaEval,
			  SPN_FechaIni ,
			  SPN_TipoSoporte,
			  SPN_AcceEnteral, SPN_AcceParenteral,
			  SPN_FecColParente ,
			  SPN_FecExtracion,
			  SPN_MotivExtraccion, SPN_ReqCaloriPerdida,
			  SPN_ReqCaloriManten, SPN_ReqCaloriReplecion,
			  SPN_TipoMetCalori, SPN_TipoMetProteica,
			  SPN_FecMetaAlcanzar ,
			  SPN_FecMetaAlcanzo ,
			  SPN_FecAltaSopor ,
			  SPN_MotivoAlta,
			  SPN_FecAltaConSopor,
			  SPN_VolumIndicEvol,
			  SPN_FlujoIndicEvol, SPN_EnteRGE,
			  SPN_EnteVomitos, SPN_EnteDiarrea,
			  SPN_EnteConstipacion,SPN_EnteDistAbdom,
			  SPN_EnteSalAccSNG,SPN_EnteOclusAcceso,
			  SPN_EntePeristomia,SPN_EnteInfecOstomet,
			  SPN_ParenIRCBacteria,SPN_ParenIRCNoBacteria,
			  SPN_ParenSecPurulenta,SPN_ParenObstCateter,
			  SPN_ParenSalCateter,SPN_ObsPlanNutric,
			  SPN_IDUsuario, SPN_IpAdress
		FROM ZabSoportNutriDet
		WHERE ZabSoportnutriDet.SPN_IdCab = ( ?m.IdCabecera ) AND
		       ZabsoportnutriDet.SPN_IdEvol = ( ?m.IdEvolData ) AND
               ZabsoportnutriDet.ID = ( Select MAX(ZabSoportNutriDet.Id ) FROM ZabSoportNutriDet
                                  WHERE  ZabsoportnutriDet.SPN_IdEvol = ( ?m.IdEvolData ) )
   ENDTEXT

   *-- Consultamos al motor de datos y verificamos error
   lnReturn = SQLExec(mcon1, lcCMDSQL2, "mwkZabSoportNutriDet")    &&
   If lnReturn <= 0
      =Aerror(lcArrayError)
      Messagebox("ERROR AL CONSULTAR LOS DATOS DE SOPORTE NUTRICIONAL (Det) ",16,"ERROR")
      Do Log_Errores With Error(), Message(), Message(1), Program(), Lineno()
      Return .F.
   Else
      *// Su por esa casualidad del universo - "Todo lo que puede salir mal, seguro que saldrá mal". (Ley de Murphy)
      If Reccount('mwkZabSoportNutriDet') = 0
         *-- Detalleg
         lnReturn = SQLExec(mcon1,"SELECT * FROM ZabSoportNutriDet WHERE SPN_IdUsuario = 0 ","mwkZabSoportNutriDet" )
         Select mwkZabSoportNutriDet
         Append Blank
         *-- valores de la cabecera
         Replace mwkZabSoportNutriDet.SPN_IdEvol With m.IDEvolData , mwkZabSoportNutriDet.SPN_IdCab With m.IdCabecera
      Endif
   Endif

Endif

*/// Control Fechas
* El tema fecha un dolor de muales
Select mwkZabSoportNutriDet
Replace SPN_FechaEval With Iif( Isnull(SPN_FechaEval), {}, SPN_FechaEval ), ;
   SPN_FechaIni With Iif( Isnull(SPN_FechaIni) ,{}, SPN_FechaIni ), ;
   SPN_FecColParente With Iif( Isnull(SPN_FecColParente) ,{}, SPN_FecColParente ), ;
   SPN_FecExtracion With Iif( Isnull(SPN_FecExtracion) ,{}, SPN_FecExtracion ), ;
   SPN_FecMetaAlcanzar With Iif( Isnull(SPN_FecMetaAlcanzar) ,{}, SPN_FecMetaAlcanzar ), ;
   SPN_FecMetaAlcanzo With Iif( Isnull(SPN_FecMetaAlcanzo) ,{}, SPN_FecMetaAlcanzo ), ;
   SPN_FecAltaSopor With Iif( Isnull(SPN_FecAltaSopor) ,{}, SPN_FecAltaSopor ), ;
   SPN_FecAltaConSopor With Iif( Isnull(SPN_FecAltaConSopor) ,{}, SPN_FecAltaConSopor )

Select mwkZabSoportNutriCab
