LPARAMETERS tncodvax,tnfechora

mret=SQLExec(mcon1,"select top 1 id from TabAuditEval"+;
		" where tae_CodigoVax = ?tncodvax and tae_CargaFechaHora = ?tnfechora"+;
		" order by id desc","mwklastid")
		
If mret<1
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif
