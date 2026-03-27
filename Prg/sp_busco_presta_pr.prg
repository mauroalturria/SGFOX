*****
***** Busco prestadores Preregistrados
*****

mret = sqlexec(mcon1,'select nombre, telefono, telcelular, fecalta, email, codesp, codmed, matriculas,'+;
	' observaciones ,codMedCoord, codMedReem, codprof, coduniv ,dambula, dguardia,'+;
	' dinterna, domicilio, estado, fecaltag, telradio, fecaltai, '+;
	' fecaltap, fechaReemp, fechamod, fecpasiva, fecpasivag, fecpasivai,	'+;
	' hhmmRDes, hhmmRHas, matProv, nroDoc, sexo, usuario,ESP_codesp,ESP_descripcion,id '+;
	 ',fecaltaq, fecpasivaq, dquirofano '+;
	' from TabPreregMed '+;
	' left join Especialid on TabPreregMed.codesp = Especialid.ESP_codesp ' + ;
	' order by nombre', "mwkprestapr" )
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do log_errores with error(), message(), message(1), program(), lineno()
	RETURN .f.
endif

