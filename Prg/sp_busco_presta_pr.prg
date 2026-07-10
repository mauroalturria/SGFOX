*****
***** Busco prestadores Preregistrados
*****
 
mret = sqlexec(mcon1,'select a.nombre, a.telefono, a.telcelular, a.fecalta, a.email, a.codesp, a.codmed, a.matriculas '+;
	' , a.observaciones , a.codMedCoord, a.codMedReem, a.codprof, a.coduniv , a.dambula, a.dguardia '+;
	' , a.dinterna, a.domicilio, a.estado, a.fecaltag, a.telradio, a.fecaltai '+;
	' , a.fecaltap, a.fechaReemp, a.fechamod, a.fecpasiva, a.fecpasivag, a.fecpasivai 	'+;
	' , a.hhmmRDes, a.hhmmRHas, a.matProv, a.nroDoc, a.sexo, a.usuario,ESP_codesp,ESP_descripcion,a.id  '+;
	 ', a.fecaltaq, a.fecpasivaq, a.dquirofano,TabMedExterno.gerenciadora,prestadores.cuil '+;
	 ' , a.CertEspec , a.CertVac , a.FecVtoMatricula , a.FvtoMalaPraxis , a.FvtoRNP  '+;
	 ' , a.InscRNP , a.MNActual , a.ResumenCV , a.SegMalaPraxis  '+;
	 ' , a.codloca , a.codmed , a.codpcia , a.codpostal'+;
 	' from TabPreregMed a'+;
	' left join Especialid on a.codesp = Especialid.ESP_codesp ' + ;
	' left join prestadores on a.codmed = prestadores.id ' + ;
	' left join TabMedExterno on a.codmed = TabMedExterno.id ' + ;
	' order by a.nombre',"mwkprestapr" )
if mret < 0
 	messagebox("ERROR EN LA GENERACION DEL CURSOR,REINTENTE",16,"Validacion")
	do log_errores with error(),message(),message(1),program(),lineno()
	RETURN .f.
endif

