select *,count(codent) as vacias from guardia where (isnul(val_observaciones) or upper(val_observaciones)="VER ORDEN") group by idusuario into cursor vacias
select *,count(codent) as datos from guardia where !(isnul(val_observaciones) or upper(val_observaciones)="VER ORDEN") group by idusuario into cursor condatos
select * from vacias,condatos where vacias.idusuario =condatos.idusuario into cursor control
copy to control type xls
