select vista1
scan
	mdes = Descripcion
	mabr = abrevio 	
	mret = sqlexec(mcon3, "insert into TabTipoBono(Descripcion,abrevio ) values (?mdes,?mabr)")
endscan
