select cosa
scan
	mhoratur = cosa.fechatur
	mcodmed	= cosa.codmed
	mhora = cosa.hhmmtur
	mret = sqlexec(mcon1,"select * from turnos "+;
			"where codmed = ?mcodmed and fechatur = ?mhoratur and hhmmtur= ?mhora "+;
			" and tipoturno = 2 order by afiliado ", "mwkhay")
	select mwkhay
	browse
	mid = mwkhay.id
	mret = sqlexec(mcon1,"update turnos set tipoturno= 0 " + ;
							"where codmed = ?mcodmed and fechatur = ?mhoratur and hhmmtur= ?mhora "+;
			" and tipoturno = 2 ")
	select cosa
endscan