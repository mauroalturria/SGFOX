Lparameters lnabm, lnRegistrac, lnUsuario, ltFecha,lnestado

Do Case 

	Case lnabm = 1 && registracio
		mret= sqlexec(mcon1," insert into TabHcUsuario " + ;
			"(hcu_Usuario, hcu_Registrac, hcu_Fecha, hcu_estado) " + ;
			"values "+ ;
			"(?lnUsuario, ?lnRegistrac, ?ltFecha,?lnestado)" )
		
EndCase

If mret < 0
	Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Cancel
Endif
