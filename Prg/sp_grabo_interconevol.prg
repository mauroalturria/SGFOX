*
* Grabo evolucion pedido de interconsulta
*
Lparameters mestado, mlid, mobserva

musuario = mwkusuario.codigovax
horaact = sp_busco_fecha_serv('DT')
fechaact = ttod(horaact)

mret = sqlexec(mcon1,"insert into TabGuaICEvol"+;
	" (TGIE_estado,TGIE_fechamov,TGIE_idinterc,TGIE_usuario,TGIE_observa)"+;
	" values "+;
	" (?mestado,?horaact,?mlid,?musuario,?mobserva)")

If mret < 0
	Messagebox("EN EL INGRESO DE EVOLUCION, SOLICITUDES DE INTERCONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.



