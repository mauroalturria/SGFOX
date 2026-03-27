****
** busco totales por entidad -servicio de amb
****

parameter mfecdes, mfechas, mbusco, msql_tot
	
	
	mret = sqlexec(mcon1, "select ENT_descripent, ser_descripserv, VAL_tipopaciente, " + ;
 							"sum(pia_cantsolicitada) as cantidad, VAL_circuitoorigen " + ;
 							"from valesasist, pacientes, coberturas, presinsuvas, " + ;
 									"servicios, entidades" + ;
 							"where  valesasist = pia_valesasist and " + ;
 								"VAL_codadmision = PAC_codadmision and " + ;
 								"pacientes.pacientes = COB_pacientes and " + ;
 								"COB_entidad = ENT_codent and " + ;
 								"VAL_codservvale = ser_codserv and "  + ;
 								"VAL_fechasolicitud >= ?mfecdes and " + ;
 								"VAL_fechasolicitud <= ?mfechas  " + ;
       							"&mbusco " + ;
       						"group by VAL_codservvale, COB_entidad " + ;
 							"order by ENT_descripent, ser_descripserv,  " , "mwktotval")
 							
 	
 	msql_tot = "select * from mwktotval order by ENT_descripent into cursor mwktotval1"
 				 						
