****
** Tablas para Guardia
****
	mret = sqlexec(mcon1,"select descrip, abrevio, ID, codafip " + ;
						" from tabformularios where id<=5 and abrevio<>'' ", "mwkTCte")

	mret = sqlexec(mcon1,"select abrevio, descrip, codigovax, id " + ;
					"from tabdocumentos where id<100000 order by id", "mwkdocu")
					
	mret = sqlexec(mcon1,"select descrip, codesp, atiendeen from guardiaespecialid " + ;
					"where id<100000 order by descrip", "mwkespe")
					
	mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient from entidades " + ;
					"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
					"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
					"order by ENT_descrient", "mwkentidad1")

	mret = sqlexec(mcon1,"select descrip, id, sector,tipoest from tabtipoaltas " + ;
						"where sector <3 and id<100000  " + ;
						"order by descrip", "mwktaltas")
						
	mret = sqlexec(mcon1, "select ser_codserv, ser_descripserv from servicios, servcargval " + ;
					"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
					"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")

	mret = sqlexec(mcon1, "select * from  tabCIE10 ", "mwkCie9")
	
	mret = sqlexec(mcon1, "select * from tabsectorint where id<100000  order by descrip", "mwksecint")
   
 	mret = sqlexec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")
	
	mret = sqlexec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")

	mret = sqlexec(mcon1, "select * from  TabCiap2E ", "mwkCiap2e")
	
 	mret = sqlexec(mcon1, "select * from  TabCieNanda ", "mwkCieN")
 	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion") 
		DO sp_desconexion WITH "Err sp_tablas_guardia"
		CANCEL
	endif				

	mret = sqlexec(mcon1, "select * from planes  where id<1000 ", "mwkplanpre")

