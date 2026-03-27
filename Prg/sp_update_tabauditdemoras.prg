Lparameters tnidultimo,tnlndclinica,tnlndquir,tnlndmateri,tnlndestud,;
	tnlndid,tnlndneta,tnlndalta

mret = SQLExec(mcon1,"update TabAuditDemoras set taud_Clinica = ?tnlndclinica,"+;
	" taud_Quirofano = ?tnlndquir,taud_Materiales = ?tnlndmateri,"+;
	" taud_Estudios = ?tnlndestud,taud_IDD = ?tnlndid,taud_Neta = ?tnlndneta,"+;
	" taud_Alta = ?tnlndalta where taud_Idtabauditeval = ?tnidultimo")
If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif