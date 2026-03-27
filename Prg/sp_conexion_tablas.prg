****
**** Armo la Conexion a la base
****
lparameters xconex
mcon1 = 0
nalerta = 0
if type ('xconex')="C"
	mcon1 = sqlconnect(xconex,'_system','sys')
else
	do sp_conexion
endif
select 0
