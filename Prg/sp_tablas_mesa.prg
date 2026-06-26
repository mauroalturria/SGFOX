

If mconsql > 0
	mret = SQLExec(mconsql,"Select motivotext, idmotivo "+;
		"from sqluser.motivos order by motivotext","mwkmotivos1")

Else
	mret = SQLExec(mcon1,"Select motivotext, idmotivo "+;
		"from motivos order by motivotext","mwkmotivos1")
Endif

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
ENDIF

Do sp_secagrup

If mconsql > 0
	mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
		",SEC_secquirur,SEC_internacion from sqluser.sectores " + ;
		"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")

Else
	mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
		",SEC_secquirur,SEC_internacion from sectores " + ;
		"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
Endif
