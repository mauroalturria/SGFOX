***
***  busqueda de las entidades
***
parameter mcodent

mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno, ENT_fecpas from entidades " + ;
					"where ENT_codent = ?mcodent","mwkbentid")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	