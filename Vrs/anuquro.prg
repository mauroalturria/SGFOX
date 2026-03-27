select TABPqQUIRO
go top
mquiro = PQQ_quirofano
mfecha = PQQ_fecha
mturno = PQQ_turno
mserv = PQQ_servicio
mcant  =0

do while !eof()
	mcant  = mcant  +1
	skip 1
	if mcant > 6
		do while 	mquiro = PQQ_quirofano and 	mfecha = PQQ_fecha;
				and mturno = PQQ_turno and 	mserv = PQQ_servicio and  !eof()
			if pqq_referencia = 0
				replace pqq_referencia with 999
			endif
			skip 1
		enddo
		mquiro = PQQ_quirofano
		mfecha = PQQ_fecha
		mturno = PQQ_turno
		mserv = PQQ_servicio
		mcant  =0
	else
		loop
	endif
enddo
