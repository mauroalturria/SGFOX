****
** actualizo la tabla de ambitos por usuario
****
parameter muserid, mambid, mcual

msectorid = mwkUsuario.Codigovax
if mcual = 1	&& agrego amb
	mfecpas = ctod('01/01/1900')
	mret = sqlexec(mcon1, "insert into Tabpermisosambito(codambito, codusuario, fecpasiva ) " + ;
		"values(?mambid, ?muserid, ?mfecpas )")
endif

if mcual = 2	&& quito amb
	mfecpas = sp_busco_fecha_serv ('DD')
	mret = sqlexec(mcon1, "update Tabpermisosambito set fecpasiva = ?mfecpas " + ;
		" where codambito = ?mambid and codusuario = ?muserid  ") && and codigovax = ?msectorid este fue el cambio
endif

