lParameters mabm, mfecdes, mfechas

*!*	mfecdes = ctot("07/01/2009")
*!*	mfechas = ctot("07/01/2009")
*!*	mabm    = 3

Do Case 
	Case mabm = 1
		mresu = SqlExec(mcon1,"select * " + ;
			"from TabProxyLog " + ;
			"where tpl_Fecha >= ?mfecdes and " + ;
			"tpl_fecha <= ?mfechas", "mwkProxyLog")

	Case mabm = 2
		mresu = SqlExec(mcon1,"select tpl_Fecha, TPL_HH, TPL_IP, TPL_USER, " + ;
			"TPL_URL, TPL_ESTADO,  Count(*) as Cant, Sum(TPL_Bytes)/1024/1024 as MB " + ;
			"from TabProxyLog " + ;
			"where tpl_Fecha >= ?mfecdes and " + ;
			"tpl_fecha <= ?mfechas " + ;
			"Group by tpl_Fecha, TPL_HH, TPL_IP, TPL_USER, TPL_URL, TPL_ESTADO ", "mwkProxyLog")


	Case mabm = 3
		mresu = SqlExec(mcon1,"select TPL_HH, TPL_IP, TPL_USER, " + ;
			"TPL_URL, TPL_ESTADO,  Count(*) as Cant, Sum(TPL_Bytes)/1024/1024 as MB " + ;
			"from TabProxyLog " + ;
			"where tpl_Fecha >= ?mfecdes and " + ;
			"tpl_fecha <= ?mfechas " + ;
			"Group by TPL_HH, TPL_IP, TPL_USER, TPL_URL, TPL_ESTADO ", "mwkProxyLog")

EndCase	

If mresu <= 0
*!*		AERROR(EROS)
*!*		?EROS(3)
	MessageBox("ERROR DE LECTURA",48,"VALIDACION")
	Return  
Endif 	

