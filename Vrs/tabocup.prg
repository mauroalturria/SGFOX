mifecha = ctod("14/04/2010")
i = 1
set step on
for i = 1 to 100
	mihora = 1000
	qfecha = mifecha + i
	if qfecha = date()-1
		exit
	endif
	select * from histocup where fecha = qfecha and hora = mihora into cursor controla
	if reccount('controla') = 0
		update ocup set fecha = qfecha
		select histocup
		append from ocup for  hora = mihora
	endif
	mihora = 1600
	select * from histocup where fecha = qfecha and hora = mihora into cursor controla
	if reccount('controla') = 0
		update ocup set fecha = qfecha
		select histocup
		append from ocup for  hora = mihora
	endif

next
