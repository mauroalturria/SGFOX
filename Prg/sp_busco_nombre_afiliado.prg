*********************************************************************************
* BUSCA AFILIADO
* GENERADO : Claudia Antoniow
* FECHA :11/08/2003
* ACTUALIZADO :                                            *
*********************************************************************************
parameter mbusco1, mcnombre
 

	mret = sqlexec(mcon1," SELECT Credenciales.nrocredencial ,nombre, nrodocumento, "+;
						 " fechanacimiento, parentescos.descripcion as parentesco, "+;
						 " afiliadoprepaga.fechaingreso, "+;
						 " afiliadoprepaga.fechabaja, "+;
						 " planes.descripcion as plan, prepagas.descripcion as prepaga, "+;
						 " afiliadoprepaga.idgrupo, afiliados.id as idafiliado "+;
						 " FROM afiliados, afiliadoprepaga, prepagas, tipodocumento, "+;
						 " parentescos, coberturas, planes, gruposfamiliares, Credenciales "+;
 						  mbusco1 +;	
						 " afiliados.id  = afiliadoprepaga.idafiliado " + ;  
						 " and  afiliadoprepaga.idgrupo  = gruposfamiliares.id " + ; 
						 " and  afiliados.id  =credenciales.idafiliado " + ; 
						 " and gruposfamiliares.id = coberturas.idgrupo " + ; 
						 " and prepagas.id = gruposfamiliares.idprepaga " + ;
						 " and planes.id  = coberturas.idplan "+; 
						 " and tipodocumento.id = afiliados.tipodocumento " + ; 
						 " and parentescos.id = afiliadoprepaga.idparentesco " + ; 
						 " Group by parentescos.idparentesco, nrodocumento, "+;
 						 " fechaingreso, fechabaja "+;
						 " order by parentescos.idparentesco desc", "mwkbusafiliado")
							
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif							