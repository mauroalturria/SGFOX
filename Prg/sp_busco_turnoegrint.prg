**********************************************************************
* Program....: SP_BUSCO_TURNOEGRINT.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 07 October 2021, 10:37:37
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 07 October 2021 / 10:37:37
* Purpose....:
**********************************************************************
*
Lparameters tnCodAdmision

Private lnCodAdmision

m.lnCodAdmision = tnCodAdmision

*-- Busco en tabla los datos de el paciente con nro de admision
lcCMDSQL = "SELECT  Especialid.ESP_Descripcion, ZabIntTurnosEspec.EI_FechaHD, ZabIntTurnosEspec.EI_FechaHH, "+;
   "ZabIntTurnosEspec.EI_CodEspecialid, ZabIntTurnosEspec.ID,"+;
   "ZabIntTurnosEspec.EI_CodAdmision ,"+;
   "ZabIntTurnosEspec.EI_Codmed,"+;
   "ZabIntTurnosEspec.EI_FechaPasiva "+;
   "FROM ZabIntTurnosEspec "+;
   "INNER JOIN ESPECIALID ON ZabIntTurnosEspec.EI_CodEspecialid = Especialid.ESP_CodEsp "+;
   "WHERE ZabIntTurnosEspec.EI_CodAdmision = ?m.lnCodAdmision AND ZabIntTurnosEspec.EI_FechaPasiva <> '2100-01-01' "

   *-- Antes AND EI_FechaHH <> '2100-01-01' "

nReturn = SQLExec(mcon1, lcCMDSQL , 'mwkEIServires' )

If nReturn < 1
   =Aerror(eros)
   Messagebox("ERROR EN LA CONSULTA DE DATOS AL MOTOR (ZabIntTurnosEspec) ",16,"AVISO AL USUARIO")
Endif

