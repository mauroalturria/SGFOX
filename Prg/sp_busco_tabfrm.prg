****
** busco los frm
****

parameter nf,msql_frm, msql_frm1

	mret = sqlexec(mcon1, "select * from tabfrm", "mwkfrm1"+nf)

	msql_frm = "select nomfrm, puntomenu, iif(primaria = 1, '  RW  ', 'Shadow') as princip, " + ;
				"iif(fecpasiva = ctod('01/01/1900'), { / /  }, fecpasiva) as fecpasiva, " + ;
				"primaria, descrip, id from mwkfrm1"+nf+" order by puntomenu into cursor mwkfrm"+nf 
				
	msql_frm1 = "select nomfrm,puntomenu, id from mwkfrm1"+nf+" order by nomfrm into cursor mwkfrm"+nf 			