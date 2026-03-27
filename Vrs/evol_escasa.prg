select * from evolucion where eam_evol#" PACIENTE NO RESPONDE AL LLAMADO " into cursor limpio
select * from limpio where len(eam_evol)>5 into cursor bien
select *,left(eam_evol,10),left(ea_motconsulta,50)  from limpio where len(eam_evol)<5 and protocolo not in (select protocolo from bien) into cursor poco
copy to EvAmb_abril type xl5
do clearall