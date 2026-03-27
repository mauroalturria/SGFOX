**********************************************************************
* Program....: SP_GRABO_TURNOEGRINT.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 13 October 2021, 13:51:53
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 13 October 2021 / 13:51:53
* Purpose....: 	Graba la Gilla con las especialidades cargadas al seleccionar Turno de Egreso
*               Viene del Formulario FRMADMISION47.scx
**********************************************************************
*
*--
Parameters tCodAdmision , tCodEspecialid ,  tCodmed , tFechaHD , tFechaHH , tFechaPasiva,   tlModifica

*/////////////////
Local nReturn
nReturn = 0

Private cCodAdmision , dFechaServer, EICodEspecialid ,EICodmed , EIFechaHD , EIFechaHH , EIFechaPasiva 

m.EICodEspecialid = tCodEspecialid
m.EICodmed = tCodmed
m.EIFechaHD = tFechaHD
m.EIFechaHH = tFechaHH
m.EIFechaPasiva = tFechaPasiva
m.EICodAdmision = tCodAdmision

*!*	*-- Existe el datos en tabla
*!*	TEXT TO lcmdSQL1 TEXTMERGE NOSHOW PRETEXT 7
*!*			Select * From  ZabIntTurnosEspec
*!*			Where EI_CodEspecialid  = ?m.EICodEspecialid And EICodAdmision = ?m.EICodAdmision 
*!*			And EI_FechaPasiva <> '2100-01-01'
*!*	ENDTEXT
*!*	*-- Ejecutamos la inserción al motor de datos
*!*	nReturn = SQLExec( mcon1, lcmdSQL1 , 'mwkTempExiste' )


*-- Insertamos los datos Cargados en la Grilla del formulario FRMADMISION47
lcmdSQL2 = ''
TEXT TO lcmdSQL2 TEXTMERGE NOSHOW PRETEXT 7
	INSERT INTO ZabIntTurnosEspec (
	   EI_CodEspecialid,
	   EI_Codmed,
	   EI_FechaHD,
	   EI_FechaHH,
	   EI_FechaPasiva,
	   EI_CodAdmision )
	    VALUES (
	   ?m.EICodEspecialid ,
	   ?m.EICodmed ,
	   ?m.EIFechaHD ,
	   ?m.EIFechaHH ,
	   ?m.EIFechaPasiva ,
	   ?m.EICodAdmision )
ENDTEXT

*-- Ejecutamos la inserción al motor de datos
nReturn = SQLExec( mcon1, lcmdSQL2 , 'mwkTemp' )

If nReturn < 0
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox("EN INCORPORACION DE DATOS PARA TURNO DE EGRESO " + Chr(10) + "AVISE A SISTEMAS",16,"ERROR")
Endif




