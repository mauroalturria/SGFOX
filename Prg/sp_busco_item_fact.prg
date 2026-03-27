****
** Busca los items de facturas y n. credito
****
parameters mptovta,mtipo,mletra,mnumero

	mret= sqlexec(mcon1,'select * from TabdetalleFac '+;
			' where ptovta = ?mptovta and tipocomp = ?mtipo and ' + ;
			'letracomp= ?mletra and nrofactura= ?mnumero','mwkitemfac')

	mret = sqlexec(mcon1, "select * from tabfacturas " + ;
				'where  ptovta = ?mptovta and tpocte = ?mtipo and ' + ;
				'letracte = ?mletra and nrocte = ?mnumero ' , "mwkfactu")

