Lparameters tnevenadver,tnATBUR,tnARM,tnsonda,tncateter,tnidultimo,tniacs

mret      = SQLExec(mcon1,"update TabAuditDetalle set tad_EventosAdve = ?tnevenadver,"+;
	" tad_AtbUr = ?tnATBUR,tad_Arm = ?tnARM,tad_SondaVesical = ?tnsonda,"+;
	" tad_CateterCentral = ?tncateter,tad_IACS = ?tniacs "+;
	" where tad_Idtabauditeval = ?tnidultimo")
If mret<1
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif