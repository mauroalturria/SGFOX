use Turnos_11_01 in 0 exclusive alias turnos
set step on
mifecha = ctod("11/01/2013")
select turnos
scan
	mihc = turnos.hclinica
	requery('turnos_tel')
	select turnos
	wait windows transform(recno()) nowait
	if reccount('turnos_tel')= 0
		requery('turnos_telc')
		select turnos
		if reccount('turnos_telc')= 0
			replace estado with 'NOAN'
		else
			replace estado with iif(turnos_telc.coDcancela =5,"CMAS",;
				iif(turnos_telc.codcancela =2,"PACTE",;
				iif(turnos_telc.codcancela =6,"3AUS",;
				iif(turnos_telc.codcancela =36,"A1T",;
				iif(turnos_telc.codcancela =27,"CAM",;
				iif(turnos_telc.codcancela =30,"CxO",;
				iif(turnos_telc.codcancela =42,"TMC","OTRO")))))))
		endif

	else
	select turnos
		replace estado with iif(turnos_tel.confirmado=1,"PRES","AUS")
	endif
endscan
copy to turno1101 type xl5
use in turnos
