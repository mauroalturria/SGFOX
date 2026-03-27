
SELECT * FROM aprocesar_resp WHERE AT('NUMBER',respuesta)>0 INTO CURSOR err1
BROWSE LAST
SELECT * FROM aprocesar_resp WHERE AT('NUMBER',respuesta)>0 AND AT('156',respuesta)>0 INTO CURSOR err1
SELECT * FROM aprocesar_resp WHERE AT('NUMBER',respuesta)>0   INTO CURSOR err1
SELECT 11
BROWSE LAST
SELECT * FROM err1  WHERE AT('NUMBER>002',respuesta)>0   INTO CURSOR err2
BROWSE LAST
SELECT * FROM err1  WHERE AT('NUMBER>002',respuesta)>0  ORDER BY texto INTO CURSOR err2
SELECT 12
BROWSE LAST
USE c:\desaguemes\cuentas.dbf IN 0 SHARED
SELECT 9
SELECT * FROM err1  WHERE AT('NUMBER>007',respuesta)>0  ORDER BY texto INTO CURSOR err007
BROWSE LAST
SELECT * FROM err1  WHERE AT('NUMBER>007',respuesta)>0 AND usuario = 'INTERFAZ REMITO AMB-GUA' ORDER BY texto INTO CURSOR err007
SELECT 14
BROWSE LAST
SELECT  LEFT(respuesta,8) as epi,* FROM err1  WHERE AT('NUMBER>007',respuesta)>0 AND usuario = 'INTERFAZ REMITO AMB-GUA' ORDER BY texto INTO CURSOR err007
BROWSE LAST
SELECT  right(respuesta,8) as epi,* FROM err1  WHERE AT('NUMBER>007',respuesta)>0 AND usuario = 'INTERFAZ REMITO AMB-GUA' ORDER BY texto INTO CURSOR err007
BROWSE LAST
SELECT  ALLTRIM(right(respuesta,9)) as epi,* FROM err1  WHERE AT('NUMBER>007',respuesta)>0 AND usuario = 'INTERFAZ REMITO AMB-GUA' ORDER BY texto INTO CURSOR err007
BROWSE LAST
SELECT * err007 WHERE epi in (SELECT episodio FROM )
SELECT 9
BROWSE LAST
SELECT * err007 WHERE epi in (SELECT episodio FROM cuentas ) INTO CURSOR repro1
SELECT * FROM err007 WHERE epi in (SELECT episodio FROM cuentas ) INTO CURSOR repro1
BROWSE LAST
SELECT 13
SELECT 16
SELECT 9
SELECT 16
SELECT * FROM aprocesar_resp WHERE AT('NUMBER',respuesta)>0 AND tipoproceso ='SI_PO_0008_Integra_Admision_Out';
  INTO CURSOR admerr
BROWSE LAST
SELECT distinct respuesta FROM admerr
SELECT * FROM admerr GROUP BY respuesta
SELECT * FROM admerr order BY respuesta
SELECT  right(respuesta,8) as epi,* FROM admerr  WHERE AT('NUMBER>156',respuesta)>0  ORDER BY texto INTO CURSOR admerr156
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3),9) as hc,* FROM admerr  WHERE AT('NUMBER>156',respuesta)>0  ORDER BY texto INTO CURSOR admerr156
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,* FROM admerr  WHERE AT('NUMBER>156',respuesta)>0  ORDER BY texto INTO CURSOR admerr156
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as hc,* FROM admerr  WHERE AT('NUMBER>156',respuesta)>0  ORDER BY texto INTO CURSOR admerr156
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,* FROM admerr  WHERE AT('NUMBER>156',respuesta)>0  ORDER BY texto INTO CURSOR admerr156
BROWSE LAST
SELECT * FROM admerr156 WHERE epi in (SELECT episodio FROM cuentas ) INTO CURSOR repro1
BROWSE LAST
MODIFY COMMAND c:\desaguemes\vrs\pasasap.prg AS 1252
MODIFY COMMAND c:\desaguemes\vrs\pasa_ctrl_sap.prg AS 1252
MODIFY COMMAND c:\desaguemes\vrs\sapresp.prg AS 1252
SELECT 18
BROWSE LAST
DO c:\desaguemes\prg\0seteos_calen.prg
SELECT 13
BROWSE LAST
SELECT * FROM err007  WHERE epi in (SELECT epi  FROM repro1 ) INTO CURSOR repro2
BROWSE LAST
SELECT * FROM err007  WHERE epi not in (SELECT epi  FROM repro1 ) INTO CURSOR repro2
SELECT * FROM repro2 WHERE epi in (SELECT episodio  FROM cuentas ) INTO CURSOR repro3
BROWSE LAST
SELECT substr(texto,AT(',',texto,3)+1,9) as vale,* FROM repro2 WHERE epi in (SELECT episodio  FROM cuentas ) INTO CURSOR repro3
BROWSE LAST
SELECT substr(texto,AT(',',texto,4)+1,9) as vale,* FROM repro2 WHERE epi in (SELECT episodio  FROM cuentas ) INTO CURSOR repro3
BROWSE LAST
SELECT substr(texto,AT(',',texto,4)+1,8) as vale,* FROM repro2 WHERE epi in (SELECT episodio  FROM cuentas ) INTO CURSOR repro3
BROWSE LAST
SELECT * FROM repro3 GROUP BY epi,vale INTO CURSOR valesrep
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,* FROM aprocesar_resp  WHERE AT('NUMBER',respuesta)>0    INTO CURSOR admision
BROWSE LAST
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,* FROM aprocesar_resp ;
	 WHERE tipoproceso ='SI_PO_0008_Integra_Admision_Out'   INTO CURSOR admision
	 
SELECT * FROM admision WHERE epi in (SELECT epi FROM valesrep) GROUP BY epi INTO CURSOR reproadm
BROWSE LAST
SELECT * FROM valesrep WHERE epi NOT in (SELECT epi FROM reproadm) GROUP BY epi INTO CURSOR repdddd
BROWSE LAST
SELECT * FROM valesrep WHERE epi NOT in (SELECT epi FROM admision) GROUP BY epi INTO CURSOR repdddd
BROWSE LAST
SELECT * FROM valesrep WHERE epi ='0NO764-D' 
MODIFY VIEW vales_prestac
SELECT 40
BROWSE LAST
SELECT * FROM valesrep WHERE epi   in (SELECT epi FROM reproadm) GROUP BY epi INTO CURSOR reprovale GROUP BY vale 
SELECT * FROM valesrep WHERE epi   in (SELECT epi FROM reproadm) GROUP BY epi,vale INTO CURSOR reprovale
BROWSE LAST
SELECT 8
SELECT substr(texto,AT(',',texto,4)+1,8) as vale,* FROM aprocesar_resp  WHERE usuario = 'INTERFAZ REMITO AMB-GUA'  INTO CURSOR valesall
BROWSE LAST
SELECT * FROM valesall WHERE vale in (SELECT vale FROM reprovale) INTO CURSOR anulo
BROWSE LAST
SELECT 43
BROWSE LAST
LOCATE FOR vale =54798982
SELECT 43
LOCATE FOR vale ='54798982'
BROWSE LAST
SELECT 38
BROWSE LAST
SELECT * FROM ADMISION WHERE EPI='0NR689-D'
SELECT substr(texto,AT(',',texto,4)+1,8) as vale,* FROM aprocesar_resp  WHERE usuario = 'INTERFAZ REMITO AMB-GUA'  INTO CURSOR valesall
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,* FROM aprocesar_resp  WHERE tipoproceso ='SI_PO_0008_Integra_Admision_Out'   INTO CURSOR admision
SELECT 9
BROWSE LAST
LOCATE FOR EPISODIO = '0NR689-D'
SELECT 38
LOCATE FOR EPISODIO = '0MP130-D'
LOCATE FOR EPI = '0MP130-D'
BROWSE LAST
LOCATE FOR EPI = '0MP130-D'
SELECT  substr(texto,AT(',',texto,3)+1,9) as hc,substr(texto,AT(',',texto,4)+1,8) as epi,* FROM aprocesar_resp  WHERE AT('NUMBER>545',respuesta)=0 AND tipoproceso ='SI_PO_0008_Integra_Admision_Out'   INTO CURSOR admision
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 INTO CURSOR admisionerr
SELECT 38
SELECT 42
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0 INTO CURSOR admisionerr
SELECT 42
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0  AND AT('NUMBER>546',respuesta)=0 INTO CURSOR admisionerr
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0  AND AT('NUMBER>546',respuesta)=0 ;
  AND AT('NUMBER>546',respuesta)=0 INTO CURSOR admisionerr
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0  AND AT('NUMBER>546',respuesta)=0 ;
  AND AT('NUMBER>546',respuesta)=0  AND AT('NUMBER>039',respuesta)=0  INTO CURSOR admisionerr
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0  AND AT('NUMBER>546',respuesta)=0 ;
  AND AT('NUMBER>544',respuesta)=0  AND AT('NUMBER>039',respuesta)=0  INTO CURSOR admisionerr
BROWSE LAST
SELECT * FROM admision WHERE AT('NUMBER',respuesta)>0 AND AT('NUMBER>016',respuesta)=0  AND AT('NUMBER>546',respuesta)=0 ;
  AND AT('NUMBER>544',respuesta)=0  AND AT('NUMBER>039',respuesta)=0 AND AT('NUMBER>334',respuesta)=0 ;
   AND AT('NUMBER>543',respuesta)=0  INTO CURSOR admisionerr
BROWSE LAST
SELECT * FROM admisionerr WHERE epi in (SELECT episodio FROM cuentas)
USE
USE c:\desaguemes\cuentav.dbf IN 0 SHARED
SELECT 16
BROWSE LAST
SELECT * FROM admisionerr WHERE epi in (SELECT cuenta FROM cuentav)
SELECT * FROM cuentav GROUP BY epi
SELECT * FROM cuentav GROUP BY cuenta
SELECT * FROM admision  WHERE epi in (SELECT cuenta FROM cuentav)
SELECT * FROM admisionerr WHERE epi in (SELECT episodio FROM cuentas) INTO CURSOR  reproadm1
SELECT substr(texto,AT(',',texto,4)+1,8) as vale,* FROM aprocesar_resp  WHERE usuario = 'INTERFAZ REMITO AMB-GUA'  INTO CURSOR valesall
BROWSE LAST
SELECT * FROM cuenta WHERE cuenta in (SELECT epi FROM admisiones)
SELECT * FROM cuenta WHERE cuentav in (SELECT epi FROM admisiones) INTO CURSOR admivs
SELECT * FROM cuentav WHERE cuenta  in (SELECT epi FROM admisiones) INTO CURSOR admivs
SELECT * FROM cuentav WHERE cuenta  in (SELECT epi FROM admision) INTO CURSOR admivs
SELECT 49
BROWSE LAST
SELECT * FROM valesall WHERE vale in (SELECT vale FROM admivs) INTO CURSOR reproval
SELECT cuenta,TRANSFORM(vale) as val  FROM cuentav WHERE cuenta  in (SELECT epi FROM admision) INTO CURSOR admivs
BROWSE LAST
SELECT * FROM valesall WHERE vale in (SELECT vale FROM admivs) INTO CURSOR reproval
SELECT * FROM valesall WHERE vale in (SELECT val FROM admivs) INTO CURSOR reproval
BROWSE LAST