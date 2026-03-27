lparameters lcIp

mret = sqlexec(mcon1,"select Id, LLA_ippuesto, LLA_ipServer " + ;
	"from TabLlamaIp " + ;
	"Where LLA_IpPuesto = ?lcIp " + ;
	"", "mwkLlamaIp")

if mret <= 0
	mret = sqlexec(mcon1,"select Id " + ;
		" from TabTipoturno " + ;
		"Where 1=2 " , "mwkLlamaIp")

*!*		messagebox("NO PUDO GENERAR EL CURSOR ",48,"VALIDACION")
*!*		return .F.
endif
