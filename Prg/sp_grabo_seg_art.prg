***************
** grabo seguimiento ART
**********

Lparameters mxopc,mxnreg,mxfecfin,mxid,mxcart,mxcodmed,mxdicta,mxent,mxestado,mxfecini,mxctipoat
If Vartype(mxfecfin )<>"D"
	mxfecfin = Ctod("01/01/2100")
Endif
Do Case
Case mopc = 1
	mret = SQLExec(mcon1, " insert into ZabSegART (SA_CodigoART, SA_CodigoSG, SA_Dictamen,"+;
		" SA_Entidad, SA_Estado, SA_FechaFin, SA_FechaIni, SA_Nroregistrac,"+;
		" SA_Siniestro, SA_TipoAt ) values ( ?mxcart, ?mxcodmed, ?mxdicta, ?mxent, ?mxestado"+;
		", ?mxfecfin, ?mxfecini, ?mxnreg, ?mxcart, ?mxctipoat )")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN CONSULTA ART"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Else
		mret = SQLExec(mcon1, "SELECT ID , CodAmbito , SAL_Estado , FecHorDbAdd , FecHorDbUpd , SAL_Fechamod"+;
			" , UserDbAdd , UserDbUpd , SAL_Usuario , SAL_idSiniestro "+;
			" FROM  ZabSegARTLog,ZabSegART "+mbusc+ " and  ZabSegARTLog.SAL_idSiniestro = ZabSegART.id ", "mwksegartlog")
	Endif
Case mopc = 2
	mbusc = " Where SA_Nroregistrac = ?mxnreg and SA_FechaFin >= ?mxfecfin "
Endcase
