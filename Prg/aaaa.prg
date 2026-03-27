mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient " + ;
	",prestasol.PRE_descriprest as prestasolic, presta.PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad " + ;
	",REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,ESP_descripcion "+;
	", guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9,ASP_observa " + ;
	", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,presta.PRE_descriprest as prestacons "+;
	" from guardia inner join prestacions as presta on guardia.codprest =presta.PRE_codprest "+;
	" inner join entidades on guardia.codent =  entidades.ENT_codent "+;
	" inner join especialid on presta.PRE_especialidad = ESP_codesp "+;
	" inner join registracio on  guardia.nroregistrac = registracio.REG_nroregistrac "+;
	" inner join TabSolPract on TabSolPract.ASP_protocolo = guardia.protocolo "+;
	" inner join prestacions as prestasol on ASP_codprest = prestasol.PRE_codprest " + ;
	" inner join tabtipoaltas on guardia.codestado 		= tabtipoaltas.id "+;
	" left outer join prestadores on guardia.codmed = prestadores.id " + ;
	" where "+;
	" guardia.fechahoraing >= ?mfecha and ASP_tipopac ='GUA' and presta.PRE_codservicio = 8000 " + ;
	"", "mwkguardia0")

mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient " + ;
	",presta.PRE_descriprest as prestasolic, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad " + ;
	",REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,ESP_descripcion "+;
	", guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9,ASP_observa " + ;
	", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,presta.PRE_descriprest as prestacons "+;
	" from guardia inner join prestacions presta on guardia.codprest =presta.PRE_codprest "+;
		" inner join entidades on guardia.codent =  entidades.ENT_codent "+;
" left outer join prestadores on guardia.codmed = prestadores.id " + ;
	" inner join registracio on  guardia.nroregistrac = registracio.REG_nroregistrac "+;
	" inner join especialid on presta.PRE_especialidad = ESP_codesp "+;
" inner join tabtipoaltas on guardia.codestado 		= tabtipoaltas.id "+;
	" inner join TabSolPract on TabSolPract.ASP_protocolo = guardia.protocolo "+;
	" where "+;
	" ASP_fechasol >= guardia.fechahoraing and " + ;
	" and ASP_tipopac ='GUA' and " + ;
	" guardia.fechahoraing >= ?mfecha and presta.PRE_codservicio = 8000 " +mbuscog+ ;
	"", "mwkguardia0")
