Parameters nvale

mret=SQLExec(mcon1,"select Nrovalerelacionado,ID as cod from tabvalerelacion where nrovaleoriginal=?nvale ","mwkvalrela")
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  

If Used("mwkvalrela")
    If (Reccount("mwkvalrela")>0)
		Return .t.
    Endif
Endif

Use In mwkvalrela
mret=SQLExec(mcon1,"select Nrovaleoriginal as  Nrovalerelacionado,ID as cod from tabvalerelacion where Nrovalerelacionado=?nvale ","mwkvalrela")

If mret <= 0
    Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
    Messagebox("ERROR DE LECTURA",48,"VALIDACION")
    Return .F.
Endif        


