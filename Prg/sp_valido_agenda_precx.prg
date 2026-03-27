* sp_valido_agenda_precx

Lparameters ldiad,ldiah

If Vartype(ldiah)#"D"
ldiah = Ctod("01/01/2100")
endif 

lcSQL = "Select * from tabpqquiro"
Sqlexec(mcon1,lcSQL,"mwktabpqquiro")

Select * From mwktabpqquiro where Between(pqq_fecha,ldiad,ldiah) into cursor mwktabpqquiro2 Readwrite 

Select mwktabpqquiro2
If Reccount("mwktabpqquiro2")>0
Messagebox("Ya está generada la agenda")
Return .t.
Else
Messagebox("No está generada la agenda")
Return .f.
Endif
