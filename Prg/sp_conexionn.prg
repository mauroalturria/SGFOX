****
**** Armo la Conexion a la base
****
mcon1= 0
nalerta = 0
lcStringConn = ''
mServer 	= "SERVER=" + alltrim(mwkcfgini.TCI_server)
mDatabase 	= "DATABASE=" + alltrim(mwkcfgini.TCI_namespace)
mPort 		= "PORT=" + alltrim(mwkcfgini.TCI_PORT)
lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
	";" + mServer + ;
	";" + mDatabase + ;
	";Uid=_system" +;
	";Pwd=sys"

mNameSpaces = alltrim(mwkcfgini.TCI_NAMESPACE)
coleserver  = alltrim(mwkcfgini.TCI_OLEserver)
if !empty('mNameSpaces') and used('mwktabcfg')
	select mwktabcfg
	go top
	replace olespaces with mNameSpaces
	if !empty(coleserver)
		replace oleserver with coleserver
	endif
endif

mcon1= 0
nreintenta = 1
nloop = 1
lsigue = 6
*	do while lsigue=6 and  mcon1<=0
do while nreintenta < 4 and  mcon1<=0
	if !empty(lcStringConn)
		mcon1  = sqlstringconnect(lcStringConn)
	else
		mcon1= sqlconnect('Conec01','_system','sys')
	endif
*!*			if mcon1 < 0
*!*				mcon1= sqlconnect('Conec01','_system','sys')
*!*			endif
	if mcon1 < 0
		messagebox("Conexion :"+alltrim(left(lcStringConn,72))+" Nº de Reintento... "+transf(nloop) )
*			wait windows "Nº de Reintento... "+transf(nloop) nowait
		=aerr(eros)
		tiempo = seconds()
		if eros(1)#1526
			messagebox("Error "+ transf(eros(1))+" - "+ eros(3))
			do prg_cancelo
		else
			nloop = nloop +1
			nreintenta = nreintenta +1
		endif
*	do buscoini with upper(miexe)
	endif
enddo

if mcon1 < 0
	messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
	cancel
else
	mret = sqlexec(mcon1,"select * from server","mwkserver1")
	if mret>0
		mClientName	= mwkserver1.ClientName
		mDevice		= miexe  	&&mwkserver1.device
		mIPaddress	= mwkserver1.IPaddress
		mMemoria	= mwkserver1.Memoria
		mName 		= mwkserver1.name
		mProcessId	= mwkserver1.processid
		mClientName	= iif(empty(mClientName),left(sys(0),at("#",sys(0))-1),mClientName)
		mName 		= iif(empty(mName ),substr(sys(0),at("#",sys(0))+1),mName )
		modify windows screen ;
			title proper(miexe)+"      P.Id:" + mwkserver1.processid
		if used("mwkusuario")
			mcodvax	= mwkusuario.codigovax
		else
			mcodvax	= 0
		endif
		mfechas		= sp_busco_fecha_serv('DT')
		mprg 		= "CB_conexion"
		mret = sqlexec(mcon1,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
			",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program)"+;
			" values  (?mClientName,?mDevice,0,?mfechas,?mIPaddress,?mMemoria,?mName"+;
			",?mProcessId, ?mcodvax,?mprg)")
		mret = sqlexec(mcon1,"select * from TabCtrlServer where TCS_ClientName = ?mClientName and "+;
			"TCS_IPaddress = ?mIPaddress and TCS_Fechah = ?mfechas and "+;
			"TCS_Name = ?mName and TCS_ProcessId = ?mProcessId and TCS_Usuario = ?mcodvax","mwkTCS")
		wait clear
		select 0
	endif
endif

