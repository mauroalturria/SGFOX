REQUERY('tabregctg')
SELECT  * FROM tabregctg GROUP by rc_nroregistracio HAVING COUNT(id)>1 INTO CURSOR dobles
SELECT  * FROM tabregctg WHERE  rc_nroregistracio in (SELECT rc_nroregistracio  FROM dobles) INTO CURSOR todos
SELECT * FROM todos GROUP BY rc_nroregistracio ,rc_estado INTO CURSOR cosa
SELECT * FROM cosa GROUP BY rc_nroregistracio HAVING COUNT(id)>1 INTO CURSOR controlo
SELECT tabregctg
LOCATE FOR rc_nroregistracio = controlo.rc_nroregistracio 