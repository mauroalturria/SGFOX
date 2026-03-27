create cursor controlo(fecha D,dias n(1),servicio n(4),quiro n(2))
dias = date()
for i = 1 to 7
set step on
	diase = date() +i
	select * from tabpqfran where pqf_dia = dow(diase) into cursor diasem
	select di
	asem
	scan
		dia = diase
		for j= 1 to 30 step 7
			dia = dia +j-1
			miquiro =pqf_quirofano
			miserv = pqf_servicio
			midi= dow(dia)
			requery('tabpqquiro14')
			if reccount('tabpqquiro14')= 0
				insert into controlo (fecha,dias,servicio,quiro) values (dia,midi,miserv ,miquiro )
			endif
		next j
	endscan
next i
