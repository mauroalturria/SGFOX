select count(id) as cuantos,* from fichadas_amb group by tai_fecha,tai_codmed,tai_idfranja into cursor control
select *,transf(dtos(tai_fecha))+transf(tai_codmed,"999999")as clave  from control where cuantos>1 into cursor dobles
select * from fichadas_amb where transf(dtos(tai_fecha))+transf(tai_codmed,"999999") in (select clave from dobles );
order by tai_fecha,codmed,tai_hhmming into cursor controlss
use dbf('controlss') again in 0 alias arreglo


select arreglo
set step on
scan
	mcons = tai_consultorio
	mfranja = tai_idfranja
	ming = tai_hhmming
	megr = tai_hhmmegr
	mid = id
	if tai_codmed = 0
		update fichadas_amb set tai_codmed = 0 where id = mid
	else
*!*			
*!*			update fichadas_amb set tai_consultorio=mcons, tai_idfranja = mfranja,  tai_hhmming = ming ,;
*!*				tai_hhmmegr =megr 	where id = mid
	endif		
	select arreglo
endscan
