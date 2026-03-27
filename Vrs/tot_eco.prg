****
** busco totales por vales para rendimiento
****
public mcon3,mfecdes
	do sp_conexion_tablas


mfecdes = ctod("01/01/2001")
for i=11 to 12
	mfechas = ctod("01/"+transf(i,"@L 99")+"/2003")
	mfecdes = ctod("01/12/2000")
	mfechas = ctod("01/01/2001")

	march = "A" + dtos(mfecdes )
		
	mret = sqlexec(mcon3, "select count (*) as cant "+;
					"from valesasist where val_codservvale = 7400 "+;
					" and val_fechasolicitud >= ?mfecdes  and val_fechasolicitud < ?mfechas "+;
					"",march ) 
	WAIT WINDOWS MARCH NOWAIT
*	browse last
	mfecdes = mfechas	
next i 				 						
 	=sqldisconnect(mcon3)						