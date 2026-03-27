***
*** Busco el ini por ambito
***
lparameters miambito
if vartype(miambito)= "N"
	if miambito = 0 &&& trae todos
		mret = sqlexec(mcon1, "select * from tabambitoini,TabAmbitoSuper " + ;
			" where codambito = AMY_AmbitoId  "+;
			" order by codambito ", "mwkambini")
	else
		mret = sqlexec(mcon1, "select * from tabambitoini,TabAmbitoSuper  " + ;
		"where codambito= ?miambito and codambito = AMY_AmbitoId ", "mwkambini")
	endif
else
	mret = sqlexec(mcon1, "select * from tabambitoini,TabAmbitoSuper  " + ;
		"where codambito= ?mxambito and codambito = AMY_AmbitoId ", "mwkambitoini")
endif
if mret < 0
	lcStringConn = ''
	Do buscoini With Upper(mwkexe.nomexe)

	Do log_errores With Error(), Message(), lcStringConn, Program(), Lineno()
	do sp_desconexion with "sp_valido_ambito"
	cancel
endif

