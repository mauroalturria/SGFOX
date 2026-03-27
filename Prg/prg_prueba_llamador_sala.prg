*!*	PRUEBA DE LLAMADOR DESDE SALA DE ESPERA

do sp_busco_llamaip WITH Myip


select mwkLlamaIp
scan all

*!*	lparameters lcIpServer, lcNombrePac, lcConsiltorio, lcEspec, lnNroRegistrac

	lcIpServer     = "172.16.1.10,5.185.182.173" &&mwkLlamaIp.llaIpServer
	lcNombrePac    = "FUNES, CARMEN"
	lcConsultorio  = "1"
	lcEspec        = "CLINICA"
	lnNroRegistrac = 3133201
*!*		lnNroRegistrac = 843509
	lcipMaquina    = "172.16.1.9"
	

	mfecha = sp_busco_fecha_serv("DT")

	mret = sqlexec(mcon1,"Insert into TabLlamador (llaipMaquina, llaIpServer, llaFechaSol, " + ;
									"llanombrepac, llaconsultorio, llaespec, NroRegistrac) values " + ;
			" (?lcipMaquina, ?lcIpServer, ?mfecha, ?lcNombrePac, ?lcConsultorio , ?lcEspec, ?lnNroRegistrac  )")	

	if mret <= 0
		aerror(eros)
		messagebox("NO PUDO ACTUALIZAR",48,"VALIDACION")
		return .F.
	endif 


	select mwkLlamaIp
Endscan