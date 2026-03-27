PARAMETERS tnevenadver,tnATBUR,tnARM,tnsonda,tncateter,tnidultimo,tniacs

mret      = SQLExec(mcon1,"insert into TabAuditDetalle(tad_EventosAdve,"+;
		" tad_AtbUr,tad_Arm,tad_SondaVesical,tad_CateterCentral,tad_Idtabauditeval,tad_IACS)"+;
		" values (?tnevenadver,?tnATBUR,?tnARM,?tnsonda,?tncateter,?tnidultimo,?tniacs)")
		
If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif