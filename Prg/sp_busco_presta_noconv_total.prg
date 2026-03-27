*** busqueda de prestaciones no convenidas
mret = SQLExec(mcon1, "select PC_FechaVigDesde, PC_FechaVigHasta, PC_codent, PC_codprest, PC_incluidaAMB,"+;
	" PC_incluidaGUA, PC_incluidaINT from Zabprestconvenio " + ;
	" where PC_incluidaAMB=2 and  PC_FechaVigHasta>= {fn curdate()} and PC_FechaVigDesde<= {fn curdate()}  ", "mwkprestconv")
If mret < 0
	Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

