**********************************************************************
* Program....: SP_BUSCO_ESTADOCOVID19.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk 
* Date.......: 05 October 2020, 09:43:35
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A. 
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 05 October 2020 / 09:43:35
* Purpose....:   Consulta por registracion el estado de contagio del paciente (COVID19)
********************************************************************** 
*
Parameters tnNroRegistracion

LOCAL llok 

PRIVATE nNroRegistracion

m.nNroRegistracion  = tnNroRegistracion

lcCMDSQL = ''
llok = .t.

* SET STEP ON

*!*	TEXT TO lcCMDSQL TEXTMERGE NOSHOW PRETEXT 7
*!*			  SELECT Max(RC_Estado) as EstadoActualCovid,
*!*	           Max(Case when RC_Estado = 3 then 1
*!*	                    when RCL_Estado = 3 then 1
*!*	               else 0 end) as FueCovidPositivo
*!*			   FROM ZabRegContagio rc
*!*			        Left Join ZabRegCtgLog on RCL_idregctg = rc.id
*!*			   WHERE rc.id in
*!*			       ( SELECT Max(Id) FROM ZabRegContagio c2
*!*			           WHERE RC_NroRegistracio = ?m.nNroRegistracion and RC_FechaPasiva = '1900-01-01')
*!*	ENDTEXT

mret = sqlexec(mcon1,"SELECT Max(RC_Estado) as EstadoActualCovid, " +;
           "Max(Case when RC_Estado = 3 then 1 " +;
                    "when RCL_Estado = 3 then 1 " +;
                    "else 0 end) as FueCovidPositivo " +;
		   "FROM ZabRegContagio rc " +;
		   "Left Join ZabRegCtgLog on RCL_idregctg = rc.id " +;
		   "WHERE rc.id in ( SELECT Max(Id) FROM ZabRegContagio c2 WHERE RC_NroRegistracio = ?m.nNroRegistracion and RC_FechaPasiva = '1900-01-01')",'mwkZabRegContagioCOVID19' )


If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE PROTOCOLOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	llOk = .f.
Endi

*-- Ejecutamos la consulta al motor
*!*	If SQLExec( mCon1 , lcCMDSQL, 'mwkZabRegContagioCOVID19') = 1
*!*	   * Browse Title "Cursor mwkZabRegContagioCOVID19 " Nowait
*!*	   llok = .T.
*!*	Else
*!*	   =Messagebox('Problemas al procesar la consulta Registro Contagio - Error: Avise a Sistemas ', 48, 'Error ')
*!*	   *-- Fallo la consulta al motor
*!*	   llok = .F.
*!*	Endif

RETURN llOk 


