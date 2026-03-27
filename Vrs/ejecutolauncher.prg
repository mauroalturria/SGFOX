Private lobrowser
 
cfolderwork = ''
lcparam = ''
launcher =  Alltrim('https://sg.com.ar/incidente/index.php') 

mirun = Alltrim(launcher)

* 
lcHTTP =  Alltrim(Upper(launcher))
lnHTTP = At("HTTP:",lcHTTP)
If lnHTTP = 0
	lnHTTP = At("HTTPS:",lcHTTP)
Endif
If lnHTTP > 0
	lcHTTP_0 = Substr(Alltrim(Upper(launcher)),lnHTTP,Len(lcHTTP)-(lnHTTP)+1)
	o = Createobject("Shell.Application")
	o.Open(Lower(lcHTTP_0))

Else


*messagebox(zzvolumen)
	nsep1 = At("/",Alltrim(launcher))  &&& extrae IP servidor
	nsep2 = 0
	nsep3 = 0
	nsep4 = 0

	If nsep1>0                                              && 0-nsep1 direccion ip
		nsep2 = At("/",Alltrim(launcher),2)     && nombre de la carpeta
		nsep3 = At("/",Alltrim(launcher),3)          && letra a asignar
		nsep4 = At("/",Alltrim(launcher),4)          && parametro
	Endif
	If nsep1>0
		lcmip = Substr(Alltrim(launcher),1,nsep1-1)
	Endif
	If nsep2>0
		lcfolder = Substr(Alltrim(launcher),nsep1+1,nsep2-nsep1-1)
	Endif
	If nsep3>0
		lcletra = Substr(Alltrim(launcher),nsep2+1,nsep3-nsep2-1)
	Endif
	If nsep4>0
		lcparam = Substr(Alltrim(launcher),nsep3+1,nsep4-nsep3-1)
*     lcparam = iif(left(lcparam,7) = "cn_iptcp", "/", "") + alltrim(lcparam)
		lcarchivo = Substr(Alltrim(launcher),nsep4+1)


		miext = Upper(Justext(lcarchivo))
		If Inlist(miext,"HTML","HTM","CSP","PHP")
			Return prg_veo_url(Alltrim(lcarchivo)+" " + lcparam,.T.)
		Endif
		If Inlist(miext,"PRG" )
			Do &lcarchivo
			Return
		Endif

		cfolderwork = Justpath(lcarchivo )
		If !Empty(cfolderwork)
			If !Directory(cfolderwork) And Upper(Left(cfolderwork,1)) # "C"
				Do prg_desconecta_red With lcletra
				micmd = "net use "+ lcletra +" " + lcmip + "\"+Alltrim(lcfolder)
				Wait Windows "Un momento... Windows se esta conectando a la unidad de red... " Timeout 5
				Do prg_conecta_red With lcletra, Alltrim(lcmip) + "\" + Alltrim(lcfolder )
				If !Directory(cfolderwork)
					Wait Windows "Un momento... DOS se esta conectando a la unidad de red... " Timeout 5
					Do prg_desconecta_red With lcletra,1
					Run &micmd
				Endif
				Wait Clear
			Endif
			If !Directory(cfolderwork) And Upper(Left(cfolderwork,1)) # "C"
				Messagebox("No pudo conectarse al servidor.... Avise a Sistemas." ,48,"Aviso de Conexion")
				If Upper(Left(cfolderwork,1)) # "C"
					cfolderwork  = "C"+Substr(cfolderwork ,2)
					lcarchivo = "C"+Substr(lcarchivo,2)
				Endif
			Endif
		Endif

	Else
		lcarchivo = Justfname(Alltrim(launcher))
	Endif
	lcdirlocal = Addbs(Sys(5) + Sys(2003))
	lcopio = .F.
	mivol = 'C:'
	If Directory("X:\Qepd1a1\Exe")
		mivol = "X:"
	Else
		If Directory("H:\Qepd1a1\Exe")
			mivol = "H:"
		Endif
	Endif
	mcini = mivol+"\qepd1a1\exe\inicio\ini.txt"
	lcdirupdate = mivol + "\qepd1a1\exe\"
	If !Directory(cfolderwork) And Upper(Left(cfolderwork,1)) = "C"  And mivol # 'C:'&&& no existe la carpeta debo copiarla
		lcdirlocal = Addbs(Sys(5) + Sys(2003))
		mifile = lcdirlocal+ "copiadir.exe"
		lncantlocal  = Adir(ladatosloc,mifile )
		If lncantlocal = 0
			Copy File (lcdirupdate + "copiadir.exe" ) To (lcdirlocal  + "copiadir.exe" )
		Endif

		mcrun = lcdirlocal+ "copiadir "+"X"+Substr(Alltrim(cfolderwork),2)+"\ " + Alltrim(cfolderwork)+"\"
		Run /N &mcrun
* ejecutar copiador
		Do While !File(lcarchivo )
		Enddo
	Endif
	If Upper(Left(cfolderwork,1)) = "C"
		Cd Alltrim(cfolderwork)
	Endif

	If Directory(mivol + "\Qepd1a1\Exe") And mivol#"C:"
		On Error =Aerr(eros)
		Copy File &mcini To c:\qepd1a1\Exe\inicio\ini.txt
		lcdirupdate = mivol + "\qepd1a1\ultimos\exe\"
		lcdirlocal  = "C:\qepd1a1\Exe\"
		If lcarchivo = Justfname(Alltrim(lcarchivo))
			lncantupdate = Adir(ladatosupd,lcdirupdate + lcarchivo)
			lncantlocal  = Adir(ladatosloc,lcdirlocal  + lcarchivo)

			mccad = ""
			mcarchTemp = Alltrim(myip)+'_temp.txt'

			If lncantupdate >0
				If lncantlocal>0
					If Ctot(Dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4]) ;
							> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])

						mcantexe = 0
						Do prg_exes_activos With Proper(miexe) + "      P.Id:"
						If mcantexe>0
							Messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + Chr(13)+;
								"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE "+Upper(miexe)+;
								chr(13) + "DISCULPE LAS MOLESTIAS...";
								,48,"Control Sistemas")
							Return
						Endif

						Copy File (lcdirupdate + lcarchivo ) To (lcdirlocal  + lcarchivo )

						mncant = Agetfileversion(Aver, lcdirupdate + lcarchivo )
						mvercopia = ""
						If mncant > 1
							mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
						Else
							mvercopia = lcnewfile
						Endif

						mccad = mccad + Ttoc(Datetime()) + Chr(9) + Alltrim(myip) + Chr(9) + ;
							alltrim( lcdirupdate + lcarchivo )+ Chr(9) + ;
							dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4] + Chr(9) + ;
							mvercopia + Chr(10)

						lcopio = .T.
					Endif
				Else

					mncant = Agetfileversion(Aver, lcdirupdate + lcarchivo )
					mvercopia = ""
					If mncant > 1
						mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
					Else
						mvercopia = lcnewfile
					Endif

&& REVISAR SI SE ESTA EJECUTANDO
					mcantexe = 0
					Do prg_exes_activos With Proper(miexe) + "      P.Id:"
					If mcantexe>0
						Messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + Chr(13)+;
							"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE "+Upper(miexe)+;
							chr(13) + "DISCULPE LAS MOLESTIAS...";
							,48,"Control Sistemas")
						Return
					Endif

					Copy File (lcdirupdate + lcarchivo ) To (lcdirlocal  + lcarchivo )

					mccad = mccad + Ttoc(Datetime()) + Chr(9) + Alltrim(myip) + Chr(9) + ;
						alltrim( lcdirupdate + lcarchivo )+ Chr(9) + ;
						dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4] + Chr(9) + ;
						mvercopia + Chr(10)

					lcopio = .T.
				Endif
			Else
				lcdirupdatebase = mivol + "\qepd1a1\exe\"
				lncantupdate = Adir(ladatosupd,lcdirupdatebase + lcarchivo)
				If lncantupdate >0
					If Ctot(Dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4]) ;
							> Ctot(Dtoc(ladatosloc[1,3] )+ ' ' + ladatosloc[1,4])

						mcantexe = 0
						Do prg_exes_activos With Proper(miexe) + "      P.Id:"
						If mcantexe>0
							Messagebox("HAY UNA ACTUALIZACION PENDIENTE PARA ESTE PROGRAMA. " + Chr(13)+;
								"PARA ACTUALIZAR CIERRE TODAS LAS APLICACIONES DE "+Upper(miexe)+;
								chr(13) + "DISCULPE LAS MOLESTIAS...";
								,48,"Control Sistemas")
							Return
						Endif

						Copy File (lcdirupdatebase + lcarchivo ) To (lcdirlocal  + lcarchivo )

						mncant = Agetfileversion(Aver, lcdirupdate + lcarchivo )
						mvercopia = ""
						If mncant > 1
							mvercopia = Alltrim(Transform(Aver(5))) + " " + Alltrim(Transform( Aver(11)))
						Else
							mvercopia = lcnewfile
						Endif

						mccad = mccad + Ttoc(Datetime()) + Chr(9) + Alltrim(myip) + Chr(9) + ;
							alltrim( lcdirupdatebase + lcarchivo )+ Chr(9) + ;
							dtoc(ladatosupd[1,3] )+ ' ' + ladatosupd[1,4] + Chr(9) + ;
							mvercopia + Chr(10)

						lcopio = .T.
					Endif
				Endif
			Endif

			If lcopio
				Strtofile(mccad ,"C:\qepd1a1\Exe\" + mcarchTemp ,.T.)
				On Error =Aerr(eros)
&& Guardo quien actualizo
*          Do Sp_Actualizo_ExeLog With "X", "X" , lcarchivo, 1
&&
				On Error
			Endif
			On Error
		Endif
	Endif

	Select mwkaccexe
	miext = Upper(Justext(lcarchivo))

	Do Case
	Case Inlist(miext,"EXE","BAT")
		If !PRG_MODO_EXE()
			cfolderwork = mivol + "\Qepd1a1\Exe"
		Endif

		Set Console Off
		If !PRG_MODO_EXE()
			lcdirlocal = Sys(5)+Sys(2003)
		Endif
		Cd &cfolderwork
		mrun2 = Iif(Empty(cfolderwork),lcdirlocal,'') + lcarchivo
		Wait Windows ("Ejecutando: " + Alltrim(titulo)) Nowait
		If !File(mrun2)
			Messagebox("No Existe el Ejecutable" + Chr(13) + mrun2 ,48,"Validación")
		Else
			If Nvl(mwkaccexe.modoejecucion,0)=1
				strCommand = 'runas.Exe /savedcred /User:sistemas '+mrun2  + " " + lcparam
				WshShell = Createobject("Wscript.shell")
				WshShell.Run(strCommand,  , .F.)
			Else
				mrun2 = mrun2 + " " + lcparam
				Run /N &mrun2
			Endif
		Endif
		Cd &lcdirlocal
	Case miext = "SCX"
		Do Form &lcarchivo

**** Agregado el 30/8/16 ****

	Case Inlist(miext,"HTML","HTM","CSP","PHP")
		lobrowser= Createobject("InternetExplorer.Application")
		lobrowser.Navigate(Alltrim(lcarchivo)+" " + lcparam)
		lobrowser.Visible=.T.
		lobrowser.LockScreen = .T.
		lobrowser.Width = _Screen.Width
		lobrowser.Top = 0
		lobrowser.Left = 0
		lobrowser.Height = _Screen.Height
		lobrowser.LockScreen = .F.
		Release lobrowser
*****************************

	Endcase

Endif && Viene del if del http




