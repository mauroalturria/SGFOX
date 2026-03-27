CLEAR

SET CENTURY ON 
SET DELETED ON
SET DATE FRENCH


ldf1 = CTOD("01/06/2010") 
ldf2 = CTOD("31/05/2016")

*!*	?ldf1
*!*	?ldf2

mcon1 = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.1.4;DATABASE=CATALOGO;Uid=_SYSTEM;Pwd=SYS")

*!*	?mcon1 

mret = SQLEXEC(mcon1,"Select ID, InformeSoloTexto, NroVale, CodServVale, fechainforme " + ;
	"from informes " + ;
	"where fechainforme between ?ldf1 and ?ldf2 and " + ;
	" estadoinforme <> 5 and tipoarch = 'TXT' and codservvale IN ( 7700, 6300)","mwkinf")
IF mret <= 0
	RETURN .f.
ENDIF 


SELECT mwkinf 
REPLACE InformeSoloTexto WITH LOWER(CHRTRAN(InformeSoloTexto, "áéíóúÁÉÍÓÚ","aeiouAEIOU")) all

SELECT distinct NroVale FROM mwkinf WHERE ("isquemi" $ InformeSoloTexto OR "restriccion" $ InformeSoloTexto OR "caida de señal" $ InformeSoloTexto OR "adc" $ InformeSoloTexto ) AND CodServVale = 6300 INTO CURSOR mwkRM
SELECT distinct NroVale FROM mwkinf WHERE ("isquemi" $ InformeSoloTexto ) AND CodServVale = 7700 INTO CURSOR mwkTC
