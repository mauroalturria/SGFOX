**************************
*AUTOR :CLaudia Antoniow
*FECHA :31/12/2003
*MODIF :31/12/2003
*****************************************
*Imprime comprobante asignacion de bonos
*****************************************

parameter vr_cond, vr_cursor, vr_reporte


mret = sqlexec(mcon1," SELECT * FROM TabbonoAsig " + vr_condicion + '", "'+ vr_cursor + '"' )

if mret < 0
	messagebox('ERROR EN EL CURSOR, AVISAR A SISTEMAS',16,'VALIDACION')
	mret = 0
else
	sele &vr_cursor
	go top
	report form &vr_reporte to printer noconsole
			
endif