Cd "C:\desaguemes"
REQUERY('coseprac')
REQUERY('coseguro')
MODIFY VIEW cosegurobono
REQUERY('cosegurobono')

SELECT   coseprac.Entidad, coseprac.Fecha, coseprac.Prestacion,;
  Coseprac.TipoAtenAmb, coseprac.PRE_descriprest;
 FROM coseprac group BY Entidad,Prestacion,TipoAtenAmb;
 INTO CURSOR ccoseprcticas
 

 SELECT * FROM coseguro GROUP BY plan,entidad,tipoaten,contrato HAVING COUNT(entidad)>1  ;
order BY plan,entidad,tipoaten,contrato INTO CURSOR dobles
 
COPY TO duplicados TYPE xl5
 
SELECT * FROM coseguro GROUP BY plan,entidad,tipoaten   INTO CURSOR coseguros
SELECT ccoseprcticas.*,Descripcion,Cant_Prestaciones,Coseguro,VAL(Plan) as plan FROM ccoseprcticas,coseguros ;
WHERE Coseguros.entidad = ccoseprcticas.entidad AND Coseguros.TipoAten = ccoseprcticas.TipoAtenamb;
order BY ccoseprcticas.entidad ,prestacion into CURSOR coseimp
 

 
SELECT * FROM cosegurobono GROUP BY plan,entidad,tipoaten,contrato HAVING COUNT(entidad)>1  ;
order BY plan,entidad,tipoaten,contrato INTO CURSOR doblesbono
SELECT * FROM cosegurobono GROUP BY plan,entidad,tipoaten HAVING COUNT(entidad)>1  ;
order BY plan,entidad,tipoaten INTO CURSOR doblesbono 

 
SELECT * FROM cosegurobono GROUP BY plan,entidad,tipoaten   INTO CURSOR coseguros
SELECT ccoseprcticas.*,Descripcion,Cant_Prestaciones,importe as coseguro,VAL(Plan) as plan FROM ccoseprcticas,coseguros ;
WHERE Coseguros.entidad = ccoseprcticas.entidad AND Coseguros.TipoAten = ccoseprcticas.TipoAtenamb;
order BY ccoseprcticas.entidad ,prestacion into CURSOR coseimpbono
 
SELECT * FROM coseimpbono UNION ALL SELECT * FROM coseimp INTO CURSOR cosepre
MODIFY VIEW planes
SELECT 57
BROWSE LAST
SELECT * FROM cosepre LEFT JOIN planes ON plan = planes.id INTO CURSOR cosefin
BROWSE LAST
COPY TO coseguros TYPE CSV 

COPY TO coseguros TYPE xl5
GO top
