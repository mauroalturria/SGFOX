*** controla que no haya una aplicacion ejecutandose
Lparameters mnapli
	rtnp = ListApp(mnapli)
Return rtnp

*--------------------------------------------
Function ListApp
	*--------------------------------------------
	* Nuestra información de las aplicaciones que
	* estan corriendo en Windows
	* USO: ListApp()
	*-----------------------------------------------
	Parameters ver_program
	Local laApp, lnHandle, lnCount, lcTitle, lnI, lnHFox, lcCant_exist ,nveces
	Dimension laApp[1]
	lnHFox=0
	lcCant_exist =0

	Declare Integer FindWindow ;
		IN win32api ;
		INTEGER nullpointer, ;
		STRING cwindow_name

	Declare Integer GetWindow ;
		IN win32api ;
		INTEGER ncurr_window_handle, ;
		INTEGER ndirection

	Declare Integer GetWindowText ;
		IN win32api ;
		INTEGER n_win_handle, ;
		STRING @ cwindow_title, ;
		INTEGER ntitle_length

	lnHFox = FindWindow(0,_Screen.Caption)
	lnHandle = lnHFox && GetWindow(lnHFox,0)
	lnCount = 0
	Do While lnHandle > 0
		lcTitle=Space(255)
		lnI=GetWindowText(lnHandle, @lcTitle,Len(lcTitle))
		If lnI>0
			lcTitle=Strtran(Trim(lcTitle),Chr(0),"")
		Else
			lcTitle=""
		Endif

		If lnHandle > 0 .And. !Empty(lcTitle)
			lnCount=lnCount+1
			Dimension laApp(lnCount)
			laApp[lnCount]=lcTitle
		Endif
		lnHandle = GetWindow(lnHandle,2)
	Enddo
	nveces = 0
	If Alen(laApp,1)>0
		lcString = "Las siguientes aplicaciones estan "+;
			"ejecutandose:" + Chr(13) + Chr(13)
		For i=1 To Alen(laApp,1)
*			Messagebox(laApp[i] + '<=>'+ ver_program)
			If at(ver_program,laApp[i])>0 
				Messagebox("Ya Se Está Ejecutando: " + Chr(13) + Upper(laApp[i]) +Chr(13)+Chr(13)+;
					"Debe CERRAR esa Aplicación antes de continuar ",48,"Atención")
				Return .F.
			Endif
			lcString = lcString + laApp[i]+Chr(13)
		Next
	Else
		lcString = "No hay aplicaciones ejecutandose"
	Endif

*	=Messagebox(lcString, "Lista de aplicaciones")
	Return .T.
