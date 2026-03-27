

SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas> = franjadrive.hhmmdes
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas> = franjadrive.hhmmdes INTO CURSOR cambio

SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas
MODIFY VIEW medprestabk
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas> = franjadrive.hhmmdes INTO CURSOR cambio
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas> = franjadrive.hhmmdes
SELECT * FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes INTO CURSOR cambio
BROWSE LAST
?VARTYPE(duracion)
MODIFY COMMAND c:\desaguemes\prg\prg_hm_min.prg AS 1252
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes iNTO CURSOR cambio
BROWSE LAST
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes WHERE dura<16 iNTO CURSOR cambio
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes WHERE  VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2))<16 iNTO CURSOR cambio
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes < franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes iNTO CURSOR cambio
SELECT * FROM cambio WHERE dura<16 INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM cambio WHERE dura<16 GROUP BY id_a INTO CURSOR cambiar
BROWSE LAST
SELECT DISTINCT CODMED_A,NOMBRE FROM CAMBIAR
COPY TO MEDICAM TYPE XL5
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND medprestabk.hhmmdes <= franjadrive.hhmmhas ;
AND medprestabk.hhmmhas>= franjadrive.hhmmdes iNTO CURSOR cambio
SELECT * FROM cambio WHERE dura<16 GROUP BY id_a INTO CURSOR cambiar
SELECT DISTINCT CODMED_A,NOMBRE FROM CAMBIAR
SELECT DISTINCT CODMED_A,NOMBRE ORDER BY NOMBRE FROM CAMBIAR
USE tipoturno AGAIN IN 0
SELECT Tipoturno
BROWSE LAST
MODIFY VIEW turnoid
MODIFY VIEW turnoent
MODIFY VIEW turnobristoñ
DELETE VIEW turnobristoñ
MODIFY VIEW turnoidp
MODIFY VIEW turnoidrank
SELECT  turnoidrank
SELECT * FROM  turnoidrank ORDER BY nombre,diasem GROUP BY BY nombre,diasem
SELECT * FROM  turnoidrank ORDER BY nombre,diasem GROUP BY nombre,diasem
COPY TO turnoste TYPE xl5
SELECT 2
BROWSE LAST
SELECT * FROM medprestabk WHERE CODMED = 5557
SELECT * FROM medprestabk WHERE LEFT(NOMBRE ,5)= 'PONCE'
SELECT * FROM medprestabk WHERE codesp= 'PEDI'
SELECT * FROM medprestabk WHERE codesp= 'PEDI' GROUP BY codprest
SELECT 4
BROWSE LAST
SELECT * FROM medprestabk,turnoidrank  WHERE medprestabk.codmed = turnoidrank.codmed  AND medprestabk.diasem = turnoidrank.diasem
SELECT * FROM medprestabk,turnoidrank  WHERE medprestabk.codmed = turnoidrank.codmed  AND medprestabk.diasem = turnoidrank.diasem;
order BY duracion
SELECT 6
SELECT 4
BROWSE LAST
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY pre_descriprest
update medprestabk SET cantidad = 1 WHERE AT('EXTERNA',pre_descriprest)>0
update medprestabk SET cantidad = 1 WHERE AT('NIÑO SANO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('NIÑO SANO',pre_descriprest)>0
MODIFY VIEW ctrlunif
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY duracion, pre_descriprest 
SELECT * FROM medprestabk WHERE AT('DISTANC',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('DISTANC',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('DISTANC',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE codesp= 'PSIC' GROUP BY DURACION,codprest
SELECT * FROM medprestabk WHERE INLIST(CODPREST,   42010148,   42010185 )
SELECT * FROM medprestabk WHERE INLIST(CODPREST,   42010148,   42010185 ) ORDER BY duracion, pre_descriprest
MODIFY VIEW medprestabk
SELECT * FROM medprestabk WHERE AT('ART',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE CODPREST =    42030729
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = 1  WHERE AT('INTERDISCI',pre_descriprest)>0
update medprestabk SET cantidad = null  WHERE AT('INTERDISCI',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET cantidad = null  WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET DURACION ='01:00:00' WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
update medprestabk SET DURACION ='01:00:00' WHERE AT('INTERDISCI',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('INTERDISCI',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('NIÑO SANO',pre_descriprest)>0
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem GROUP BY medprestabk.ID iNTO CURSOR cambio
BROWSE LAST
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestabk.ID iNTO CURSOR cambio
BROWSE LAST
SELECT * FROM CAMBIO ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <=  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY DURA
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b ;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a WHERE dura<16
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a   dura<16
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a
SELECT * FROM medprestabk WHERE id in (SELECT id_a 
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
SELECT * FROM medprestabk WHERE id in (SELECT id_a FROM cambiadur)
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY duracion, pre_descriprest
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY  pre_descriprest
update medprestabk SET cantidad = null  WHERE AT('EXTERNA',pre_descriprest)>0
update medprestabk SET cantidad = 1  WHERE CODPREST =    42030455
SELECT * FROM medprestabk WHERE AT('EXTERNA',pre_descriprest)>0 ORDER BY  pre_descriprest
SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestabk.ID iNTO CURSOR cambio
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
SELECT * FROM medprestabk WHERE id in (SELECT id_a FROM cambiadur)
COPY TO duracionanterior
COPY TO duracionanterior TYPE xl5
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur)
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
MODIFY VIEW medpresta
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND codmed = 843 ORDER BY codesp,nombre
MODIFY VIEW turnoid
MODIFY VIEW turnoidrank
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND LEFT(codesp,2)="EC" ORDER BY codesp,nombre
SELECT 2
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND codserv<>7900;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,2200,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,2200,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
BROWSE LAST
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
MODIFY VIEW gua_pac
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
COPY TO cambiadura
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) AND codserv = 7300 ORDER BY codesp,nombre
SELECT * FROM medprestabk  WHERE  codserv = 7300 ORDER BY codesp,nombre
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a GROUP BY codserv INTO CURSOR cambiadur
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16 AND !INLIST(codserv,7900,7300);
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a  INTO CURSOR cambiadur
SELECT * FROM medprestabk  WHERE id in (SELECT id_a FROM cambiadur) ORDER BY codesp,nombre
SELECT 13
COPY TO cambiadur
COPY TO duracionanterior
COPY TO duracionanterior TYPE xl5
UPDATE  medprestabk  SET duracion = '00:30:00' ,cantidad = 1 WHERE id in (SELECT id_a FROM cambiadur) 
USE franjadrive AGAIN IN 0 ALIAS Franjadrive_a
SELECT Franjadrive_a
BROWSE LAST
SELECT 13
CREATE VIEW REMOTE
MODIFY VIEW medprestabk
SELECT 13
SELECT 1
SELECT * FROM franjadrive WHERE codmed = ?codmed AND diasem =?diasem
SELECT * FROM franjadrive WHERE codmed = view18.codmed AND diasem =view18.diasem
SELECT * FROM franjadrive WHERE codmed = 256
SELECT * FROM franjadrive WHERE codmed = 135
SELECT * FROM franjadrive WHERE codmed = 208
SELECT * FROM franjadrive WHERE codmed = 100
MODIFY VIEW medprestapp
MODIFY COMMAND c:\desaguemes\vrs\bloqfran.prg AS 1252
MODIFY COMMAND c:\desaguemes\vrs\desbloq.prg AS 1252
update medprestapp SET DURACION ='01:00:00' WHERE AT('NIÑO SANO',pre_descriprest)>0
update medprestapp SET DURACION ='01:00:00' WHERE AT('CONSULTA CONTROL DEL RECIEN NACIDO',pre_descriprest)>0
update medprestapp SET DURACION ='00:15:00' WHERE codprest = 42030729
update medprestapp SET DURACION ='00:15:00' WHERE AT('DISTANC',pre_descriprest)>0

SELECT VAL(LEFT(duracion,2)+SUBSTR(duracion,4,2)) as dura,* FROM medprestabk,franjadrive WHERE medprestabk.codmed = franjadrive.codmed ;
AND medprestabk.diasem = franjadrive.diasem AND ISNULL(CANTIDAD) GROUP BY medprestabk.ID iNTO CURSOR cambio
SELECT * FROM CAMBIO WHERE hhmmdes_a <  hhmmhas_b AND dura<16;
AND hhmmhas_a>= hhmmdes_b ORDER BY codmed_a,diasem_a,hhmmdes_a INTO CURSOR cambiadur
SELECT * FROM medprestabk WHERE id in (SELECT id_a FROM cambiadur)
UPDATE  medprestabk  SET duracion = '00:30:00' ,cantidad = 1 WHERE id in (SELECT id_a FROM cambiadur) 


SELECT * FROM medprestabk,turnos_vacunas WHERE medprestabk.codmed = turnos_vacunas.codmed ;
AND medprestabk.diasem = turnos_vacunas.diasem AND medprestabk.hhmmdes <= turnos_vacunas.hhmmtur ;
AND medprestabk.hhmmhas>= turnos_vacunas.hhmmtur AND medprestabk.fecvigend <= turnos_vacunas.fechatur ;
AND medprestabk.fecvigenh>= turnos_vacunas.fechatur ORDER BY turnos_vacunas.id INTO CURSOR cambio

SELECT * FROM cambio WHERE NVL(codprest_b,0)=0 AND codprest_a=20024 INTO CURSOR dosis1
SELECT * FROM cambio WHERE NVL(codprest_b,0)=0 AND codprest_a=20025 INTO CURSOR dosis2
SELECT * FROM dosis1,dosis2 WHERE dosis1.id_b = dosis2.id_b
UPDATE turnos_vacunas SET codprest = 20024 WHERE id in (select id_b from dosis1)
UPDATE turnos_vacunas SET codprest = 20025 WHERE id in (select id_b from dosis2)
SELECT * FROM turnos_vacunas  WHERE NVL(codprest,0)=0