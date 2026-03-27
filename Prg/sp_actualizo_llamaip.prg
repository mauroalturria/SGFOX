lparameters lnAbm, lcIpServer, lcIpPuesto, lnId

do case 
	case lnAbm = 1
		mret = sqlexec(mcon1,"Insert into TabLlamaIp (LLA_IpServer, LLA_IpPuesto) values " + ;
				" (?lcIpServer, ?lcIpPuesto )")	

	case lnAbm = 2
		mret = sqlexec(mcon1,"Update TabLlamaIp set " + ;
			"LLA_IpServer = ?lcIpServer, LLA_IpPuesto = ?lcIpPuesto " + ;
			"where id = ?lnId ")

	case lnAbm = 3
		mret = sqlexec(mcon1,"delete from TabLlamaIp where id = ?lnId")
	
	
endcase 

if mret <= 0
	aerror(eros)
	messagebox("NO PUDO ACTUALIZAR",48,"VALIDACION")
	return .F.
endif 


