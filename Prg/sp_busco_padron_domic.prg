*********************************************************************************
* BUSCA PADRON DOMICILIOS
*********************************************************************************
parameter mid


mret = sqlexec(mcon1,"SELECT id,Codigo, Domicilio,FechaDesde, FechaHasta,"+;
	"IdPadCabe, Localidad, Provincia,Telefono "+;
	" FROM Paddomicilio " +;
	" WHERE IdPadCabe = ?mid order by FechaHasta desc ", "mwkbuspadDom")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif

