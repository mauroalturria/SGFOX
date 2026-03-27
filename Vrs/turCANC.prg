use Turnos_21_12 in 0 exclusive alias turnos
set step on
mifecha = ctod("21/12/2012")
select turnos
scan
mihc = turnos.hclinica
requery('turnos_tel')
	select turnos
	wait windows transform(recno()) nowait
	if reccount('turnos_tel')= 0
		replace estado with 'NOAN'
	else
		replace estado with iif(turnos_tel.coDcancela =5,"CMAS",;
			iif(turnos_tel.codcancela =2,"PACTE",;
			iif(turnos_tel.codcancela =6,"3AUS",;
			iif(turnos_tel.codcancela =36,"A1T",;
			iif(turnos_tel.codcancela =27,"CAM",;
			iif(turnos_tel.codcancela =30,"CxO",;
			iif(turnos_tel.codcancela =42,"TMC","OTRO")))))))
	endif	
endscan
copy to turno2112 type xl5
use in turnos