Lparameters tncodadmi,tnfecheval,tnfechadesde,tnfechahasta,tnobservaciones;
	,tnevalini,tnfechoramov,tncodigovax,tnsector,tnfechaadmi,tnestado

mret=SQLExec(mcon1,"insert into TabAuditEval(tae_codadmision, "+;
	" tae_fechaeval,tae_fechadesde,tae_fechahasta,tae_observaciones,tae_evalini, "+;
	" tae_CargaFechaHora,tae_CodigoVax,tae_descripsec,tae_fechaadmision,TAE_ESTADO) " +;
	" values (?tncodadmi,?tnfecheval,?tnfechadesde,?tnfechahasta,?tnobservaciones,?tnevalini, "+;
	" ?tnfechoramov,?tncodigovax,?tnsector,?tnfechaadmi,?tnestado)")

If mret < 1	
*!*	=AERROR(eros)
*!*	MESSAGEBOX(eros(3))
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif