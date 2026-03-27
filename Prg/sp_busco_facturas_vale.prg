****
**
****

parameter mptovta, mnrovale,mcodpun,mnrofact
do case
	case vartype(mcodpun)="N"
		mret = sqlexec(mcon1, "select abrevio, letracte, nrocte, ptovta, tpocte,fechacte,cuenta,nroregistracio " + ;
			"from tabfacturas left join tabformularios on tabfacturas.tpocte = tabformularios.id " + ;
			"where  codpun = ?mcodpun and ptovta in "+mptovta , "mwkfactu")

	case vartype(mnrovale)="N"
		mret = sqlexec(mcon1, "select abrevio, letracte, nrocte, ptovta, tpocte,fechacte,cuenta,nroregistracio " + ;
			"from tabfacturas left join tabformularios on tabfacturas.tpocte = tabformularios.id " + ;
			"where  nrovale = ?mnrovale and ptovta in "+ mptovta , "mwkfactu")
	case vartype(mnrofact)="N"
		mret = sqlexec(mcon1, "select abrevio, letracte, nrocte, ptovta, tpocte,fechacte,cuenta,nroregistracio " + ;
			"from tabfacturas left join tabformularios on tabfacturas.tpocte = tabformularios.id " + ;
			"where  nrocte = ?mnrofact and ptovta in "+ mptovta , "mwkfactu")
endcase
