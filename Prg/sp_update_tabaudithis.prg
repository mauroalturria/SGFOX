Lparameters tnidultimo,tnlchdescrip,tnlchinterp,tnlchjusti

mret      = SQLExec(mcon1,"update TabAuditHis set tah_Descripcion = ?tnlchdescrip,"+;
	" tah_Interpretacion = ?tnlchinterp,tah_Justificacion = ?tnlchjusti "+;
	" where tah_Idtabauditeval = ?tnidultimo")
If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif