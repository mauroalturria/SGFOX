SELECT * FROM turnoid,franjadrive WHERE turnoid.codmed = franjadrive.codmed AND turnoid.diasem = franjadrive.diasem;
AND turnoid.hhmmtur>= franjadrive.hhmmdes AND turnoid.hhmmtur< franjadrive.hhmmhas
ON ERROR
SELECT * FROM turnoid,franjadrive WHERE turnoid.codmed = franjadrive.codmed AND turnoid.diasem = franjadrive.diasem;
AND turnoid.hhmmtur>= franjadrive.hhmmdes AND turnoid.hhmmtur< franjadrive.hhmmhas
SELECT * FROM turnoid,franjadrive WHERE turnoid.codmed = franjadrive.codmed AND turnoid.diasem = franjadrive.diasem;
AND turnoid.hhmmtur>= franjadrive.hhmmdes AND turnoid.hhmmtur< franjadrive.hhmmhas INTO cursor controla
BROWSE LAST
SELECT 9
BROWSE LAST
SELECT * FROM controla WHERE tipoturno_a<>tipoturno_b INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM controla WHERE tipoturno_a=tipoturno_b INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM controla WHERE tipoturno_a<>tipoturno_b INTO CURSOR cambiar
SELECT * FROM controla WHERE tipoturno_a=tipoturno_b ORDER BY tipoturno_b INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM controla WHERE tipoturno_a<>tipoturno_b ORDER BY tipoturno_b INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM cambiar WHERE tipoturno_b = 5 INTO CURSOR falta
SELECT 78
SELECT 84
UPDATE turnoid SET tipoturno = 5 WHERE id in (select id_a from falta)
REQUERY('turnoid')
SELECT * FROM turnoid,franjadrive WHERE turnoid.codmed = franjadrive.codmed AND turnoid.diasem = franjadrive.diasem;
AND turnoid.hhmmtur>= franjadrive.hhmmdes AND turnoid.hhmmtur< franjadrive.hhmmhas INTO cursor controla
SELECT * FROM controla WHERE tipoturno_a<>tipoturno_b ORDER BY tipoturno_b INTO CURSOR cambiar
BROWSE LAST
SELECT * FROM cambiar WHERE tipoturno_b = 7 INTO CURSOR falta
UPDATE turnoid SET tipoturno = 7 WHERE id in (select id_a from falta)
REQUERY('turnoid')
SELECT * FROM turnoid,franjadrive WHERE turnoid.codmed = franjadrive.codmed AND turnoid.diasem = franjadrive.diasem;
AND turnoid.hhmmtur>= franjadrive.hhmmdes AND turnoid.hhmmtur< franjadrive.hhmmhas INTO cursor controla
SELECT * FROM controla WHERE tipoturno_a<>tipoturno_b ORDER BY tipoturno_b INTO CURSOR cambiar
SELECT 1