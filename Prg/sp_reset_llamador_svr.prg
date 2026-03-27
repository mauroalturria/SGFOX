lparameters lcIpSvr

mfecnull = Ctod('01/01/1900')
mfecha   = sp_busco_fecha_serv('DT')
mfechaSol = mfecha - (60 * 5) && dejo los ultimos 5 minutos

mret = sqlexec(mcon1,"update Tabllamador " + ;
	"Set LLA_fechapant = ?mfecha Where LLA_IpServer = ?lcIpSvr and " + ;
	"LLA_fechapant = ?mfecnull and LLA_FechaSol < ?mfechaSol " + ;
	"" )
	
if mret <= 0
	Do prg_error_SQL("NO PUDO ACTUALIZAR")
	return .F.
endif 