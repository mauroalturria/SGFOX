parameters mprotocolo

mret = sqlexec(mcon1, "select protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient, " + ;
	"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
	"REG_nrohclinica, REG_telefonos, REG_domicilio, AFI_nroafiliado, ESP_descripcion,"+;
	"guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip  " + ;
	"from prestacions, entidades, especialid, registracio, afiliacion," + ;
	"tabtipoaltas ,guardia "+;
	"left outer join prestadores on guardia.codmed = prestadores.id " + ;
	"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
	"guardia.nroregistrac = afiliacion.registracio and " + ;
	"guardia.codent = afiliacion.AFI_codentidad and " + ;
	"guardia.codprest = prestacions.PRE_codprest and " + ;
	"guardia.codestado = tabtipoaltas.id and " + ;
	"prestacions.PRE_especialidad = ESP_codesp and " + ;
	"guardia.codent	= entidades.ENT_codent and protocolo = ?mprotocolo" + ;
	"", "mwkguardia")


if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
