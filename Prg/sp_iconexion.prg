****
**** Armo la Conexion a la base
****
mcon1= 0

lcStringConn = ''
on error =aerr(eros)
mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
if at("EXE",mfile)=0
	mfile = "..\exe\inicio\ini.txt"
endif	
*messagebox(mfile)
mcadcon = filetostr(mfile)
*messagebox(mcadcon )
on error
if type('mcadcon') = "C"
	mServer 	= alltrim(mline(mcadcon,1))
	mDatabase 	= alltrim(mline(mcadcon,2))
	lcStringConn="Driver={InterSystems ODBC};Port=1972"+;
		";" + mServer + ;
		";" + mDatabase + ;
		";Uid=_system" +;
		";Pwd=sys"
***Evitar que aparezca  la ventana de login
		SQLSETPROP(0,"DispLogin",3)
endif

*messagebox(lcStringConn)
mcon1= 0
nreintenta = 1
nloop = 1
lsigue = 6
do while lsigue=6 and  mcon1<=0
	do while nreintenta < 4 and  mcon1<=0
		if !empty(lcStringConn) 	
			mcon1  = SQLSTRINGCONNECT(lcStringConn)
		else
			mcon1= SQLCONNECT('Conec01','_system','sys')
		endif
		if mcon1 < 0
			wait windows "Nº de Reintento... "+transf(nloop) nowait
			=aerr(eros)
			tiempo = seconds()
			if eros(1)#1526
				MESSAGEBOX("Error "+ transf(eros(1))+" - "+ eros(3))
		   		do prg_cancelo
			else
				nloop = nloop +1
				nreintenta = nreintenta +1
			endif
		endif
	enddo
	if mcon1 < 0
		lsigue = messagebox("LA CONEXION ESTA OCUPADA. REINTENTA???",48+0+4,"Conexión")
		nreintenta = 1
	endif
enddo
if mcon1 < 0
	messagebox("ERROR DE CONEXION, AVISAR A SISTEMAS", 16, "Validación")
	if type('mcon1')="N"
		if mcon1>0
			=sqldiscon(mcon1)
		endif			
	endif			
	cancel
endif
wait clear