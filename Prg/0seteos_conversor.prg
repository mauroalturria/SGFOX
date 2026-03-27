Parameters tcTexto, tcTexto1, tcTexto2, tcTexto3

If Pcount() = 0
	Return .f.
Endif 	

If Transform(tcTexto) = 'PDF1' Or Transform(tcTexto) = 'PDF2'
	tcTexto1 = Substr(Alltrim(tcTexto1),5,9)
	lcVale = Alltrim(Padl(Alltrim(tcTexto1),9,"0"))
	lcRun = Addbs(Sys(5) + Sys(2003))
	
	Local lbAnulaAnt
	lbAnulaAnt = Transform(tcTexto) = 'PDF2'
	
	lcDirSal = Filetostr(lcRun + "SG.txt")
	
	lcRuta = Addbs(lcDirSal + "Temp")
	
	
*	Messagebox(lcVale + Chr(13) + lcRuta,64,"NRO DE VALE")
Else
	If Transform(tcTexto) = 'EEX' Or Transform(tcTexto1) = 'EEX' Or Transform(tcTexto2) = 'EEX' Or Transform(tcTexto3) = 'EEX'
		Return .F.
	Endif 
	
	Messagebox(tcTexto)
	Messagebox(tcTexto1)
	Messagebox(tcTexto2)
	Messagebox(tcTexto3)
	
Endif 


Public block_ent
block_ent = ''

do prg_var_public

mxambito = 1
lcTitle = 'Conversor'
lcNomExe = 'TURNOS'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'serverws.ico'
Endwith 	

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values (lcNomExe,"","\\172.16.5.46//C:/C/CONVERSOR.exe","")

*!*	mresplog = 0
*!*	do form frmloguin1 with lcNomExe 

*!*	if mresplog <> 0
*!*		Cancel 
*!*	Endif 	
*!*	------------------------------------------------------
If !prg_sistemas_abiertos(lcTitle, lcNomExe)
	Cancel 
Endif  

Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion

create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
insert into mwkexe values ("TURNOS","","\\172.16.5.46//C:/C/TURNOS.exe","")


Do sp_paso_pdf_informe With lcVale, lcRuta, lbAnulaAnt

tcProcessID = "EkBridgeGuemes.exe"
loService = Getobject("winmgmts://./root/cimv2")
loProcesses = loService.ExecQuery([SELECT * FROM Win32_Process WHERE Name = '] + Alltrim(tcProcessID) + ['])
For Each loProcess In loProcesses
  loProcess.Terminate(0)
Next

Release loService

*!*	If prg_modo_exe()
*!*		Do quirofmenu.mpr
*!*		Read Events
*!*	Endif



