**********************************************************************
* Program....: SP_ACTUALIZO_DATOSWEB.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 16 December 2021, 18:28:47
* Notice.....: Copyright © 2021, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 16 December 2021 / 18:28:47
* Purpose....:   Actualizacion de datos para la Web (www.SG.com.ar)
**********************************************************************
*
Parameters tnNroRegistacion , tcApellido, tcNombre , tcNroTelefono , txEmail

*     If llHagoUpdate = .T.
lcUsuario     = mwkusuario.idusuario
ldFechaActual = sp_busco_fecha_serv('DT')
llProcesoOK = .T.

*///////////////////////////////////////
*--  Update de Tablas

*!*	*-- Registracio
*!*	Private nRegistro, cApellidoNombre

*!*	m.nRegistro       = tnNroRegistacion 							&& 3583700
*!*	m.cApellidoNombre = ALLTRIM( tcApellido ) +','+ tcNombre
*!*	TEXT TO lcCMSQL1 TEXTMERGE NOSHOW PRETEXT 7
*!*					UPDATE Registracio SET Registracio.REG_nombrepac = ?m.cApellidoNombre
*!*					WHERE Registracio.REG_nroregistrac = ?m.nRegistro
*!*	ENDTEXT

*!*	*Registracio.REG_telefonos = '1553411540'
*!*	lnReturn = SQLExec(mcon1, lcCMSQL1,"mwkTemp1")

*!*	If lnReturn < 1
*!*	   * =Aerr(eros)
*!*	   Do log_errores With Error(), Message(), Message(1)
*!*	   * Messagebox( "Error de escritura de la tabla Registracio ",0+64,'Aviso al Usuario' )
*!*	   llProcesoOK = .F.
*!*	   Exit
*!*	Endif
*/////////////////////////////////

*-- TabwRegistra
Private nRegistracion, cApellidos , cNombre , Email , cUsuario, dFechaActual
m.nRegistacion = tnNroRegistacion 					&& Nro. registacion 
m.cApellidos = tcApellido 							&& Apelldiso
m.cNombre = tcNombre 								&& Nombre
m.Email = txEmail 									&& email 
m.cUsuario = lcUsuario								&& Usuario que intenta grabar
dFechaActual = ldFechaActual 						&& Fecha Actual 	

TEXT TO lcCMSQL2 TEXTMERGE NOSHOW PRETEXT 7
			  UPDATE TabwRegistra SET
				Tabwregistra.TWR_Apellido = ?m.cApellidos ,
				Tabwregistra.TWR_Nombre = ?m.cNombre ,
				Tabwregistra.TWR_Mail = ?m.Email ,
				Tabwregistra.UserDbUpd = ?m.cUsuario ,
				Tabwregistra.FecHorDbUpd = ?m.dFechaActual 
				WHERE Tabwregistra.TWR_Registra = ?m.nRegistacion
ENDTEXT

*Registracio.REG_telefonos = '1553411540'
lnReturn = SQLExec(mcon1, lcCMSQL2,"mwkTemp2")

If lnReturn < 1
   * =Aerr(eros)
   Do log_errores With Error(), Message(), Message(1)
   * Messagebox( "Error de escritura de la tabla Registracio ",0+64,'Aviso al Usuario' )
   llProcesoOK = .F.
   Exit
Endif


*/////////////////////////////////
*-- Tabwregtel
Private dFechaHora, nNroTelefono , nRegistra
m.dFechaHora = ldFechaActual
m.nNroTelefono = tcNroTelefono
m.nRegistra = tnNroRegistacion

TEXT TO lcCMSQL3 TEXTMERGE NOSHOW PRETEXT 7
				UPDATE Tabwregtel SET Tabwregtel.TWT_FecHorAdd = ?m.dFechaHora ,
				                      Tabwregtel.TWT_Nro = ?m.nNroTelefono
				  WHERE Tabwregtel.TWL_Registra = ?m.nRegistra
ENDTEXT

*Registracio.REG_telefonos = '1553411540'
lnReturn = SQLExec(mcon1, lcCMSQL3,"mwkTemp3")

If lnReturn < 1
   * =Aerr(eros)
   Do log_errores With Error(), Message(), Message(1)
   * Messagebox( "Error de escritura de la tabla Registracio ",0+64,'Aviso al Usuario' )
   llProcesoOK = .F.
   Exit
Endif

*      Endif
RETURN llProcesoOK 


