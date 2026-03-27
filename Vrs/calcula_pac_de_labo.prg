select distinct h_clin_,nombre,vale,fec_sol_,ent,nom_entida,hora,operador  from cons0901 where inlist(operador,55472,54756,54814) into cursor cosa
BROWSE LAST
select distinct h_clin_,nombre,fec_sol_,ent,nom_entida,operador  from cons0901 where inlist(operador,55472,54756,54814) into cursor cosa
select count(h_clin_) as pacientes,fec_sol_,operador  from cons0901 group by fec_sol_,operador into cursor pac09
BROWSE LAST
select pac09.*,idusuario from pac09,tabusuario where operador = codigovax into cursor pac_usu_09
BROWSE LAST
select count(h_clin_) as pacientes,fec_sol_,operador  from cosa group by fec_sol_,operador into cursor pac09
select pac09.*,idusuario from pac09,tabusuario where operador = codigovax into cursor pac_usu_09
BROWSE LAST
copy to pac_09 type xl5
USE c:\desaguemes\cons1001.dbf IN 0 EXCLUSIVE
SELECT 3
SELECT 8
SELECT 3
BROWSE LAST
select distinct h_clin_,fec_sol_,ent,nom_entida,operador  from cons1001 where inlist(operador,55472,54756,54814) into cursor cosa
select count(h_clin_) as pacientes,fec_sol_,operador  from cosa group by fec_sol_,operador into cursor pac10
select pac10.*,idusuario from pac10,tabusuario where operador = codigovax into cursor pac_usu_10
BROWSE LAST
copy to pac_10 type xl5
