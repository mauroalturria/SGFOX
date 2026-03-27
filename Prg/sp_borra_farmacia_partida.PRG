*
* Pasivación de una partida de Stk de Medicamentos Citostáticos
*
Lparameters mpartid,mfechamov 

*mfechamov = sp_busco_fecha_serv("DT")

mret = sqlexec(mcon1, "update TabFarmCitosP" + ;
	" set TCP_fechapasiva = ?mfechamov"+;
	" where TCP_partida = ?mpartid" )

If mret < 0
	mfinaliza = .f.
	Messagebox("EN MAESTRO DE PARTIDAS MEDICAMENTOS CITOSTATICOS,"+CHR(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Return
Endif
