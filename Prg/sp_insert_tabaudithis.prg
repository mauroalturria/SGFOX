Lparameters tnidultimo,tnlchdescrip,tnlchinterp,tnlchjusti

mret      = SQLExec(mcon1,"insert into TabAuditHis(tah_Idtabauditeval,"+;
	" tah_Descripcion,tah_Interpretacion,tah_Justificacion)"+;
	" values (?tnidultimo,?tnlchdescrip,?tnlchinterp,?tnlchjusti)")

If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif