Parameters nvale
Local ldfecpasiva
ldfecalta='1900-01-01'
mret=SQLExec(mcon1,"select Nrovalerelacionado,ID as cod from tabvalerelacion where nrovaleoriginal=?nvale and fecpasiva=?ldfecalta ","mwkvalrela")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif
If Used("mwkvalrela")
	If (Reccount("mwkvalrela")==0)
		Use In  mwkvalrela
		mret=SQLExec(mcon1,"select Nrovaleoriginal as  Nrovalerelacionado,ID as cod from tabvalerelacion where Nrovalerelacionado=?nvale and fecpasiva=?ldfecalta","mwkvalrela")
	Endif
Endif


If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif