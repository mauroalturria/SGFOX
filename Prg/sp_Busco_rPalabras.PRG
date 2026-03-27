LPARAMETERS tnIdEst
*, tcCurName, tnCodServ

*!*	mret = sqlexec(mcon1, "Select * from TabPalabraTexto " + ;
*!*		"Where Pal_Tipo = ?tnIdEst And Pal_CodServ = ?tnCodServ and  Pal_CodAmbito = ?mxambito " + ;
*!*		"Order by Pal_Palabra asc ", tcCurName)

*!*	If mret <= 0
*!*		mret = sqlexec(mcon1, "Select * from TabPalabraTexto " + ;
*!*			"Where Pal_Tipo = ?tnIdEst and  Pal_CodAmbito = ?mxambito " + ;
*!*			"Order by Pal_Palabra asc ", tcCurName)
*!*	Endif  


*!*	If mret < 0
*!*	*!*		=aerr(eros)
*!*	*!*		Message(eros(3))
*!*		Messagebox("ERROR DE LECTURA DE PALABRAS DE REEMPLAZO",16,"ERROR")
*!*		Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
*!*		Return .F.
*!*	Endif



*!* CODIGO NUEVO AGREGADO POR SOLER MAURO 30/08/2013 

mret = sqlexec(mcon1, "select SER_codserv, ser_descripserv as servicios,scv_mnemonico,"+;
	" TabPalabraTexto.ID AS NUMREG,PAL_PALABRA AS PALABRA,Pal_CodAmbito,"+;
	" PAL_TEXTO AS TEXTO,PAL_TIPO,PAL_CODSERV"+;
	" from  servcargval,servicios " + ;
	" LEFT JOIN TabPalabraTexto ON   SER_codserv  = Pal_CodServ and (Pal_Tipo = ?tnIdEst and Pal_CodAmbito = ?mxambito)"+;
	" where ser_codserv = servcargval.scv_codservicio " + ;
	" and scv_mnemonico is not null and ser_fechapasiva is null "+;
	" order by ser_descripserv", "mwkpalserv")	
	*" and pal_Codambito=?tnCodAmbito"+;

if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	return
Endif



*!*	Select Count(PALABRA) AS cantidad,nvl(numreg,0) as numreg ,servicios,PAL_CODSERV ;
*!*	From mwkpalserv;
*!*	group By servicios Order By servicios asc;
*!*	into Cursor mwkpalserv1