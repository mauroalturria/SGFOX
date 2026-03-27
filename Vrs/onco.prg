select turnoid
set step on
DO WHILE !EOF()
	ntur = turnoid.tao_idturnos-10000000
	nrese = val(turnoid.codreserva)
	newtur = turnoid.id1
	if ntur = nrese 
		mid = turnoid.TAO_idturnos
		requery('onco')
		update onco set TAO_idturnos = newtur 
	endif
	select turnoid
	skip
enddo		