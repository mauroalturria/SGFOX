*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*Modificado:21/02/2002
*******************************
*********************************************************************************
* Ejecuta el cursor de especialidades, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************
Lparameters ltodos,tcCursor

If Vartype(tcCursor) # "C"
	tcCursor= 'MWKespecial'
Endif 
Use In Select("mwkespecag")
mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

If Vartype(ltodos)#"N"
	If Used(tcCursor)
		Use In &tcCursor
	Endif
	mret=SQLExec(mcon1," SELECT ESP_codesp, ESP_descripcion, CAST(case ESP_turnobloqueo When 1 Then '11:00 hs.' Else '15:00 hs.' end as char(9)) as Habilito " + ;
		" FROM especialid " + ;
		" WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' " +;
		" ORDER BY ESP_descripcion",tcCursor)
Else
	If Used("MWKespeciall")
		Use In MWKespeciall
	Endif
	mret=SQLExec(mcon1," SELECT ESP_codesp, ESP_descripcion  FROM especialid " + ;
		" WHERE ESP_descripcion is not Null and esp_fecpasiva is null " +;
		" ORDER BY ESP_descripcion","MWKespeciall")
Endif
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	mret=0
	Return .F.

Endif
