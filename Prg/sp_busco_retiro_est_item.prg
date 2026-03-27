****
**  Busco Texto para retiro de Estudios por items del vale
****

Parameter nroitem
mbus = "and subserv in ('',"+ Iif( At('TURNOS',mwkexe.nomexe )>0,"'A'",Iif(Inlist(mwkexe.nomexe,"GUARDIA",'ADMISION'),"'G'", "''") )+") "

For F = 1 To nroitem
	mprest = item_vale(F,1)
	mret = SQLExec(mcon1, 'select descrip from tabretestudio where codprest = ?mprest '+mbus+;
		' and centromedico = ?mxcentromedico group by codprest, codserv ', 'mwkretest')
	If Reccount('mwkretest') = 0
		mret = SQLExec(mcon1, 'select descrip from tabretestudio where codprest = ?mprest '+mbus+;
			'   group by codprest, codserv ', 'mwkretest')
	Endif
	If mret < 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	If Reccount ('mwkretest')>0
		midesc = Alltrim(mwkretest.Descrip)
		Insert Into mwkretestudio (Descrip) Values (Alltrim(item_vale(F,3)))
		Insert Into mwkretestudio (Descrip) Values (midesc )
	Endif
Next
If !Used('mwkretestudio')
	mret = SQLExec(mcon1, 'select descrip from tabretestudio '+;
		'where codserv = 1 '+;
		' group by codprest, codserv ', 'mwkretestudio')
Endif
If Reccount ('mwkretestudio')>0
	For F = 1 To nroitem
		Insert Into mwkretestudio (Descrip) Values ("*"+Left(Alltrim(item_vale(F,3)),36))
	Next
Endif
Select mwkretestudio
Go Top
