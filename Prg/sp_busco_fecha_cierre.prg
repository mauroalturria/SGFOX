***
*** Busca fecha cierre
***
parameters fechacierre
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb  id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios1'
	cancel
endif
go bottom in mwkctrlfecha
fechacierre = mwkctrlfecha.fechacierre
use in mwkctrlfecha
