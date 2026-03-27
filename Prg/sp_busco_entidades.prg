************************
*Autor:Claudia Antoniow
************************
* fecha :12/02/2004
************************

mret =sqlexec(mcon1,"SELECT ENT_descrient, ENT_codent,ENT_nroprestadorexterno FROM entidades, tabbonoenti "+;
					" WHERE ENT_codent = codent GROUP BY ENT_codent ","MWKEnti")

if mret < 0
	mret = 0
	messagebox('ERROR DE CURSOR. REINTENTE',64,'Validacion')
	do prg_cancelo
endif					