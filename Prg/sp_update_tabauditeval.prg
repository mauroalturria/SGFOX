Lparameters tncodadmi,tnfecheval,tnfechadesde,tnfechahasta,tnobservaciones,;
	tnevalini,tnfechoramov,tncodigovax,tnsector,tnfechaadmi,tnestado,tnidultimo
mret=SQLExec(mcon1,"update TabAuditEval set tae_fechaeval = ?tnfecheval,tae_fechadesde = ?tnfechadesde,"+;
	" tae_fechahasta = ?tnfechahasta,tae_observaciones = ?tnobservaciones,"+;
	" tae_evalini=?tnevalini,tae_CargaFechaHora = ?tnfechoramov,tae_CodigoVax =?tncodigovax,"+;
	" tae_descripsec = ?tnsector,tae_fechaadmision = ?tnfechaadmi,tae_estado = ?tnestado "+;
	" where id = ?tnidultimo")
If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif