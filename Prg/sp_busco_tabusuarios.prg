****
** busco usuarios en tabusuarios
****

parameter nf,msql_usu


	mret = sqlexec(mcon1, 'select * from tabusuario order by nomape', 'mwkusuarios')

	if mret > 0
		msql_usu = "select nomape as usuario, codigovax, idusuario, " + ;
					"iif(fecpasiva = ctod('01/01/1900'), { / /  }, fecpasiva) as fecpasiva, " + ;
					"descrip, password, fecingreso, leg_id,nrodocumento,email,id from mwkusuarios into cursor mwkusu"+nf
	else
		=aerr(eros)
		messagebox(eros(2))
	endif
	
	return(msql_usu)	