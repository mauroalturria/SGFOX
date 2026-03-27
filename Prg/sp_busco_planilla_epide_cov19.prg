**********************************************************************
* Program....: SP_BUSCO_PLANILLA_EPIDE_COV19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 17 Mar 2020, 09:48:45
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 15 Mar 2020 / 09:48:45
* Purpose....:
**********************************************************************
Parameters tnOrigen , tnRegistro , tnIdRegistro
Local lcCmdSQL, BuscRegistrac , liIdplanillaCont

If Used( 'mwkEpidemioCOV19' )
   Use In mwkEpidemioCOV19
Endif
*
If Used( 'mwkEpidemioCOV19Cont' )
   Use In mwkEpidemioCOV19Cont
Endif

lcCmdSQL = ''
m.BuscaRegistro = Iif( Vartype( tnRegistro ) = 'N', Alltrim( Str(tnRegistro) ), tnRegistro )

*////////////////////////////////////

lcCmdSQL = "SELECT * FROM Zabfichepncov19 Where COV_Registrac = " + m.BuscaRegistro + "ORDER BY ID Desc "
lnReturn = SQLExec(mcon1, lcCmdSQL , "mwkEpidemioCOV19" )

If lnReturn < 0
   =Aerror(merror)
   Messagebox("Error de consulta para COVID19 " + Chr(10)+ Alltrim(merror(3)), 16, "ERROR")
   Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Else

   *-- Si trajo mas de un registro con Locate lo encuentro y sigo
   Select mwkEpidemioCOV19

   If !Empty( tnIdRegistro )
      Locate For mwkEpidemioCOV19.Id = tnIdRegistro						&& Por si hay mas de un Registro
   Endif

   m.liIdplanillaCont = Str( mwkEpidemioCOV19.Id )
   mFechaPasivo = ctod("01/01/1900") 
   
   *   TEXT TO lcCOMDContactos TEXTMERGE NOSHOW PRETEXT 7
   lcCOMDContactos = "SELECT Zabcov19contacto.CON_ApeNom , "+ ;
      "Zabcov19contacto.CON_Documento  , "+ ;
      "Zabcov19contacto.CON_Telefono,"+ ;
      "Zabcov19contacto.CON_ContEstrechoDom ,"+ ;
      "Zabcov19contacto.CON_ContEstrechoFecha , "+ ;
      "Zabcov19contacto.CON_ContEstrechoTipo , "+ ;
      "Zabcov19contacto.CON_Comentarios , "+ ;
      "Zabcov19contacto.ID , "+ ;
      "Zabcov19contacto.CON_Idplanilla ,"+ ;
      "Zabcov19contacto.CON_FecPasiva " +;
      "FROM Zabcov19contacto "+ ;
      "WHERE Zabcov19contacto.CON_Idplanilla = ?m.liIdplanillaCont AND " +;
       "Zabcov19contacto.CON_FecPasiva > ?mFechaPasivo "
   *   ENDTEXT

* STRTOFILE( lcCOMDContactos , "SQLContactos.txt" )

   lnReturn = SQLExec(mcon1, lcCOMDContactos , "mwkEpidemioCOV19Cont" )

   If lnReturn < 0
      =Aerror(merror)
      Messagebox("ERROR EN FICHAS DE EPIDEMIOLOGIA COVID-19 para contactos " + Chr(10)+ Alltrim(merror(3)), 16, "ERROR")
      Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Endif

Endif


