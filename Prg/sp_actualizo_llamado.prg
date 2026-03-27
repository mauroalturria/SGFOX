lparameters lnId

mfecha = sp_busco_fecha_serv("DT")

mret = sqlexec(mcon1,"update Tabllamador " + ;
	" set LLA_fechapant = ?mfecha Where Id = ?lnId " + ;
	"" )
	
if mret <= 0
	Do prg_error_SQL("NO PUDO ACTUALIZAR")
	return .F.
endif 