Lparameters mCodAdm,nserv,lexcluye
	
IF VARTYPE(lexcluye)<>"N"
	lexcluye = 0
ENDIF
nnot = IIF(lexcluye=0,'',' not ')
mbusca = " where val_codadmision= ?mCodAdm and  VAL_estado<3 "
If Vartype(nserv)="N"
	mbusca = mbusca + " and VAL_codservvale =?nserv "
ELSE
	mbusca = mbusca + " and VAL_codservvale "+nnot +" in ("+nserv+") "

Endif

mret = SQLExec(mcon1, "Select * from valesasist " +mbusca ,"mwkvalpen")

If mret =< 0
	Messagebox("ERROR DE LECTURA DE OBS. VALE",48,"VALIDACION")
	Return .F.
Endif
 
Return Reccount("mwkvalpen")

