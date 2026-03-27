lParameters mfecdes, mfechas

*!*	mfecdes = ctot("02/01/2009")
*!*	mfechas = ctot("02/01/2009")

mresu = SqlExec(mcon1,"select * " + ;
	"from TabProxyGroup " + ;
	"where tpg_Fecha >= ?mfecdes and " + ;
	"tpg_fecha <= ?mfechas", "mwkProxyGroup")
	
If mresu <= 0
*!*		AERROR(EROS)
*!*		?EROS(3)
	MessageBox("ERROR DE LECTURA",48,"VALIDACION")
	Return  
Endif 	

