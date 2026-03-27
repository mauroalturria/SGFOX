parameter mfecha1, mfecha2
lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

if mfecha1 <= mfechalimite
	historico