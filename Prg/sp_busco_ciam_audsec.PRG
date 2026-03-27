*
* Busqueda de cambios de estados de las auditorias de internacion
*
Lparameters midaud

If vartype(midaud)#'N'
	midaud = 0
Endif

mret = sqlexec(mcon1,"select TCS_fecha,SEC_descripsec,TCS_usuario"+;
	" from TabCiamSector"+;
	" left join SECTORES on SEC_codsector = TCS_idsector"+;
	" where TCS_idaudita=?midaud","mwkDetSec")

If mret < 0
	Messagebox("EN CONSULTA DE SECTORES PARA LA"+chr(10)+;
		"AUDITORIA SELECCIONADA",16,"ERROR")
Endif
