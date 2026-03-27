Parameters tnOpcion 

If Vartype(tnOpcion) <> "N"
	tnOpcion = 1
Endif  	


DO CASE
	CASE tnOpcion = 1

		mRet = SQLExec(mcon1,"select TabLlamaIp.LLA_ipserver, TabStPuesto.nombre " + ;
			"from TabLlamaIp " + ;
			"left join tabstpuesto on TabLlamaIp.LLA_ipserver=TabStPuesto.puesto " + ;
			"group by TabLlamaIp.LLA_ipserver ", "mwkSvrLlama")
	
	CASE tnOpcion = 2
	
		mRet = SQLExec(mcon1,"select TabLlamaIp.LLA_ipserver, TabStPuesto.nombre " + ;
			"from TabLlamaIp " + ;
			" inner join tabturnum on TUN_IpSVR = TabLlamaIp.LLA_ipserver and TUN_FecPasiva = '1900-01-01' " + ;
			"left join tabstpuesto on TabLlamaIp.LLA_ipserver=TabStPuesto.puesto " + ;
			"group by TabLlamaIp.LLA_ipserver ", "mwkSvrLlama")

ENDCASE
	
If mRet <= 0
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	