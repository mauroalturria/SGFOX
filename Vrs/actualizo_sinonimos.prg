mcon1 = sqlconnect("conec02")              && String de Coneccion a DESARROLLO
select tabciap2e
scan
	if !empty(nvl(sinonimos,''))
		mid = id
		msinonimo = sinonimos
		mret = sqlexec(mcon1,"Update TabCiap2E  set sinonimos =?msinonimo  where id = ?mid")
	endif
endscan
do sp_desconexion