****
** busco hora de ultima dieta
****
lparameters xvfec,xvtipo
mret = sqlexec(mcon1, "select * from Tabnutfhora  "+;
	" where TNFH_Tipo = ?xvtipo and TNFH_fecha = ?xvfec "+;
	" order by id desc ","mwknuthora")
If mret <= 0
	Messagebox("ERROR DE LECTURA. Hora ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
