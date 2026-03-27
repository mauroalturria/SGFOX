***
*** informacion de Logoff
***
dimen mima[1]
local cfiles,ncantfiles ,i ,cfil
maidusu	= sys(0)
msector	= sys(0)
maexe	= "NADA"

if used('mwkusuario')
	select mwkusuario
	scatter memvar
	if vartype(m.sector) = "C"
		msector = mwkusuario.sector
	endif
	maidusu	= mwkusuario.idusuario
	maexe	= mwkexe.nomexe
endif

if directory("U:\interfaz\destinos")
	do prg_desconecta_red with "U:"
endif
if directory("U:\interfaz\destinos")
	do prg_desconecta_red with "U:",1
endif

if !used("mwkserver1") or mcon1=0
	do sp_conexion
	if !used("mwkserver1")
		cancel
	endif
endif

mahora	= sp_busco_fecha_serv('DT')
ldfechoy = sp_busco_fecha_serv('DD')

mret = SQLExec(mcon1, "insert into TabAcceso (TA_Exe,TA_Fechora,TA_Tipo,TA_Usuario)" +;
	" values (?maexe, ?mahora, 2, ?maidusu )" )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	cancel
endif

if left(msector,4) = "CALL" and mwkexe.nomexe ="TURNOS"
	maidusu		= iif(used('mwkusuario'),mwkusuario.codigovax,0)
	mhoranul 	= ctot("01/01/1900")
	mahora		= sp_busco_fecha_serv('DT')
	mipc =  SYS(0)
mipc = left(left(mipc,at("#",mipc)-1)+STRTRAN(myip,'172.16.',''),50)
	mret = SQLExec(mcon1, "select id from TabAccesoInt "+;
		" where IPpuesto = ?mipc and Interno = ?mintcall and Usuario =?maidusu and "+;
		" HoraHasta = ?mhoranul order by HoraDesde desc","mwkcontrol")
	if reccount("mwkcontrol")>0
		mid = mwkcontrol.id
		mret = SQLExec(mcon1, "update TabAccesoInt set HoraHasta = ?mahora where id = ?mid " )
	endif
endif
do sp_desconexion with "Logoff"
if directory('c:\tmp')
	cfiles = 'c:\tmp\*.*'
	ncantfiles = adir(mima,cfiles)

	lcErrorAnt = on("ERROR")

	on error =aerr(eros)
	for i=1 to ncantfiles
		cfil = 'c:\tmp\' + mima(i,1)
		delete file (cfil )
	endfor
	on error &lcErrorAnt
endif
if directory('c:\temp\guardia')
	cfiles = 'c:\temp\guardia\*.*'
	ncantfiles = adir(mima,cfiles)
	lcErrorAnt = on("ERROR")
	on error =aerr(eros)
	for i=1 to ncantfiles
		mfechor = ctot(dtoc( mima(i,3))+" "+mima(i,4))
		if mwkfecserv.fechahora - mfechor > 24 * 3600 *7

			cfil = 'c:\temp\guardia\' + mima(i,1)
			delete file (cfil )
		endif
	endfor
	on error &lcErrorAnt
endif
if directory('c:\temp\ambula')
	if !directory("C:\ambutemp")
		mkdir "C:\ambutemp"
	endif
	cfiles = 'c:\temp\ambula\*.*'
	ncantfiles = adir(mima,cfiles)
	for i=1 to ncantfiles
		mfechor = ctot(dtoc( mima(i,3))+" "+mima(i,4))
		if mwkfecserv.fechahora - mfechor > 24 * 3600 * 20
			on error =aerr(eros)
			cfil = 'c:\temp\ambula\' + mima(i,1)
			nuevonom = "C:\ambutemp\"+ mima(i,1)
			cc = cfil +" to " +nuevonom
*!*				messagebox("Ejecuto:" + cc)
			copy file &cc
			delete file (cfil )
			on error 			&& devuelve el control del error al sistema
		endif
	endfor
endif

if directory('c:\temp')
	cfiles = 'c:\temp\*.*'
	ncantfiles = adir(mima,cfiles)
	lcErrorAnt = on("ERROR")
	on error =aerr(eros)
	for i=1 to ncantfiles
		cfil = 'c:\temp\' + mima(i,1)
		delete file (cfil )
	endfor
	on error &lcErrorAnt
endif
if directory('C:\temp\informes')
	cfiles = 'C:\temp\informes\*.*'
	adir(mima,cfiles)
	ncantfiles = alen(mima,1)
	lcErrorAnt = on("ERROR")
	on error =aerr(eros)
	for i=1 to ncantfiles
		cfil = 'C:\temp\informes\'  + mima(i,1)
		delete file (cfil )
	endfor
	on error &lcErrorAnt
endif
*!*	if directory('C:\temp\imagenes')
*!*		cfiles = 'C:\temp\imagenes\*.*'
*!*		adir(mima,cfiles)
*!*		ncantfiles = alen(mima,1)
*!*		lcErrorAnt = ON("ERROR")
*!*		on error =aerr(eros)
*!*		for i=1 to ncantfiles
*!*			cfil = 'C:\temp\imagenes\'  + mima(i,1)
*!*			delete file (cfil )
*!*		Endfor
*!*		On Error &lcErrorAnt
*!*	endif
if directory('C:\temp\interna')
	if !deletefolder('C:\temp\interna\',ldfechoy)
		on error &lcErrorAnt
	endif
endif
