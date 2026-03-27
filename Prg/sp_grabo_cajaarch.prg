*********************************************************************************
* actualizo caja  en tabhciarchivo
*********************************************************************************
lparameters mid,mhca_orden

SELECT mwkPasarCaja2
SCAN 
 IF elegido = 1
	mid1 = IDARCH
	mret = sqlexec(mcon1,"update TabHciarchivo set hca_orden = ?mhca_orden where id = ?mid1" )
 ENDIF 	
ENDSCAN 
						   
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF  