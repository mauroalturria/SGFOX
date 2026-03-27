***
*** Busqueda de llamadas
***
lparameters mfdes, mfhas, mcinterno 
	mfechad = ttod(mfdes)
	mret = sqlexec(mcon1 ,"SELECT ID,fecha,nroid FROM TabCentralI "+;
				" where fecha=?mfechad and id<1000000 " ,"indice")
	if reccount("indice")<1
		mfechad = ttod(mfdes)-30
		mret = sqlexec(mcon1 ,"SELECT ID,fecha,nroid FROM TabCentralI "+;
					" where fecha>=?mfechad and id<1000000 order by fecha desc " ,"indice")
	endif
	middes = nvl(indice.nroid,0)
	cmid  =  " id>?middes and "

	mfechad = ttod(mfhas)
	mret = sqlexec(mcon1 ,"SELECT ID,fecha,nroid FROM TabCentralI "+;
				" where fecha>?mfechad and id<1000000 " ,"indice")
	if reccount("indice")>1
		midhas = nvl(indice.nroid,0)
		cmid  =  cmid  + " id<?midhas and "
	endif

	mret = sqlexec(mconc ,"SELECT * FROM captura where &cmid telefono >'0' "+;
		" and troncal>'0' " + mcinterno ,"control")
**codigo='0' and 		
	if mret < 0
		=aerr(eros)
		MESSAGEBOX(eros(3))
	endif
	select fecha(fecha_captura) as fecha_captura;
		,left(horafin_duracion,2)+":"+substr(horafin_duracion,3,2) as horafin;
		,right(horafin_duracion,5) as minutos,troncal,telefono, interno,campo5, campo6 ;
		from control having fecha(fecha_captura)  >=mfdes and fecha(fecha_captura)<= mfhas into cursor mwkllamadas
		
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