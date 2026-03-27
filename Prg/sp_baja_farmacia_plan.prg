*
* Pasivacion de Plan de Tratamientos Citostaticos
*
Lparameters mid, mestado

If vartype(mestado)<>"N"
	mestado = 2
endif
if inlist(mestado,2,3)
	mfecbaja = sp_busco_fecha_serv('DT')
	mand = " ,TFP_fecpasiva = ?mfecbaja "
Else
	mand = ""
Endif

*mret = sqlexec(mcon1,"update TabFarmPlan set TFP_estado=?mestado where id=?mid" + mand)
mret = sqlexec(mcon1,"update TabFarmPlan set TFP_estado=?mestado " + mand+;
		" where id=?mid")

*!*	mret = sqlexec(mcon1,"update TabFarmPlan set TFP_estado=?mestado, "+;
*!*		"TFP_fecpasiva=?mfecbaja where id=?mid")

If mret < 0
	=aerror(merror)
	mresulta = .f.
	Messagebox("EN CAMBIO DE ESTADO, DE PLANILLA DE TRATAMIENTO CITOSTATICO"+CHR(10)+;
		alltrim(merror(3))+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

