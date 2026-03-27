***
***   Actualizacion de codigo de reserva
***

parameter ind, mcreserva

mret = sqlexec(mcon1,"update turnos set codreserva = ?mcreserva " + ;
						"where id = ?midturno ")

if mret < 0
	messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif
