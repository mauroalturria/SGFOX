update turnoid SET tipoturno = 9 WHERE MOD(hhmmtur,100)=0  AND codmed = 5295 AND !INLIST(diasem,2,4,6)
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND hhmmtur>=1600  AND codmed = 5295  AND !INLIST(diasem,2,4,6)
SELECT   COUNT(id) as cant,* FROM turnoid  WHERE  tipoturno <> 9 GROUP BY codmed,horatur ORDER BY horatur
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND afiliado<2
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,horatur ORDER BY horatur
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)=0 AND afiliado<2
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,horatur ORDER BY horatur
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND afiliado<2
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,horatur ORDER BY horatur
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)=0 AND afiliado<2
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,horatur ORDER BY horatur
update turnoid SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND afiliado<2
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,horatur ORDER BY horatur
SELECT   COUNT(id) as cant,* FROM turnoid  GROUP BY codmed,diasem,horatur ORDER BY cant,codmed,horatur INTO CURSOR gro
722,920,4764,5295, 5443?
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND codmed = 5295 
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0 AND hhmmtur>=1600  AND codmed = 722  AND  INLIST(diasem,2,4,6)
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)=0 AND hhmmtur<1600  AND codmed = 722  AND  INLIST(diasem,2,4,6)
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)>0  AND codmed = 4764  AND  !INLIST(diasem,2,4,6)
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)=0  AND codmed = 4764  AND  INLIST(diasem,2,4,6)
update turnoidkine SET tipoturno = 9 WHERE  MOD(hhmmtur,100)=0 AND hhmmtur<1600  AND codmed = 722  AND  !INLIST(diasem,2,4,6)
