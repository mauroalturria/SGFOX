BROWSE LAST
select * from tabintscore where at("Screening nutricional MST",eip_evol)>0 and eip_tipoevol = 's' order by id into cursor previo
select * from tabintscore where at("Screening nutricional MST",eip_evol)>0 and eip_tipoevol = 's' into cursor previo
select LEFT(substr(iif(at("APACHE",eip_evol)>0,left(eip_evol,at("Clasificación de severida",eip_evol)-2), eip_evol),107),250) as evol, * from previo group by eip_idevol,eip_fechah into cursor deta
select ttod(eip_fechah) as fecha,LEFT(substr(iif(at("APACHE",eip_evol)>0,left(eip_evol,at("Clasificación de severida",eip_evol)-2), eip_evol),107),250) as evol, * from previo group by eip_idevol,eip_fechah into cursor deta
SELECT 6
BROWSE LAST
copy to detalle type xl5
