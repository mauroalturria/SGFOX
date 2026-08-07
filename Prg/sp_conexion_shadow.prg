****
**** Armo la Conexion a la base del otro superambito
****
Lparameters miexe
miversion = "Sistemas"
mvarch = ''
miexe = Alltrim(Iif(Type('miexe') <> "C", "Sistemas", miexe))
mcon1 = 0
nalerta = 0
lcstringconn = ''
SELECT mwkambitoini
 
Do buscoini With Upper(miexe)
If myip='172.16.1.7'
	Messagebox(miexe+"-"+lcstringconn)
Endif
If nalerta <= 1
	mcon1 = 0
	nreintenta = 1
	nloop = 1
	lsigue = 6
	Do While nreintenta<4 .And. mcon1<=0
		If  .Not. Empty(lcstringconn)
			mcon1 = Sqlstringconnect(lcstringconn)
		Else
*mcon1 = SQLConnect('Conec01', '_SYSTEM', 'SYS')
			mcon1 = SQLConnect('Conec01', 'cacheapp', 'KaxHe025')
		Endif
		If mcon1 < 0
			Messagebox("Conexion :" + Alltrim(Left(lcstringconn, 72)) + " Nº de Reintento... " + Transform(nloop))
			= Aerror(eros)
			tiempo = Seconds()
			If eros(1) <> 1526
				Messagebox("Error " + Transform(eros(1)) + " - " + eros(3))
				Do prg_cancelo
			Else
				nloop = nloop + 1
				nreintenta = nreintenta + 1
			Endif
			Do buscoini With Upper(miexe)
		Endif
	Enddo
	If mcon1 < 0
		Messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
		Cancel
	Else

		mret = SQLExec(mcon1, "select * from server", "mwkserver1")


		If mret > 0
			Select mwkserver1
			Goto Top
			mclientname = mwkserver1.clientname
			mdevice = miversion
			mipaddress = mwkserver1.ipaddress
			mmemoria = mwkserver1.memoria
			mdevice = mwkserver1.Device
			mname = mwkserver1.Name
			mprocessid = mwkserver1.ProcessID
			mclientname = Iif(Empty(mclientname), Left(Sys(0), At("#", Sys(0)) - 1), mclientname)
			mname = Iif(Empty(mname), Substr(Sys(0), At("#", Sys(0)) + 1), mname)
			mfechas = sp_busco_fecha_serv('DT')
			mpant = _Screen.Width
			mprg = "sp_conexion2"
			If Used("mwkusuario")
				mcodvax	= mwkusuario.codigovax
			Else
				mcodvax	= 0
			Endif

*!*					mret = SQLExec(mcon1, "insert into TabCtrlServer (TCS_ClientName,TCS_Device" +;
*!*						",TCS_Estado,TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId" + ;
*!*						",TCS_Usuario,TCS_program)" + ;
*!*						" values  (?mClientName,?mDevice,?mpant,?mfechas,?mIPaddress,?mMemoria,?mName" + ;
*!*						",?mProcessId, ?mcodvax,?mprg)")
			Wait Clear
			Select 0
			Return (1)

		Endif
	Endif
Else
	Cancel
	Return (0)

Endif
Endproc
**
*-eof
