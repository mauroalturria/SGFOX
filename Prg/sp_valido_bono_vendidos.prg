******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :30/10/2003
********************
parameter v_nrbono, vr_codbon, vr_nomb
*!*	msec1= seconds()
*!*		mret = sqlexec(mcon1," SELECT * FROM TabdetalleFachist WHERE tipobono =?vr_codbon "+;
*!*							 " AND ?v_nrbono BETWEEN BonoDesde AND BonoHasta  ","MWKVendido")
*!*	msec2= seconds()
*!*	messagebox(transf(msec2-msec1))
*!*	msec1= seconds()
*!*		mret = sqlexec(mcon1," SELECT * FROM TabdetalleFac WHERE tipobono =?vr_codbon "+;
*!*							 " AND ?v_nrbono BETWEEN BonoDesde AND BonoHasta  ","MWKVendido")
*!*	msec2= seconds()
*!*	messagebox(transf(msec2-msec1))
*!*	if mret < 0
*!*		messagebox('ERROR DE CURSOR MWKVendido, AVISAR A SITEMAS',16,'VALIDACION')
*!*		mret = 0
*!*	endif

*!*	if eof("MWKVendido") and used('MWKBonoSelec')
*if used('MWKBonoSelec')
	select * from MWKBonoSelec WHERE NombreBono =?vr_nomb;
				AND NroDesde =?v_nrbono OR NroHasta   =?v_nrbono into cursor MWKVendido

*endif
					  