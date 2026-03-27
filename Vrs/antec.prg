select vista2
id>343
set step on
do while !eof()
	mirec = recno()
	if at_registracio>1
		mid = id
		select * from vista2 where id = mid into cursor dato
		select vista2
		append from dbf('dato') 
	endif
	select vista2
	go mirec
	replace at_registracio with 1
	skip 1
enddo