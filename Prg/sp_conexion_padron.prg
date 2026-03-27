****
**** Armo la Conexion a la base
****
lparameters miexe
if used('mwkexe')
	miexe = mwkexe.nomexe
else
	miexe = iif(type('miexe')#"C","Sistema",miexe)
endif
mcon4= 0
nalerta = 0
lcStringConn = ''
*messagebox(lcStringConn)
if nalerta <=1
	mcon4= 0
	nreintenta = 1
	nloop = 1
	lsigue = 6
*	do while lsigue=6 and  mcon4<=0
	do while nreintenta < 4 and  mcon4<=0
		mcon4= sqlconnect('informes','_system','sys')
		if mcon4 < 0
			wait windows "Nº de Reintento... "+transf(nloop) nowait
			=aerr(eros)
			tiempo = seconds()
			if eros(1)#1526
				messagebox("Error "+ transf(eros(1))+" - "+ eros(3))
				do prg_cancelo
			else
				nloop = nloop +1
				nreintenta = nreintenta +1
			endif
			do buscoini
		endif
	enddo
	if mcon4 < 0
		messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
		cancel
	endif
else
	cancel
endif

