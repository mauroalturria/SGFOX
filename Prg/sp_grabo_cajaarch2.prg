*********************************************************************************
* actualizo caja  en tabhciarchivo
*********************************************************************************
lparameters mid,mhca_orden

SELECT mwkPasarCajaxx
SCAN 
	mid1 = IDARCH
	mhca_registrac = hca_registrac
	mret = sqlexec(mcon1,"update TabHciarchivo set hca_orden = ?mhca_orden where id = ?mid1" )
	DELETE from mwkPasarCajaxBackUpBiz where hca_registrac = mhca_registrac
ENDSCAN 
						   
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ELSE
  MESSAGEBOX("SE ACTUALIZO CORRECTAMENTE",48,"CONFIRMACION")
ENDIF 