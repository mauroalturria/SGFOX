lparameters lcConsultorio, lcEspec, lnNroRegistrac, lcIpMaquina, lnNroVAle

*!*		lcIpServer     = "172.16.1.10,5.185.182.173" &&mwkLlamaIp.llaIpServer
*!*		lcNombrePac    = "FUNES, CARMEN"
*!*		lcConsultorio  = "1"
*!*		lcEspec        = "CLINICA"
*!*		lnNroRegistrac = 3133201
*!*		lcipMaquina    = "172.16.1.9"

If Vartype(lnNroVAle)<>"N"
	lnNroVAle = 0
Endif 


mfecha = sp_busco_fecha_serv("DT")
mFecNull = ctod("01/01/1900")

select mwkLlamaIp
scan all

	lcIpServer = mwkLlamaIp.LLA_IpServer

	mret = sqlexec(mcon1,"Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, " + ;
									"LLA_consultorio, LLA_espec, LLA_NroRegistrac, LLA_fechaPant, LLA_codvale) values " + ;
			" (?lcipMaquina, ?lcIpServer, ?mfecha, ?lcConsultorio , ?lcEspec, ?lnNroRegistrac, ?mFecNull, ?lnNroVAle  )")	

	if mret <= 0
		aerror(eros)
		messagebox("NO PUDO ACTUALIZAR",48,"VALIDACION")
		return .F.
	endif 


	select mwkLlamaIp
Endscan

use in mwkLlamaIp