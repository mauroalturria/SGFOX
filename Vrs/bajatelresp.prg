select tabregtel
go top

mireg = trt_registracio
skip
do while !eof()
	do while !eof()and mireg = trt_registracio
		replace trt_pasiva with ctod("01/04/2019")
		skip
	enddo
	mireg = trt_registracio
	skip
enddo
