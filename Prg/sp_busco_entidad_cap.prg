***
***  busqueda de las entidades capitadas
***

mfecha = sp_busco_fecha_serv("DD")

mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno from entidades " + ;
					"where ENT_capita = 'S' and "+;
					"(ENT_fecpas is null or ENT_fecpas > ?mfecha )" ,"mwkenticap")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	do prg_cancelo
endif	