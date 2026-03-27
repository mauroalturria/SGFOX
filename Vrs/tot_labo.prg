****
** busco totales por vales para rendimiento
****
public mcon3,mfecdes
mcon3 = sqlconnect('CONEC02','_system','sys')

mfecdes = ctod("29/01/2006")
mfechas = ctod("01/02/2006")
march = "A" + dtos(mfecdes )
		
mret = sqlexec(mcon3, "select count (VAL_codadmision) as cant,COB_codentidad "+;
					"from valesasist "+;
					" left join coberturas on VAL_codadmision = COB_pacientes "+;
					" where val_codservvale = 7000 "+;
					" and val_fechasolicitud >= ?mfecdes  and val_fechasolicitud < ?mfechas "+;
					" GROUP BY COB_codentidad",march ) 

IF MRET<1 
	=aerr(eros)
	messagebox(eros(3))
endif
browse