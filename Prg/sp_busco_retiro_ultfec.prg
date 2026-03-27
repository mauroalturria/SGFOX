****
**  Busco Tiempo de las prestaciones
*!*	Necesario :
*!*	item_vale 
*!*	dat_vale
****

parameter nroitem

Local mAux
mAux = 0

for f = 1 to nroitem

	mprest = item_vale(f,1)
	mret = sqlexec(mcon1, 'select PRE_retiroestudios from PRESTACIONS '+;
		' where PRE_codprest = ?mprest ', 'mwkPrest_f')

	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
		do prg_cancelo
	endif
		
	If mwkPrest_f.PRE_retiroestudios > mAux     
		mAux = mwkPrest_f.PRE_retiroestudios
	Endif 	
	Use In mwkPrest_f
next 
If mAux > 0
	mvalretest = prg_calcula_diahabil(ctod(dat_vale(4)),mAux,"1,7") && retorna el dia sin sabados, domingos y feriados 
Endif 	


