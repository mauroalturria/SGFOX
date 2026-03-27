*!*	Lanzador de aplicaciones
Lparameters lcip,lcdirupdate, lcdirlocal, lcarchivo, lsiexec
*!*	------------------------------------------------------------------------
cparam = Parameters()

Public mcon1, mcon1, mcon4, midusu,myip,miform,mxambito
mxambito = 1

Set Resource Off
Set Century On
Set Date French
Set Safety Off
Set Path To scx, lib, mnu, prg, Exe, bmp, rep

Do seteos_ip
On Error
myiplocal 	= IPAddress()
myip		= myiplocal
If Vartype(lcip)#"C"
	lcipprueba = "172.16.1.220"
	lcip = "172.16.1.220"
Else
	If Alltrim(Left(lcip,3)) = "172"
		cparam = 0
	Endif
Endif

_Screen.Visible = .F.
_Screen.Caption = "Sanatorio Güemes - Lanzador de Aplicaciones"

lsiexec     = .T.
lcdirlocal  = "C:\qepd1a1\Exe\"
lcarchivo   = "launcher1.exe"

lbMasWin98 = (Directory("C:\Documents and Settings") Or Directory("C:\Users"))
*!*	--------------------------------------------------
**messagebox(iif(lbMasWin98,"XP","WIN98"))  &&-*/-*/
**gebox('Direccion de conexion '+lcip)  &&-*/-*/
Do sp_control_vol_ini With 'LAUNCHER'
*messagebox(zzvolumen)  &&-*/-*/
*do c:\desaguemes\prg\

If cparam = 0 And lbMasWin98

&& VOLVER A VER LAS DESCONECIONES
	If Directory("J:")
		Do prg_desconecta_red With "J:",1
	Endif
	If Directory("U:")
		Do prg_desconecta_red With "U:",1
	Endif
	If Directory("I:")
		Do prg_desconecta_red With "I:",1
	Endif
*!*	-------------------
&& LEO EL INI DEL X / H / C SOLO PARA MSG
	minicio = 0
	Do sp_control_msgini With 'LAUNCHER'

	If minicio = 1
*		messagebox('Controlo que este el '+zzvolumen)  &&-*/-*/

		unidad = _GetConnec(zzvolumen)

*			messagebox(unidad )  &&-*/-*/
		If At(lcip,unidad) = 0 And !Empty(unidad)

			Do prg_desconecta_red With zzvolumen,1
		Endif

		Do sp_busco_usuario_launcher

		misusu = Alltrim(Lower(mwkusuLauncher.idusuario))
		mipass = Alltrim(Lower(mwkusuLauncher.passwordldap))
		If !Directory(zzvolumen+"\Qepd1a1\Exe") &&and !empty(misusu) and !empty(mipass)
			If Directory(zzvolumen)
				Do prg_desconecta_red With zzvolumen,1
			Endif

			Wait Windows "Un momento... Windows se esta conectando a la unidad de red... " Nowait

			Do prg_conecta_red With zzvolumen,"\\" + lcip + "\Public",0&&,misusu ,mipass

		Endif

	Else
*		messagebox('Controlo que este el '+zzvolumen)  &&-*/-*/
		unidad = _GetConnec(zzvolumen)
		If At(lcip,unidad) = 0 And !Empty(unidad)
*			messagebox('desconecto X')  &&-*/-*/
			Do prg_desconecta_red With zzvolumen,1
		Endif

		If !Directory(zzvolumen+"\Qepd1a1\Exe")
			If Directory(zzvolumen)
*				messagebox('desconecto X')  &&-*/-*/
				Do prg_desconecta_red With zzvolumen,1
			Endif

			micmd = "net use "+zzvolumen+" \\" + lcip + "\public "  &&& PRUEBA PRUEBA
			Wait Windows "Un momento... Windows se esta conectando a la unidad de red... " Nowait
*			messagebox('Conecto X con '+"\\" + lcip + "\Public" )  &&-*/-*/
			Do prg_conecta_red With zzvolumen,"\\" + lcip + "\public",0,"prueba","prueba"

			If !Directory(zzvolumen+"\Qepd1a1\Exe")
				Wait Windows "Un momento... DOS se esta conectando a la unidad de red... " Nowait
				Run &micmd
			Endif
		Endif
	Endif
Else

	If !Directory(zzvolumen+"\Qepd1a1\Exe")

		If Directory(zzvolumen)
*			messagebox('desconecto X')  &&-*/-*/
			Do prg_desconecta_red With zzvolumen,1
		Endif

		Wait Windows "Un momento... Windows se esta conectando a la unidad de red... " Nowait
		minicio = 0
		Do sp_control_msgini With 'LAUNCHER'

		unidad = _GetConnec(zzvolumen)

		If At(lcip,unidad) = 0 And !Empty(unidad)
			Do prg_desconecta_red With ,1
		Endif

		Do sp_busco_usuario_launcher

		misusu = Alltrim(Lower(mwkusuLauncher.idusuario))
		mipass = Alltrim(Lower(mwkusuLauncher.passwordldap))

		If !Directory(zzvolumen+"\Qepd1a1\Exe")
			If Directory(zzvolumen)
*				messagebox('desconecto X')  &&-*/-*/
				Do prg_desconecta_red With zzvolumen,1
			Endif

			Wait Windows "Un momento... Windows se esta conectando a la unidad de red... " Nowait
			micmd = "net use "+zzvolumen+" \\" + lcip + "\Public " + Alltrim(mipass) &&+" /user:"+alltrim(misusu)  &&& PRUEBA PRUEBA
			Run &micmd
		Endif
	Endif
Endif

If !Directory(zzvolumen+"\Qepd1a1\Exe")
	Wait Windows "NO se conectó a la unidad de red... " Timeout 1
Endif
Wait Clear

*!*	------------------------------------------------------------------------------------
Wait Windows "Un momento... Actualizando ejecutables... " Nowait

mfecha    = Date()
mcpathact = Allt(Sys(5))+Sys(2003)
i=0
mcarch = Alltrim(myiplocal)+'_temp.txt'
&&
mccad = ''

On Error =Aerr(eros)
Erase act*.txt
&& VER QUE PASA SI NO MAPEA NINGUN DISCO
mivol = ''
If Directory(zzvolumen+"\Qepd1a1\Exe")
	mivol = zzvolumen
Else
	If Directory(zzvolumen+"\Qepd1a1\Exe")
		mivol = zzvolumen
	Endif
Endif
*!*	------------------------------------------------------------------------------------
Wait Windows "Conecto por " + mivol Timeout 1 &&nowait
*!*	------------------------------------------------------------------------------------
mcini = mivol + "\qepd1a1\exe\inicio\ini.txt"
lcdirlocal  = "C:\qepd1a1\Exe\"

If !Directory(mivol + "\Qepd1a1\Exe")
	Messagebox ("No se pudo conectar al servidor.... Informe a sistemas", 48, "Validación")
Else

	If Directory("C:\Qepd1a1\Exe")

&& COPIA DEL INI
		Copy File &mcini To c:\qepd1a1\Exe\inicio\ini.txt
*!*	-----------------------------------------------------
		lcdirupdate  = mivol + "\qepd1a1\exe\" + lcarchivo
		lcdirlocal   = "C:\qepd1a1\Exe\" + lcarchivo
		lncantupdate = Adir(ladatosupd,lcdirupdate )
		lncantlocal  = Adir(ladatosloc,lcdirlocal  )

		If lncantupdate >0
			If lncantlocal>0
				If Ctot(Dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])
					Copy File (lcdirupdate ) To (lcdirlocal)
					lcopio = .T.
				Endif
			Else
*!*				Copy file (lcdirupdate + lcarchivo ) to (lcdirlocal  + lcarchivo )
				Copy File (lcdirupdate) To (lcdirlocal )
				lcopio = .T.
			Endif
		Endif
*!*	-----------------------------------------------------
		lcarchivo   = "launcher.exe"
		lcdirupdate  = mivol + "\qepd1a1\exe\" + lcarchivo
		lcdirlocal   = "C:\qepd1a1\Exe\" + lcarchivo
		lncantupdate = Adir(ladatosupd,lcdirupdate )
		lncantlocal  = Adir(ladatosloc,lcdirlocal  )

		If lncantupdate >0
			If lncantlocal>0
				If Ctot(Dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])
					Copy File (lcdirupdate ) To (lcdirlocal)
					lcopio = .T.
				Endif
			Else
*!*				Copy file (lcdirupdate + lcarchivo ) to (lcdirlocal  + lcarchivo )
				Copy File (lcdirupdate) To (lcdirlocal )
				lcopio = .T.
			Endif
		Endif
*!*	-----------------------------------------------------
		lcdirupdate  = mivol + "\qepd1a1\ultimos\exe\"
		lcdirlocal   = "C:\qepd1a1\Exe\"
		lncantupdate = Adir(ladatosupd,lcdirupdate+"*.*" )

		For lnupdt = 1 To lncantupdate

			lcnewfile   = Alltrim(ladatosupd(lnupdt,1))
			lncantlocal = Adir(ladatosloc,lcdirlocal + lcnewfile )

			If lncantlocal > 0
				If Ctot(Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])

					mncant = Agetfileversion(Aver, lcdirupdate + lcnewfile)
					mvercopia = ""

					If mncant > 1
						mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
					Else
						mvercopia = lcnewfile
					Endif

					mccad =  mccad + Ttoc(Datetime()) + Chr(9) + ;
						alltrim(myiplocal) + Chr(9) + ;
						alltrim(lcdirupdate + lcnewfile )+ Chr(9) + ;
						dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4] + Chr(9) + ;
						mvercopia + Chr(10)

					Copy File (lcdirupdate + lcnewfile ) To (lcdirlocal + lcnewfile )
				Endif
			Else
*!*					copy file (lcdirupdate + lcnewfile ) to (lcdirlocal  + lcnewfile )
			Endif
		Next
*!*	-----------------------------------------------------
		lcdirupdate  = mivol + "\qepd1a1\ultimos\BMP\"
		lcdirlocalud = "C:\qepd1a1\exe\bmp\"
		lncantupdate = Adir(ladatosupd,lcdirupdate+"*.*" )

		For lnupdt = 1 To lncantupdate

			lcnewfile   = Alltrim(ladatosupd(lnupdt,1))
			lncantlocal = Adir(ladatosloc,lcdirlocalud  + lcnewfile )

			If lncantlocal>0
				If Ctot(Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])
					mncant = Agetfileversion(Aver, lcdirupdate + lcnewfile)
					mvercopia = ""
					If mncant > 1
						mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
					Else
						mvercopia = lcnewfile
					Endif

					mccad =  mccad + Ttoc(Datetime()) + Chr(9) + ;
						alltrim(myiplocal) + Chr(9) + ;
						alltrim(lcdirupdate + lcnewfile )+ Chr(9) + ;
						dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4] + Chr(9) + ;
						mvercopia + Chr(10)

					Copy File (lcdirupdate + lcnewfile ) To (lcdirlocalud  + lcnewfile )
				Endif
			Else
				mccad =  mccad + Ttoc(Datetime()) + Chr(9) + Alltrim(myiplocal) + Chr(9) + ;
					alltrim(lcdirupdate + lcnewfile )+ Chr(9) + Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]+ Chr(10)
				Copy File (lcdirupdate + lcnewfile ) To (lcdirlocalud  + lcnewfile )
			Endif
		Next

*!*	-----------------------------------------------------
		lcdirupdate  = mivol + "\qepd1a1\ultimos\nombres\"
		lcdirlocal   = "C:\qepd1a1\Exe\nombres\"
		lncantupdate = Adir(ladatosupd,lcdirupdate+"*.*" )

		For lnupdt = 1 To lncantupdate

			lcnewfile   = Alltrim(ladatosupd(lnupdt,1))
			lncantlocal = Adir(ladatosloc,lcdirlocal + lcnewfile )

			If lncantlocal > 0
				If Ctot(Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])

					mncant = Agetfileversion(Aver, lcdirupdate + lcnewfile)
					mvercopia = ""

					If mncant > 1
						mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
					Else
						mvercopia = lcnewfile
					Endif

					mccad =  mccad + Ttoc(Datetime()) + Chr(9) + ;
						alltrim(myiplocal) + Chr(9) + ;
						alltrim(lcdirupdate + lcnewfile )+ Chr(9) + ;
						dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4] + Chr(9) + ;
						mvercopia + Chr(10)

					Copy File (lcdirupdate + lcnewfile ) To (lcdirlocal + lcnewfile )
				Endif
			Else
				Copy File (lcdirupdate + lcnewfile ) To (lcdirlocal  + lcnewfile )
			Endif
		Next
*!*	-----------------------------------------------------
		lcFolder = "C:\qepd1a1\exe\GLPI\"
		If Not Directory(m.lcFolder)
			Md (lcFolder)
		Endif
		lcdirupdate  = mivol + "\qepd1a1\ultimos\GLPI\"
		lcdirlocalud = "C:\qepd1a1\exe\GLPI\"
		lncantupdate = Adir(ladatosupd,lcdirupdate+"*.*" )

		For lnupdt = 1 To lncantupdate

			lcnewfile   = Alltrim(ladatosupd(lnupdt,1))
			lncantlocal = Adir(ladatosloc,lcdirlocalud  + lcnewfile )

			If lncantlocal>0

			Else
				mccad =  mccad + Ttoc(Datetime()) + Chr(9) + Alltrim(myiplocal) + Chr(9) + ;
					alltrim(lcdirupdate + lcnewfile )+ Chr(9) + Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]+ Chr(10)
				Copy File (lcdirupdate + lcnewfile ) To (lcdirlocalud  + lcnewfile )
			Endif
		Next

*!*	-----------------------------------------------------
		lcdirupdate  = mivol + "\qepd1a1\ultimos\xlt\"
		lcdirlocalud = "C:\qepd1a1\xlt\"
		lncantupdate = Adir(ladatosupd,lcdirupdate+"*.*" )

		For lnupdt = 1 To lncantupdate

			lcnewfile   = Alltrim(ladatosupd(lnupdt,1))
			lncantlocal = Adir(ladatosloc,lcdirlocalud + lcnewfile )

			If lncantlocal>0
				If Ctot(Dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4]) ;
						> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])

					mncant = Agetfileversion(Aver, lcdirupdate + lcnewfile)
					mvercopia = ""
					If mncant > 1
						mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
					Else
						mvercopia = lcnewfile
					Endif

					mccad =  mccad + Ttoc(Datetime()) + Chr(9) + ;
						alltrim(myiplocal) + Chr(9) + ;
						alltrim(lcdirupdate + lcnewfile )+ Chr(9) + ;
						dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4] + Chr(9)+ ;
						mvercopia + Chr(10)

					Copy File (lcdirupdate + lcnewfile) To (lcdirlocalud + lcnewfile)
				Endif

			Else

				mncant = Agetfileversion(Aver, lcdirupdate + lcnewfile)
				mvercopia = ""
				If mncant > 1
					mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
				Else
					mvercopia = lcnewfile
				Endif

				mccad =  mccad + Ttoc(Datetime()) + Chr(9) + ;
					alltrim(myiplocal) + Chr(9) + ;
					alltrim(lcdirupdate + lcnewfile )+ Chr(9) + ;
					dtoc(ladatosupd[lnupdt,3] )+ ' ' + ladatosupd[lnupdt,4] + Chr(9) + ;
					mvercopia + Chr(10)

				Copy File (lcdirupdate + lcnewfile ) To (lcdirlocalud  + lcnewfile )
			Endif
		Next
	Endif
Endif
lcdirlocal  = "C:\qepd1a1\Exe\"
lcarchivo   = "launcher.exe"

*!*	------------------------------------------------------------------------------------
If !Empty(mccad)
	Strtofile(mccad ,mcarch,.T.) && agrego en el archivo temporal
Endif
*!*	------------------------------------------------------------------------------------
Cd Alltrim(lcdirlocal)

Wait Windows "Un momento... Ejecutando Aplicacion... " Nowait

If lsiexec And File(lcdirlocal  + lcarchivo)
	Declare Integer ShellExecute In shell32;
		integer HWnd,;
		string  lpOperation,;
		string  lpFile,;
		string  lpParameters,;
		string  lpDirectory,;
		integer nShowCmd

	lnshellreturn = ShellExecute(0, "Open", lcdirlocal  + lcarchivo, "" , lcdirlocal ,1)
Else
	lcarchivo   = "launcher1.exe"
	Declare Integer ShellExecute In shell32;
		integer HWnd,;
		string  lpOperation,;
		string  lpFile,;
		string  lpParameters,;
		string  lpDirectory,;
		integer nShowCmd

	lnshellreturn = ShellExecute(0, "Open", lcdirlocal  + lcarchivo, "" , lcdirlocal ,1)

Endif

If _vfp.StartMode = 0
	_Screen.Visible = .T.
Endif

*--------------------------------------------------------
Function isactive(tccaption)
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare Integer FindWindow In WIN32API ;
	string cNULL, ;
	string cWinName
Return FindWindow(0, tccaption) # 0
Endfunc

*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTION YaActiva()
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Ejemplo de uso de IsActive:
* Comprueba que la aplicación no se esta ejecutando
* Invoca a IsActive() descripta anteriormente
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function yaactiva()
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Local llret, lccaption
llret = .F.
lccaption = _Screen.Caption
*--- Renombra temporariamente el caption de la app
_Screen.Caption = "_" + lccaption
If isactive(lccaption)
*--- Si ya esta activo
	Messagebox(lccaption+Chr(13)+"ya está activo"+Chr(13)+"Seleccionelo de la barra de Windows",16,"Aviso")
	llret = .T.
Endif
_Screen.Caption = lccaption
Return llret
Endfunc
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Function _GetConnec(lcDrive)
*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Declare Integer WNetGetConnection In WIN32API ;
	string lpLocalName, ;
	string @lpRemoteName, ;
	integer @lpnLength
Local cRemoteName, nLength, lcRet, llret
cRemoteName=Space(100)
nLength=100
llret = WNetGetConnection(lcDrive,@cRemoteName,@nLength)
lcRet = Left(cRemoteName,At(Chr(0),cRemoteName)-1)
Return lcRet
Endfunc
** Eof() **


