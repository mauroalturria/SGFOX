select valinfo
scan
	if pre_retiro>0
		mifec = prg_calcula_diahabil(val_fechas,pre_retiro ,"1,7") && retorna el dia sin sabados, domingos y feriados 
		select valinfo
		replace fecharecep with  mifec
	endif
endscan
