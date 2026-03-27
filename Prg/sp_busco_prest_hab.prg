*** busqueda de prestaciones indicadas
Lparameters cWhere

mret = SQLExec(mcon1," select Tabsolpract.id,ASP_nroregistrac,ASP_codmed,ASP_fechasol,ASP_observa,ASP_codprest,ASP_cantidad,PRE_Lateralidad ,PRE_tipozona  "+;
	" from prestacions,Tabsolpract  where Tabsolpract.ASP_tipopac = 'AMB' AND Tabsolpract.ASP_codestado <= 1 "+;
	" AND pre_codprest = ASP_codprest  and (pre_automatica ='N' or pre_automatica is null )"+;
	" and pre_fechapasiva is null and ASP_cantidad>0 " +;
	+ cWhere,"mwkderivsol")

If mret < 0
	Messagebox("ERROR EN LA LECTURA DE prestaciones solicitadas ",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
