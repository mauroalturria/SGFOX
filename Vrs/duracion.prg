CREATE VIEW REMOTE
SELECT medpresta.*,INT(VAL(SUBSTR(duracion,4,2))) as dura ,view6.pre_duracion as durant FROM medpresta,view6 WHERE medpresta.PRE_codprest= view6.PRE_codprest INTO CURSOR cosa
SELECT medpresta.*,INT(VAL(SUBSTR(duracion,4,2))) as dura ,view6.pre_duracion as durant ;
FROM medpresta,view6 WHERE medpresta.PRE_codprest= view6.PRE_codprest INTO CURSOR cosa
BROWSE LAST
SELECT * FROM cosa WHERE durant<>pre_duracion
SELECT * FROM cosa WHERE durant<>pre_duracion GROUP BY PRE_codprest
DO c:\desaguemes\prg\0seteos_quirof.prg
MODIFY VIEW tabusuariopp
UPDATE tabusuariopp SET diasaviso=CTOD("01/01/2100"),fecexpira =CTOD("01/01/2100")
SELECT *,pre_duracion-durant as dif FROM cosa WHERE durant<>pre_duracion INTO CURSOR cambios
BROWSE LAST
SELECT * FROM cambios WHERE dif>0 ORDER BY dif desc
SELECT * FROM cambios WHERE dif>0 ORDER BY dif DESC GROUP BY PRE_codprest
SELECT * FROM cambios WHERE dif>0 ORDER BY dif DESC,pre_duracion desc GROUP BY PRE_codprest
SELECT * FROM cosa WHERE dura<pre_duracion INTO CURSOR actualizar 
SELECT * FROM cosa WHERE dura>=pre_duracion
SELECT * FROM cosa WHERE dura<pre_duracion GROUP BY PRE_codprest
SELECT *,"00:"+TRANSFORM(pre_duracion,"@L 999")+":00" as newdura FROM cosa;
 WHERE dura<pre_duracion ORDER BY pre_duracion DESC INTO CURSOR actualizar
 
SELECT * FROM medpresta where ;
TRANSFORM(codmed,'@L 9999')+TRANSFORM(diasem)+TRANSFORM(hhmmdes,'@L 9999')+DTOS(fecvigenh);
in (SELECT TRANSFORM(codmed,'@L 9999')+TRANSFORM(diasem)+TRANSFORM(hhmmdes,'@L 9999')+DTOS(fecvigenh) FROM algodoble);
order BY codmed,diasem,hhmmdes,fecvigenh,duracion,pre_duracion INTO CURSOR cambiardura

SELECT * FROM medpresta GROUP BY codmed,diasem,hhmmdes,fecvigenh,duracion order BY codmed,diasem,hhmmdes,fecvigenh,duracion,pre_duracion INTO CURSOR algo
SELECT * FROM algo GROUP BY codmed,diasem,hhmmdes,fecvigenh HAVING COUNT(id)>1 INTO CURSOR algodoble
SELECT * FROM medpresta where ;
TRANSFORM(codmed,'@L 9999')+TRANSFORM(diasem)+TRANSFORM(hhmmdes,'@L 9999')+DTOS(fecvigenh);
in (SELECT TRANSFORM(codmed,'@L 9999')+TRANSFORM(diasem)+TRANSFORM(hhmmdes,'@L 9999')+DTOS(fecvigenh) FROM algodoble);
order BY codmed,diasem,hhmmdes,fecvigenh,duracion,pre_duracion INTO CURSOR cambiardura
SELECT cambiardura.*,INT(VAL(SUBSTR(duracion,4,2))) as dura ,view6.pre_duracion as durant ;
FROM cambiardura,view6 WHERE cambiardura.PRE_codprest= view6.PRE_codprest INTO CURSOR cosacambbi
COPY TO mezcla TYPE xl5
SELECT 29
BROWSE LAST
UPDATE medpresta SET duracion = "00:20:00" WHERE id in (SELECT id from cosacambbi)

UPDATE medpresta SET duracion = "00:"+TRANSFORM(pre_duracion,"@L 99")+":00" WHERE id in (SELECT id from actualizar)
SELECT medpresta.*,INT(VAL(SUBSTR(duracion,4,2))) as dura ,view6.pre_duracion as durant ;