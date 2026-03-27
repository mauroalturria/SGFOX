lparameters mcodreserv

mret = SQLEXEC(mcon1," SELECT fechacall,descrip,observa as observacall," + ;
	" usuario,codreserva as codreservacall,tabestados.estado 	" + ;
	" from Turnoscall  " + ;
	" left join tabestados ON Turnoscall.estado = tabestados.id " + ;
	" where codreserva = ?mcodreserv " ,"mwkturnoscall")
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

