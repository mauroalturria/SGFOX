*******************************
* AUTOR: Claudia Antoniow
*******************************
* Fecha : 30/10/2003
*******************************
*Fecha Ultima Modif: 30/102003
*******************************
parameter vr_idbono,vr_ptovta

mret = sqlexec(mcon1," SELECT nrocte,importe,ptovta, tpocte, a.* " +;
	" FROM Tabdetallefac as a, TabFacturas as b "+ ;
	" WHERE a.nrofactura = b.nrocte AND a.tipobono = ?vr_idbono "+;
	" AND b.ptovta =?vr_ptovta " +;
	" ", "MwkUltFact1")


if mret < 0
	messagebox('ERROR DE CURSOR  MwkUltFact , REINTENTE',16,'VALIDACION')
	mret  = 0
else
	if !eof("MwkUltFact1")
		select a.* from mwkultfact1 as a, mwkfac1 as b;
			where a.nrocte=b.nrocte order by a.bonohasta desc, a.fechagraba desc ;
			into cursor mwkultfact
	endif
endif
