***
*** Busqueda de llamadas
***
public mconc
do sp_conexion
do sp_conexion_central

	mfecha = date()-10
	mret = sqlexec(mcon1 ,"SELECT ID,fecha,nroid FROM TabCentralI "+;
				" where id<1000000 order by fecha desc " ,"indice")
	
	mid = 6465452
	mfechai = nvl(indice.fecha,ctod("01/01/1900"))
	mret = sqlexec(mconc ,"SELECT * FROM captura WHERE id>?mid and telefono >'0' ","control")
	if mret < 0
		=aerr(eros)
		MESSAGEBOX(eros(3))
	endif
	do while !eof()
		mid = id
		cfecha = LEFT(fecha_captura,11)
		dia=left(cfecha,2)
		aniohora= substr(cfecha,8,4)
		cmes =	lower(substr(cfecha,4,3))
		mes = iif(cmes = 'jan','01',iif(cmes = 'feb','02',iif(cmes = 'mar','03',iif(cmes = 'apr','04',;
		iif(cmes = 'may','05',iif(cmes = 'jun','06',iif(cmes = 'jul','07',iif(cmes = 'aug','08',;
		iif(cmes = 'sep','09',iif(cmes = 'oct','10',iif(cmes = 'nov','11',iif(cmes = 'dec','12','08'))))))))))))
		mfecha = ctoD(dia +'/'+ mes +'/'+ aniohora)
		
		do while cfecha = LEFT(fecha_captura,11) and !eof()
			skip
		enddo
		if mfecha > mfechai
			mret = sqlexec(mcon1 ,"insert into TabCentralI (fecha,nroid ) values (?mfecha,?mid)")
			if mret < 0
				=aerr(eros)
				MESSAGEBOX(eros(3))
			endif
		endif
	enddo
=sqldiscon(mcon1)
=sqldiscon(mconc)
