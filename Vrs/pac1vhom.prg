public mfd,mfh
mfd = date()
select afiturno
go top
*set step on
cantafi = 0
scan
	miafi = afiturno.afiliado
	requery('vales_real')
	select afiturno
	if reccount('vales_real')= 0
		replace codprest with 0 
	endif
endscan
messagebox(transf(cantafi))