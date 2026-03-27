************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 30/10/2003
************************
*Fecha Ultima Modif: 30/102003
*******************************

*************************************************************
*
*
**************************************************************
Parameter vr_idbono, vr_usua



mret = sqlexec(mcon1," SELECT NroBono AS BonoHasta, ID,BonoSerie,Sector,TipoBono,Usuario  "+;
	"FROM TabBonoLast "+ ;
	" WHERE tipobono = ?vr_idbono and usuario =?vr_usua " , "MwkUltFact")

if MwkUltFact.BonoHasta =0
	if reccount('MwkUltFact')=0 
		mret = sqlexec(mcon1," INSERT INTO TabBonoLast "+ ;
			" (BonoSerie,NroBono,Sector,TipoBono,Usuario) values "+;
			" ( '', 0, '', ?vr_idbono, ?vr_usua )" )
	endif
	mret = sqlexec(mcon1," SELECT MAX(NroBono) AS BonoHasta, BonoSerie FROM TabBonoLast "+ ;
		" WHERE tipobono = ?vr_idbono " , "MwkUltFact")
	if mret < 0
		messagebox('ERROR DE CURSOR  MwkUltFact , REINTENTE',16,'VALIDACION')
	endif
endif


