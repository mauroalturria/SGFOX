*
* Totalizador de Residencias
*
mret = sqlexec(mcon1,"select count(*) as nTotal from " + mtabla + " where TRE_dimension=?mbusca"+;
	" and TRE_anio = ?mranio and TRE_evento = ?mreven "+ mwhere +;
	" not in (select TRA_preguntanro from TabResAnu where TRA_tema=?mtem"+;
	" and TRA_anio=?mranio and TRA_evento=?mreven)","mwktotal")
If mret < 0
	Messagebox("EN ARMADO DE TOTALES"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
