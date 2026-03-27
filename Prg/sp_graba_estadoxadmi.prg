*********************************************************************************
* actualizo caja  en tabhciarchivo
*********************************************************************************
lparameters mhca_orden,madmision

SELECT mwkPasarCaja2
	mid1 = IDARCH
	mret = sqlexec(mcon1,"update TabHciarchivo set hca_orden = ?mhca_orden where hci_nroadm = ?madmision" )

						   
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ELSE
  MESSAGEBOX("SE ACTUALIZO CORRECTAMENTE",48,"CONFIRMACION")
ENDIF 