select * from fich_barra where id not in (select ide from fich_e_s)
copy to sinfich
BROWSE LAST
USE c:\desaguemes\sinfich.dbf IN 0 SHARED
SELECT 20
BROWSE LAST
select * from sinfich,turnoid where sinfich.codmed= turnoid.codmed and sinfich.fecha = turnoid.fechatur;
and between(horatur,horadesde,horahasta) into cursor cosa
BROWSE LAST
select * from sinfich left join turnoid on( sinfich.codmed= turnoid.codmed and sinfich.fecha = turnoid.fechatur;
and between(horatur,horadesde,horahasta)) into cursor cosa
BROWSE LAST
select * from cosa where isnull(horatur)
copy to control type xl5
select * from turnoid where codmed = 1962
