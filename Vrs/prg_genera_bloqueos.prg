**
**

*mcon1= SQLCONNECT('Conec02','_system','sys')

mfecha  = ctod('01/01/1900')
mfecha1 = DATE()

*mret = sqlexec(mcon1, 'select id, bloquedesde, bloquehasta from prestadores ' + ;
*					'where bloquedesde > ?mfecha and bloquehasta > ?mfecha1' ) 

do while !eof('sqlresult')
	mcm = sqlresult.id
	mfd = sqlresult.bloquedesde
	mfh = sqlresult.bloquehasta
	mfg = datetime()
	
	mret = sqlexec(mcon1, "select * from franjahoraria where codmed = ?mcm ", "mwkblq")
								
	do while !eof('mwkblq')
		
		mif = mwkblq.id	
		mds = mwkblq.diasem
		mus = 'ASAUL'
		
		mret = sqlexec(mcon1, 'insert into tabbloqueos values(?mcm, 0, ?mds, ?mfd, ?mfg, ?mfh, ?mif, ?mus)')
		
		skip 1 in mwkblq
	enddo	
	skip 1 in sqlresult
enddo 						