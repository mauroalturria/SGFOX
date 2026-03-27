dime datito(7)
select datos
store '' to datito
scan
	mrespdet = datos.dato
	mnroitem = 0
	for i= 1 to 6
		mcontad  = atc("|", mrespdet)
		datito(i)= left( mrespdet, mcontad - 1  )
		mrespdet = substr( mrespdet, mcontad + 1 )
	next i
	datito(7)= mrespdet
	insert into historias values (datito(1),val(datito(2)),datito(3),datito(4);
		,datito(5),datito(6),datito(7))
endscan
