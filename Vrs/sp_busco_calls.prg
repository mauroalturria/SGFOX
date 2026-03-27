***
*** Busqueda de llamadas
***
*!*	public mconc 
*!*	do sp_conexion_central
*!*	mfecha = date()-5

mret = sqlexec(mconc ,"SELECT * FROM captura where id >= 7869709 and id <= 7870212","control")
set step on
	if mret < 0
		=aerr(eros)
		MESSAGEBOX(eros(3))
	endif
	scan
		mid = id
		mfecha = "25 Jun 2007 "+transf(val(left(alltrim(horafin_duracion),4)),"99:99")+":00"
		mret = sqlexec(mconc ,"update captura set fecha_captura= ?mfecha where id=?mid")
	endscan
set step on	
	select id,fecha(fecha_captura) as fecha_captura;
		,left(horafin_duracion,2)+":"+substr(horafin_duracion,3,2) as horafin;
		,right(horafin_duracion,5) as minutos,troncal,telefono, interno,campo5, campo6 ;
		from control having fecha(fecha_captura)  >=mfecha into cursor mwkllamadas
=sqldiscon(mconc)		
FUNCTION fecha(cfecha)
	local dia,mes,aniohora
	dia=left(cfecha,2)
	aniohora= substr(cfecha,8)
	cmes =	lower(substr(cfecha,4,3))
	mes = iif(cmes = 'jan','01',iif(cmes = 'feb','02',iif(cmes = 'mar','03',iif(cmes = 'apr','04',;
	iif(cmes = 'may','05',iif(cmes = 'jun','06',iif(cmes = 'jul','07',iif(cmes = 'aug','08',;
	iif(cmes = 'sep','09',iif(cmes = 'oct','10',iif(cmes = 'nov','11',iif(cmes = 'dec','12','08'))))))))))))
	
	RETURN ctot(dia +'/'+ mes +'/'+ aniohora)
ENDFUNC

