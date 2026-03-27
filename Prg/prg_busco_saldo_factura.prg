****
** BUSCO SALDO DE LA FACTURA
****

parameter mptovta, mletra, mnrocte


	select sum(iif(tpocte < 5, importe, importe * -1)) as impo ;
	from mwkfactu ;
	where apliptovta   = mptovta and ;
		  apliletracte = mletra  and ;
		  aplinrocte   = mnrocte ;
	group by aplinrocte into cursor mwksaldo