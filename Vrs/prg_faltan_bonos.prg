********************************
***** Pasaje a Historicos
***** 29/07/2004
********************************
parameters fecha1, fecha2
do sp_conexion
fecha2 = ctod("30/08/2004")
mret=sqlexec(mcon1,'SELECT * FROM tabbonorec WHERE fecha <?fecha2 ' +;
				   'ORDER BY fecha,tipobono, nrodesde','MWKBonRec')
	
sele MWKBonRec
go top
ncampbr = afields(acambr)
cvar = ""
cdat = ""
cvarbr = ""
cdatbr = ""
for i=2 to ncampbr
	cvarbr = cvarbr + alltrim(acambr(i,1))+ ","
	cdatbr = cdatbr + "?m"+alltrim(acambr(i,1))+ ","
next i
cvarbr = left(cvarbr ,len(cvarbr )-1)
cdatbr = left(cdatbr ,len(cdatbr )-1)

scan
	sele MWKBonRec
	midbr = id
	for i=1 to ncampbr
		cmdat = "m"+alltrim(acambr(i,1))
		&cmdat = &acambr(i,1)
	next i
	mret = sqlexec(mcon1," SELECT * FROM TabdetalleFac WHERE tipobono =?mtipobono "+;
				 " AND BonoDesde >= ?mNrodesde and BonoDesde <= ?mNroHasta "+;
				 " AND Bonohasta >= ?mNrodesde and Bonohasta <= ?mNroHasta "+;
				 " and id<1000000000 order by BonoDesde ","MWKVendido")
	nini = mNrodesde 
		
	todok = .t.
	select MWKVendido
	do 	while !eof() and todok and nini < mNroHasta
		if nini=BonoDesde
			nini=bonohasta + 1
			skip
			loop
		else
			todok = .f.
		endif
	enddo
	if reccount('MWKVendido')>0 and todok 
		set step on
		select MWKVendido
		if empty (cvar)
			ncamp = afields(acam)
			for i=2 to ncamp
				cvar = cvar + alltrim(acam(i,1))+ ","
				cdat = cdat + "?m"+alltrim(acam(i,1))+ ","
			next i
			cvar = left(cvar ,len(cvar )-1)
			cdat = left(cdat ,len(cdat )-1)
		endif
		scan
			mid = id
			for i=1 to ncamp
				cmdat = "m"+alltrim(acam(i,1))
				&cmdat = &acam(i,1)
			next i
			mret = sqlexec(mcon1," insert into tabDetalleFacHist (" + cvar + ") "+; 
						 " values (" + cdat + ")" )  
	
			if mret < 0
				=aerr(eros)					 
				messagebox(eros(3))
				messagebox('ERROR EN GENERACION DE TABLA, AVISAR A SISTEMAS',64,'Validacion')
				mret = 0
				cancel
			else
				mret =sqlexec (mcon1,"DELETE FROM tabDetalleFac " +;
					 	" Where id = ?mid ")		
			endif
		endscan
		mret = sqlexec(mcon1," insert into tabBonoRecHist (" + cvarbr + ") "+; 
			 " values (" + cdatbr + ")" )  
		if mret < 0
			=aerr(eros)					 
			messagebox(eros(3))
		else
			mret =sqlexec (mcon1,"DELETE FROM tabBonoRec " +;
				 	" Where id = ?midbr ")		
		endif
	
	endif	
endscan
=sqldiscon(mcon1)	
 