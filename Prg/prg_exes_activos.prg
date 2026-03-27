Lparameters namewin
*** Constantes
#Define GW_HWNDFIRST        0
#Define GW_HWNDNEXT         2
#Define GW_OWNER            4
#Define GW_CHILD            5
#Define WM_CLOSE  16

External Array aFindHwnd

Declare ;
	Integer PostMessage ;
	IN WIN32API ;
	Integer  nWnd, ;
	Integer  nMsg, ;
	Integer  nParam, ;
	Integer  nParam

mcantexe = FindHwnd( namewin )


Procedure FindHwnd
Lparameter cTitle
ncantexe = 0
For nCont = 1 To aTask( "aFindHwnd" )

	If Upper( cTitle ) ;
			$ Upper( aFindHwnd[nCont,1] )
		If Upper("P.ID:" ) ;
				$ Upper( aFindHwnd[nCont,1] )
			ncantexe = ncantexe + 1
		Endif
	Endif
Next

Release Memory aFindHwnd
Return ncantexe


Procedure ATask
Lparameter cMatriz, lOcultos

Declare ;
	Integer GetWindow ;
	IN WIN32API ;
	Integer  nHwnd, ;
	Integer  nCmd
Declare ;
	Integer GetWindowText ;
	IN WIN32API ;
	Integer  nHwnd, ;
	String  @cString, ;
	Integer  nMaxCount
Declare ;
	Integer GetWindowTextLength ;
	IN WIN32API ;
	Integer  nWnd
Declare ;
	Integer IsWindowVisible ;
	IN WIN32API ;
	Integer  nWnd
Declare ;
	Integer GetDesktopWindow ;
	IN WIN32API

Private nFoxHwnd, nCont, nCurrWnd
Private nLength, cTmp
Release Memory &cMatriz
Public (cMatriz)

nHwnd = GetDesktopWindow()
nInitHwnd = GetWindow( nHwnd, GW_CHILD )

nCurrWnd = GetWindow( nInitHwnd, ;
	GW_HWNDFIRST )

nCont = 0


Do While nCurrWnd # 0


	If GetWindow(nCurrWnd, GW_OWNER) = 0


		If IsWindowVisible( nCurrWnd ) = 1 ;
				OR lOcultos

			nLength=GetWindowTextLength(nCurrWnd)
			If nLength > 0

				nCont = nCont + 1

				cTmp=Replicate( Chr(0), nLength+1 )
				=GetWindowText( nCurrWnd, ;
					@cTmp, ;
					nLength + 1 )
				Dimension &cMatriz.[nCont,2]
				&cMatriz.[nCont,1] = ;
					SUBSTR( cTmp, 1, nLength )
				&cMatriz.[nCont,2] = ;
					nCurrWnd
			Endif
		Endif
	Endif

	nCurrWnd = GetWindow( nCurrWnd, ;
		GW_HWNDNEXT )
Enddo && (nCurrWnd # 0)

*** Retornar el número de procesos
Return nCont
