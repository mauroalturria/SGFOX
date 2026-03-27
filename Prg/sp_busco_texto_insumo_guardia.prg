****
** Pedido de insumos  pro descripcion  -  Vales Insumo en Guardia
****

parameters mctexto

mfecpas = ctod('01/01/1900')
if vartype(mctexto)="C"
	mret = sqlexec(mcon1,"select INS_descriinsumo, INS_codinsumo, INS_grupo, insumos.insumos, INS_CODPUNTERO " + ;
 							"from insumos, guardiainsumos " + ;
 							"where fechapasiva = ?mfecpas and INS_fechapasivo is null and " + ; 
 								"guardiainsumos.codinsumo = insumos.insumos and " + ;
 								"INS_descriinsumo LIKE '%&mctexto%' " + ;
							"order by INS_descriinsumo", "mwkbustexto")
else
	mret = sqlexec(mcon1,"select INS_descriinsumo, INS_codinsumo, INS_grupo, insumos.insumos, INS_CODPUNTERO " + ;
 							"from insumos, guardiainsumos " + ;
 							"where fechapasiva = ?mfecpas and INS_fechapasivo is null and " + ; 
 								"guardiainsumos.codinsumo = insumos.insumos " + ;
							"order by INS_descriinsumo", "mwkbustexto")
endif						
					
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "Err buscotextoinsumo"
	CANCEL
endif	