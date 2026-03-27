****
** busco totales por vales para rendimiento
****

parameter mfecdes, mfechas, mbusco, msql_tot
	
	do sp_conexion_tablas
	
	
	mret = sqlexec(mcon3, "select esp_codesp, esp_descripcion, pia_codprest, val_codservvale, " + ;
							"sum(pia_cantsolicitada) as total " + ;	
 							"from valesasist, presinsuvas, especialid, prestacions " + ;
 							"where  valesasist = pia_valesasist and " + ;
 								"pia_codprest = pre_codprest and " + ;
 								"pre_especialidad = esp_codesp and " + ;
 								"val_fechasolicitud >= ?mfecdes and " + ;
 								"val_fechasolicitud <= ?mfechas and " + ;
       							"val_circuitoorigen = '0' " + ;
       						"group by esp_codesp, val_codservvale " + ;	
       						"order by esp_codesp " , "mwktotval0")
	
	mret = sqlexec(mcon3, "select esp_codesp, esp_descripcion, pia_codprest, val_codservvale, " + ;
							"sum(pia_cantsolicitada) as total " + ;	
 							"from valesasist, presinsuvas, especialid, prestacions " + ;
 							"where  valesasist = pia_valesasist and " + ;
 								"pia_codprest = pre_codprest and " + ;
 								"pre_especialidad = esp_codesp and " + ;
 								"val_fechasolicitud >= ?mfecdes and " + ;
 								"val_fechasolicitud <= ?mfechas and " + ;
       							"val_circuitoorigen = '1' " + ;
       						"group by esp_codesp, val_codservvale " + ;	
       						"order by esp_codesp " , "mwktotval1")

	mret = sqlexec(mcon3, "select esp_codesp, esp_descripcion, pia_codprest, val_codservvale, " + ;
							"sum(pia_cantsolicitada) as total " + ;
 							"from valesasist, presinsuvas, especialid, prestacions " + ;
 							"where  valesasist = pia_valesasist and " + ;
 								"pia_codprest = pre_codprest and " + ;
 								"pre_especialidad = esp_codesp and " + ;
 								"val_fechasolicitud >= ?mfecdes and " + ;
 								"val_fechasolicitud <= ?mfechas and " + ;
       							"val_circuitoorigen = '2' " + ;
       						"group by esp_codesp, val_codservvale " + ;
       						"order by esp_codesp " , "mwktotval2")
 							
 	
	select * from mwktotval0 ;
		union all ;
		select * from mwktotval1 ;
			union   all ;
			select * from mwktotval2 ;
			order by 2, 4 ;
			into cursor mwktotval22

	select esp_codesp, esp_descripcion, pia_codprest, val_codservvale, ;
		sum(iif(val_codservvale = 2200, total, 00000.00)) as totc, ;
		sum(iif(val_codservvale <> 2200, total, 00000.00)) as totd ;
	from mwktotval22 ;
	group by esp_descripcion, val_codservvale ;
	order by esp_descripcion into cursor mwktotval
 				 						
 	=sqldisconnect(mcon3)						