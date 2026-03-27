use in select('ambula')
USE "c:\mis documentos\estadisticas\ambxent1212.dbf" IN 0 EXCLUSIVE alias ambula
select * from ambula left join tipoent on entidad = ent_codent into cursor datos
select *,sum(total) as suma  from datos group by tipo into cursor datosg
select datosg
copy to ambxent1212g type xls
