****
**** Armo la Conexion a la base del otro superambito
****
Lparameters miexe
miversion = "Sistemas"
mvarch = ''
miexe = Alltrim(Iif(Type('miexe') <> "C", "Sistemas", miexe))
mcon3 = 0
nalerta = 0
lnoexe = .F.
lcstringconn = ''
Do buscoini With Upper(miexe)
If lnoexe
	Messagebox("Disculpe, no hay conexion para otros ambitos",64,"Alerta")
	Return (0)
Else
	If nalerta <= 1
		mcon3 = 0
		nreintenta = 1
		nloop = 1
		lsigue = 6
		Do While nreintenta<4 .And. mcon3<=0
			If  .Not. Empty(lcstringconn)
				mcon3 = Sqlstringconnect(lcstringconn)
			Else
				*mcon3 = SQLConnect('Conec01', '_SYSTEM', 'SYS')
				mcon3 = SQLConnect('Conec01', 'cacheapp', 'KaxHe025')
			Endif
			If mcon3 < 0
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
		If mcon3 < 0
			Messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
			Cancel
		ELSE
				If mxambito>1
			If File('c:\tempdoc\usuario.txt')
				mnombre = Filetostr('c:\tempdoc\usuario.txt')
			Else
				mnombre = Sys(0)
			Endif
			Create  Cursor mwkserver2 (Id N(10),CLIENTNAME  c(25),Device c(50), ;
				IPADDRESS c(16),MEMORIA N(10),Name c(40),ProcessID c(10),dummy c (50))
			Insert Into mwkserver2 (Id,CLIENTNAME,Device, ;
				IPADDRESS ,MEMORIA  ,Name  ,ProcessID ,dummy  );
				VALUES (1,'BRISTOL','|TCP|1972|7948',myip,16670080,mnombre ,'666','HOLA')
				mret = 1
		 
		Else
			mret = SQLExec(mcon3, "select * from server", "mwkserver2")
		Endif
			
			If mret > 0
				Select mwkserver2
				Goto Top
				mclientname = mwkserver2.clientname
				mdevice = miversion
				mipaddress = mwkserver2.ipaddress
				mmemoria = mwkserver2.memoria
				mdevice = mwkserver2.Device
				mname = mwkserver2.Name
				mprocessid = mwkserver2.ProcessID
				mclientname = Iif(Empty(mclientname), Left(Sys(0), At("#", Sys(0)) - 1), mclientname)
				mname = Iif(Empty(mname), Substr(Sys(0), At("#", Sys(0)) + 1), mname)
				mfechas = sp_busco_fecha_serv('DT', .T.)
				mpant = _Screen.Width
				mprg = "sp_conexion2"
				If Used("mwkusuario")
					mcodvax	= mwkusuario.codigovax
				Else
					mcodvax	= 0
				Endif

				mret = SQLExec(mcon3, "insert into TabCtrlServer (TCS_ClientName,TCS_Device" +;
					",TCS_Estado,TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId" + ;
					",TCS_Usuario,TCS_program)" + ;
					" values  (?mClientName,?mDevice,?mpant,?mfechas,?mIPaddress,?mMemoria,?mName" + ;
					",?mProcessId, ?mcodvax,?mprg)")
				Wait Clear
				Select 0
				Return (1)

			Endif
		Endif
	Else
		Cancel
		Return (0)

	Endif
Endif
Endproc
**
*-eof
