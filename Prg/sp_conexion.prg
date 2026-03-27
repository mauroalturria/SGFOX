****
**** Armo la Conexion a la base
****
Lparameters miexe
miversion = "Sistemas"
mvarch = ''
mserver = ''
Agetfileversion(miverexe, Sys(16, 0))

If Used('mwkexe')
	miexe = Alltrim(mwkexe.nomexe)
	miversion = Alltrim(miexe)
	miexer = Justfname(Alltrim(mwkexe.launcher))
	If Vartype(miverexe) <> "U"
		If Alen(miverexe) > 1
			If Upper(miverexe(5)) = Upper(miexe)
				mvarch = "c:\qepd1a1\exe\" + miexer
			Else
				mvarch = "c:\qepd1a1\exe\" + miverexe(5)
			Endif
		Else
			mvarch = "c:\qepd1a1\exe\" + miexer
		Endif
	Else
		mvarch = "c:\qepd1a1\exe\" + miexer
	Endif
	nfiles = Agetfileversion(laver, mvarch)
Else
	miexe = Alltrim(Iif(Type('miexe') <> "C", "Sistemas", miexe))

	miversion = miexe
	mvarch = "c:\qepd1a1\exe\launcher.exe"
Endif
If Vartype(zzvolumen) = "U"
	Erase zzvolumen
	Public zzvolumen
Endif
mcon1 = 0
nalerta = 0
lcstringconn = ''
mserver = ''
Do buscoini With Upper(miexe)
zzvolumen = Iif(Substr(zzvolumen, 2,1) <> ':', "C:", zzvolumen)
antlcstringconn = lcstringconn
If myip='172.16.1.7'
* messagebox("Conexion 1  "+ lcstringconn)
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
			mserver = ''
			Do buscoini With Upper(miexe)
		Endif
	Enddo
	If mcon1 < 0
		Messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
		Cancel
	Else
		Do sp_busco_ambito_ini
		mserver = ''
		Do buscoini With Upper(miexe)
		If antlcstringconn <> lcstringconn
			If myip='172.16.7.4'
*				messagebox("des y Conex  "+ lcstringconn)
			Endif
*
			Do sp_desconexion
			mcon1 = Sqlstringconnect(lcstringconn)
		ENDIF

*!*			If mxambito>1
*!*				If File('c:\tempdoc\usuario.txt')
*!*					mnombre = Filetostr('c:\tempdoc\usuario.txt')
*!*				Else
*!*					mnombre = Sys(0)
*!*				Endif
*!*				Create  Cursor mwkserver1 (Id N(10),CLIENTNAME  c(25),Device c(50), ;
*!*					IPADDRESS c(16),MEMORIA N(10),Name c(40),ProcessID c(10),dummy c (50))
*!*				Insert Into mwkserver1 (Id,CLIENTNAME,Device, ;
*!*					IPADDRESS ,MEMORIA  ,Name  ,ProcessID ,dummy  );
*!*					VALUES (1,'BRISTOL','|TCP|1972|7948',myip,16670080,mnombre ,'666','HOLA')
*!*					mret = 1
*!*			 
*!*			Else
			mret = SQLExec(mcon1, "select * from server", "mwkserver1")
*!*			Endif
		If mret > 0
			Select mwkserver1
			Goto Top
			mclientname = mwkserver1.clientname
			mdevice = miversion
			mipaddress = mwkserver1.ipaddress
			If Vartype(miverexe) <> "U"
				If Alen(miverexe) > 1
					lcdirejecuta = Addbs(Sys(5) + Sys(2003))
					If File(lcdirejecuta + miverexe(8))
						mvarch = lcdirejecuta + miverexe(8)
					Else
						mvarch = "c:\qepd1a1\exe\" + miverexe(8)
					Endif
				Endif
			Endif
			mres = Agetfileversion(laver, mvarch)
			If mres > 0
				miversion = miversion + " " + Alltrim(laver(11))
				mmemoria = laver(4)
				mdevice = miversion
			Else
				mmemoria = mwkserver1.memoria
				mdevice = mwkserver1.Device
			Endif

			mdevice=Iif(At("TURNOS",Upper(mdevice))>0,"-"+mdevice,mdevice)
			mname = mwkserver1.Name
			mprocessid = mwkserver1.ProcessID
			mclientname = Iif(Empty(mclientname), Left(Sys(0), At("#", Sys(0)) - 1), mclientname)
			mname = Iif(Empty(mname), Substr(Sys(0), At("#", Sys(0)) + 1), mname)
			Modify Window Screen Title Proper(miexe) + "      P.Id:" + mwkserver1.ProcessID + ;
				"  Nro PC:  " + Substr(myip, At(".", myip, 2) + 1)
			mfechas = sp_busco_fecha_serv('DT')
			If Used("mwkusuario")
				mcodvax = mwkusuario.codigovax
				If Vartype(_Screen.oconf) == "O"
					Modify Window Screen Title Proper(miexe) + Space(6) + ;
						"P.Id: " + mwkserver1.ProcessID + Space(10) + ;
						"Nro PC: " + Substr(myip, At(".", myip, 2) + 1) + Space(10) + ;
						"Usuario : " + Alltrim(mwkusuario.idusuario) + Space(10) + ;
						"Versión Ejecutable : " + Alltrim(laver(11)) + Iif(mxambito > 2, Space(10) + ;
						"Policonsultorio : " + Alltrim(_Screen.oconf.getvalue("pNombre_Centro")), "")
				Else
					Modify Window Screen Title Proper(miexe) + Space(6) + ;
						"P.Id: " + mwkserver1.ProcessID + Space(10) + ;
						"Nro PC: " + Substr(myip, At(".", myip, 2) + 1) + Space(10) + ;
						"Usuario : " + Alltrim(mwkusuario.idusuario) + Space(10) + ;
						"Versión Ejecutable : " + Alltrim(laver(11))
				Endif

			Else
				Set Escape Off
				If  .Not. prg_ipsistemas()
					Do sp_busco_stprogram With 5, Ttod(mfechas)-15
					If Reccount("MwkStProg") = 0
						lcdirexe = "c:\qepd1a1\exe\"
						lcdirori = "x:\qepd1a1\exe\"
						lcarchi = "verifysoftleg.exe"
						If  .Not. File(lcdirexe + lcarchi)
							If File(lcdirori + lcarchi)
								Copy File (lcdirori + lcarchi) To (lcdirexe + lcarchi)
							Endif
						Endif
						If File(lcdirexe + lcarchi)
							oshell = Createobject("WScript.Shell")
							oshell.Run(lcdirexe + lcarchi, 0, .F.)
							oshell = .F.
						Endif
					Endif
				Endif
				mcodvax = 0
				Set Escape On
			Endif
			mpant = _Screen.Width
			mprg = "sp_conexion"
			miserverip = Substr(mserver,8)
			mret = SQLExec(mcon1, "insert into TabCtrlServer (TCS_ClientName,TCS_Device" +;
				",TCS_Estado,TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId" + ;
				",TCS_Usuario,TCS_program,TCS_IPserver)" + ;
				" values  (?mClientName,?mDevice,?mpant,?mfechas,?mIPaddress,?mMemoria,?mName" + ;
				",?mProcessId, ?mcodvax,?mprg,?miserverip )")
			mret = SQLExec(mcon1, "select * from TabCtrlServer where TCS_ClientName = ?mClientName and " + ;
				"TCS_IPaddress = ?mIPaddress and TCS_Fechah = ?mfechas and " + ;
				"TCS_Name = ?mName and TCS_ProcessId = ?mProcessId and TCS_Usuario = ?mcodvax", "mwkTCS")
			Wait Clear
			Select 0
		Endif
	Endif
Else
	Cancel
Endif
Endproc
**
*-eof
