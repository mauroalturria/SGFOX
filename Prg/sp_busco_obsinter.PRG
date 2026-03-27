*
* Observaciones de pedidos de interconsulta
*
Lparameters mlidinter

Use in select("mwkobsinter")

mret = sqlexec(mcon1,"select TGIE_fechamov,TGIE_observa,tabusuario.idusuario,tabestados.descrip as lestado"+;
	" from TabGuaICEvol"+;
	" join tabestados on propietario = 2 and tipo = 6 and estado = TGIE_estado"+;
	" join tabusuario on codigovax = TGIE_usuario"+;
	" where TGIE_idinterc = ?mlidinter order by TGIE_fechamov desc","mwkobsinter")

If mret < 0
	Messagebox("EN LA CONSULTA DE OBSERVACIONES P/SOLICITUDES DE INTERCONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.



