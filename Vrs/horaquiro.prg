select TABPQQUIRO
do while !eof()
	mdia = PQQ_fecha
	mtur = PQQ_turno
	mqui = PQQ_quirofano
	mihora = iif( mtur = 1,800,iif( mtur = 2,1400,2100))
	do while !eof() and mdia = PQQ_fecha and mtur = PQQ_turno and mqui = PQQ_quirofano
		replace PQQ_hora with mihora
		skip
		mihora  = mihora +100
	enddo
enddo
go top
