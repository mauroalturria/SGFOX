* actualizo un regitro (caja)  en tabhciarchivo
lparameters mid,mhca_orden


	mret = sqlexec(mcon1,"update TabHciarchivo set hca_orden = ?mhca_orden where id = ?mid" )

						   
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF 