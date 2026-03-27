***************
** busco seguimiento ART
**********

Lparameters mopc,mnreg,mfecfin ,mcart
If Vartype(mfecfin )<>"D"
	mfecfin = Ctod("01/01/2100")
Endif
Do Case
Case mopc = 1
	mbusc = " Where SA_Nroregistrac = ?mnreg and SA_FechaFin >= ?mfecfin "
Endcase
mret = SQLExec(mcon1, " SELECT ID , CodAmbito , SA_CodigoART , SA_CodigoSG , SA_Dictamen ,"+;
	" SA_Entidad , SA_Estado , FecHorDbAdd , FecHorDbUpd , SA_FechaFin , SA_FechaIni , SA_Nroregistrac ,"+;
	" SA_Siniestro , SA_TipoAt , UserDbAdd , UserDbUpd FROM  ZabSegART"+mbusc , "mwksegart")
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
