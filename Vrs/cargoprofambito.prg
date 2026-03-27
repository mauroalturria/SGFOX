select 99 as codambito, id as CodMed,fecaltap as FechaHoraIng, fecpasivap as FechaPasiva,Usuario from vista3 into cursor nuevos
SELECT 27
BROWSE LAST
append from dbf('nuevos')

select * from vista6 where codambito<99 and bloqueo*100+codambito not in (select codmed*100+codambito from vista7 ) into cursor faltan

select distinct * from vista5 group by nombre,matprov,cuil into cursor profPC
use in 0 dbf('profpc') again alias profe

update profe set bloqueo = id
