****
**  Busco Texto para retiro de Estudios
****
Parameter mcodserv,lesguardia
lesguardia = Iif(Vartype(lesguardia)="U",.F.,lesguardia)
*!*	mbus = "and subserv in ('',"+ iif(mwkexe.nomexe="TURNOS","'A'",;
*!*		iif(inlist(mwkexe.nomexe,"GUARDIA",'ADMISION'),"'G'", "''") )+") "

mbus = "and subserv in ('',"+ Iif(lesguardia,"'G'", "''") +") "

mret = SQLExec(mcon1, 'select descrip from tabretestudio '+;
	'where codserv = ?mcodserv and centromedico = ?mxcentromedico '+mbus+;
	 ' group by codprest, codserv ' , 'mwkretestudio')
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
If Reccount('mwkretestudio')=0
	mbus =mbus + " and centromedico = ?mxcentromedico "
	mret = SQLExec(mcon1, 'select descrip from tabretestudio '+;
		'where codserv = ?mcodserv '+mbus +;
		 ' group by codprest, codserv ', 'mwkretestudio')
Endif
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
