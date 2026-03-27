public mfd,mfh
mfd = date()
select afiturno
go top
cantafi = 0
scan
	miafi = afiturno.afiliado
	requery('turnoidafi')
	select afiturno
	if reccount('turnoidafi')= 0
		requery('vales_real')
		select afiturno
		if reccount('vales_real')= 0
			replace codprest with 0 
		endif
	endif
endscan
messagebox(transf(cantafi))