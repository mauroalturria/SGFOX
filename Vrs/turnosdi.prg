
SELECT int(hhmmtur/100) as hora,turnoid.*  FROM medpresta,turnoid WHERE medpresta.codmed = turnoid.codmed ;
AND medpresta.diasem = turnoid.diasem AND medpresta.hhmmdes <= turnoid.hhmmtur ;
AND medpresta.hhmmhas>=turnoid.hhmmtur AND medpresta.fecvigend <= turnoid.fechatur ;
AND medpresta.fecvigenh>= turnoid.fechatur ;
ORDER BY turnoid.id,turnoid.codmed,turnoid.diasem,turnoid.hhmmtur GROUP BY turnoid.id  INTO CURSOR controla


SELECT * FROM controla GROUP BY id_b INTO CURSOR libres ORDER BY pre_especialidad,fechatur,nombre 
COPY TO libreas TYPE xl5



SELECT COUNT(diasem_a) as cuantos,*  FROM controla GROUP BY codmed_a,diasem_a,hhmmdes,pre_codprest  INTO CURSOR  rank
SELECT * FROM rank ORDER BY codmed_a,diasem_a,hhmmdes,cuantos INTO CURSOR contra

SELECT * FROM controla GROUP BY codmed,fechatur,hhmmtur HAVING COUNT(id)>1 INTO CURSOR dobles

SELECT * FROM controla WHERE dtos(fechatur)+TRANSFORM(codmed,"@L 9999")+TRANSFORM(hhmmtur,"@L 9999") ;
in (SELECT DTOS(fechatur)+TRANSFORM(codmed,"@L 9999")+TRANSFORM(hhmmtur,"@L 9999") FROM dobles) ;
order BY codmed,fechatur,hhmmtur INTO CURSOR doblesdobles
SELECT * FROM turnoid WHERE id NOT in (SELECT id FROM controla) INTO CURSOR saco
select count(id),sum(iif(afiliado<2,1,0)) as libres,* from controla group by fechatur, codmed,hora into cursor turxhora


SELECT  B_TURNO.*  FROM B_medpresta,B_TURNO WHERE B_medpresta.codmed = B_TURNO.codmed ;
AND B_medpresta.diasem = B_TURNO.diasem AND B_medpresta.hhmmdes <= B_TURNO.hhmmtur ;
AND B_medpresta.hhmmhas>=B_TURNO.hhmmtur AND B_medpresta.fecvigend <= B_TURNO.fechatur ;
AND B_medpresta.fecvigenh>= B_TURNO.fechatur ;
ORDER BY B_TURNO.id,B_TURNO.codmed,B_TURNO.diasem,B_TURNO.hhmmtur GROUP BY B_TURNO.id  INTO CURSOR controla

 UPDATE b_turno SET tipoturno=0 WHERE id in (select id from controla)
 
 SELECT  bajas.*  FROM bajas,turnoid WHERE bajas.codmed = turnoid.codmed ;
AND bajas.diasem = turnoid.diasem AND bajas.hhmmdes <= turnoid.hhmmtur ;
AND bajas.hhmmhas> turnoid.hhmmtur AND bajas.fecvigend <= turnoid.fechatur   ;
AND bajas.fecvigenh>= turnoid.fechatur AND bajas.fecvigenh>CTOD("16/12/2021") AND turnoid.fechatur >=DATE();
ORDER BY  bajas.codmed,bajas.diasem,bajas.hhmmdes GROUP BY bajas.id  INTO CURSOR nosaco

SELECT * FROM turnois


SELECT  turnoid.*  FROM medpresta,turnoid WHERE medpresta.codmed = turnoid.codmed ;
AND medpresta.diasem = turnoid.diasem AND medpresta.hhmmdes <= turnoid.hhmmtur ;
AND medpresta.hhmmhas>turnoid.hhmmtur AND medpresta.fecvigend <= turnoid.fechatur ;
AND medpresta.fecvigenh>= turnoid.fechatur ;
ORDER BY turnoid.id,turnoid.codmed,turnoid.diasem,turnoid.hhmmtur GROUP BY turnoid.id  INTO CURSOR controla
