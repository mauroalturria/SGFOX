****
**  Busco el total de camas por sector de un rango de fechas
***

parameters mfecdes, mfechas

mret = sqlexec(mcon1, "SELECT Cantidad, CantidadFact, Codentidad, Fecha, Sector,"+;
	" ENT_descrient, SEC_descripsec"+;
	" FROM SQLUser.TabHistPacInt ,Entidades, Sectores"+;
	"  WHERE ENT_codent = Codentidad AND Sector = SEC_codsector" + ;
	" and Fecha >= ?mfecdes and Fecha <= ?mfechas ", "mwktotcama")
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
endif
