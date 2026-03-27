*
* Busqueda de etiquetas emitidas de medicamentos citostaticos
*
Lparameters mpartid,mcodigo

mret = sqlexec(mcon1, "select * " + ;
	"from TabFarmCitosE where TCE_insumocodigo = ?mcodigo and TCE_partida = ?mpartid "+;
	"and TCE_fechapasiva is null","mwkinsumo" )
	
If mret < 0
	Messagebox("EN MAESTRO DE ETIQUETAS EMITIDAS,"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	mctrl = .f.
Endif
