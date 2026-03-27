select * from vista2 where inlist(tlo_estado,16,18)  order by tlo_admision, tlo_fecestado into cursor trabajo
select *, count(tlo_estado) as cuantos from trabajo group by tlo_admision, tlo_estado having count(tlo_estado)>1 into dobles
select *, count(tlo_estado) as cuantos from trabajo group by tlo_admision, tlo_estado having count(tlo_estado)>1 into cursor
select *, count(tlo_estado) as cuantos from trabajo group by tlo_admision, tlo_estado having count(tlo_estado)>1 into cursor dobles
BROWSE LAST
select * from vista2 where tlo_admision = "332153-1"
SELECT 2
BROWSE LAST
select * from vista2 where inlist(tlo_estado,16,14)  order by tlo_admision, tlo_fecestado into cursor trabajo
select *, count(tlo_estado) as cuantos from trabajo group by tlo_admision, tlo_estado having count(tlo_estado)>1 into cursor dobles
BROWSE LAST
select * from trabajo where tlo_admision in (select tlo_admision from dobles) into cursor analisis
select * from trabajo where tlo_admision in (select tlo_admision from dobles) order by tlo_admision, tlo_fecestado into cursor analisis
BROWSE LAST
copy to analisis type xl5
select * from trabajo group by tlo_admision into cursor ulti
browse
order by tlo_admision, tlo_fecestado into cursor analisis
select * from trabajo where tlo_admision in (select tlo_admision from dobles) ;
order by tlo_admision, tlo_fecestado into cursor analisis
select * from trabajo where tlo_admision in (select tlo_admision from dobles) and tlo_admision in (select tlo_admision from ulti where tlo_estado = 14 ) ;
order by tlo_admision, tlo_fecestado into cursor analisis
copy to analisis type xl5
