**********************************************************************
* Program....: SP_READWRITINI.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 03 September 2020, 10:51:00
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 03 September 2020 / 10:51:00
* Purpose....:
**********************************************************************
*
* Seteo  :  Set Procedure To ..\prg\sp_readwritini.prg
*
***************************************************************************************************
*  FuncTion : ReadpINI
***************************************************************************************************
*  Parameters  :
*  Description :  Read a private .INI file
*                 Returns the .INI entry 'cEntry' from section 'cSection' or blank if not found
*
*  ? ReadPini("ODBC 32 bit Drivers", ;
*	           "Microsoft Visual FoxPro Driver (32 bit)", ;
*	           "ODBCINST.INI")
***************************************************************************************************
*
Function ReadpIni( cSection, cEntry, cINIFile )

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

Endfunc

***************************************************************************************************
*  FuncTion : RitepINI
***************************************************************************************************
*  Parameters  :
*  Description :  Write an entry in a private .INI file
*                 returns .T. if successful, .F. if not
*
***************************************************************************************************
*

Function RiteINI( cSection As String , cEntry As String , cValue As String , cINIFile As String ) As Logical
   * Parameters cSection, cEntry, cValue, cINIFile
   Local nRetVal As Number

   Declare Integer WritePrivateProfileString In WIN32API ;
      STRING cSection, ;
      STRING cEntry, ;
      STRING cValue, ;
      STRING cINIFile

   nRetVal = WritePrivateProfileString(cSection, cEntry, cValue, cINIFile)

   Return nRetVal=1

Endfunc
