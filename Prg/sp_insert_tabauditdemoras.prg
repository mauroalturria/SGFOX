LPARAMETERS tnidultimo,tnlndclinica,tnlndquir,tnlndmateri,tnlndestud,;
	        tnlndid,tnlndneta,tnlndalta 
	   
mret= SQLExec(mcon1,"insert into TabAuditDemoras(taud_Idtabauditeval,"+;
	" taud_Clinica,taud_Quirofano,taud_Materiales,taud_Estudios,"+;
	" taud_IDD,taud_Neta,taud_Alta)"+;
	" values (?tnidultimo,?tnlndclinica,?tnlndquir,?tnlndmateri,?tnlndestud,"+;
	" ?tnlndid,?tnlndneta,?tnlndalta )")

If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif