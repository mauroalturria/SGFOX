select servi
go top
do while !eof()
	if isnull(ser_codserv)
		skip
		
	endif
	mimed = codprof
	miesp = codiesp
	miserv = ser_codserv
	lexiste = .f.
	do while !eof() and mimed = codprof and miesp = codiesp
		select vista13
		locate for 	codprof=mimed and codserv = miserv
		if !eof()
			lexiste = .t.
		endif
		select servi
		skip
	enddo
	if !lexiste
		insert into vista13 (codprof,codserv) values (mimed,miserv)
	endif
enddo
