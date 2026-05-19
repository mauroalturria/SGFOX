
SELECT * FROM coseprac GROUP BY Entidad, Prestacion,TipoAtenAmb INTO CURSOR cosepra


SELECT Descripcion,  Importe as coseguro,Plan, TipoAten, Entidad,;
ENT_descrient, Cant_Prestaciones,FechaHasta, AbreviaEnt FROM cosegurobono ;
UNION ALL SELECT * FROM coseguro INTO CURSOR cosetotal

SELECT * FROM cosetotal,cosepra,planes WHERE cosetotal.TipoAten = cosepra.TipoAtenAmb  AND cosetotal.Entidad = cosepra.Entidad AND ;
 cosetotal.AbreviaEnt  = planes.AbreviaEnt order BY cosetotal.Entidad,planes.id,cosetotal.TipoAten,PRE_descriprest INTO CURSOR coseguros
 
 COPY TO coseguros TYPE sdf