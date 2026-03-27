SELECT * FROM TURNOID group by fechatur,afiliado,confirmado into cursor predobles
SELECT * FROM predobles group by fechatur,afiliado  having count(diasem)>1 into cursor dobles
SELECT TURNOID.* FROM TURNOID,dobles where  ;
TURNOID.fechatur = dobles.fechatur and TURNOID.afiliado = dobles.afiliado ;
group by turnoid.id into cursor cosa
copy to todos type xl5

