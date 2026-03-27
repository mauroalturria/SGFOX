select * from infolog where fechainforme <ctod("01/01/2007") group by idinforme,nroprotocolo into cursor info
select info
scan
	mid = idinforme	
	mecha = ttod(fechalog)
	update informes set fechainforme = mecha where id = mid
	select info
	
endscan

