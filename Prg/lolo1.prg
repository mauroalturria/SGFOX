     *** Constantes
    #define GW_HWNDFIRST        0
    #define GW_HWNDNEXT         2
    #define GW_OWNER            4
    #define GW_CHILD            5
 #DEFINE WM_CLOSE  16

    DECLARE ;
      Integer PostMessage ;
      IN WIN32API ;
      Integer  nWnd, ;
      Integer  nMsg, ;
      Integer  nParam, ;
      Integer  nParam

    *** Arranca en NotePad
    WAIT WINDOW ;
        TIMEOUT 3
    RUN /N NotePad

  
    WAIT WINDOW ;
        TIMEOUT 5
    nHwndNote = FindHwnd( "Bloc de notas" )
    =PostMessage( nHwndNote, WM_CLOSE, 0, 0 )
    
    PROCEDURE FindHwnd
    LPARAMETER cTitle

      FOR nCont = 1 TO aTask( "aFindHwnd" )
  
      IF UPPER( cTitle ) ;
         $ UPPER( aFindHwnd[nCont,1] )

        RELEASE MEMORY aFindHwnd
        RETURN aFindHwnd[nCont,2]
      ENDIF
    NEXT

    RELEASE MEMORY aFindHwnd
    RETURN 0
    
  
    PROCEDURE ATask
    LPARAMETER cMatriz, lOcultos

    DECLARE ;
      Integer GetWindow ;
      IN WIN32API ;
      Integer  nHwnd, ;
      Integer  nCmd
    DECLARE ;
      Integer GetWindowText ;
      IN WIN32API ;
      Integer  nHwnd, ;
      String  @cString, ;
      Integer  nMaxCount
    DECLARE ;
      Integer GetWindowTextLength ;
      IN WIN32API ;
      Integer  nWnd
    DECLARE ;
      Integer IsWindowVisible ;
      IN WIN32API ;
      Integer  nWnd
    DECLARE ;
      Integer GetDesktopWindow ;
      IN WIN32API

    PRIVATE nFoxHwnd, nCont, nCurrWnd
    PRIVATE nLength, cTmp
    RELEASE MEMORY &cMatriz
    PUBLIC (cMatriz)

    nHwnd = GetDesktopWindow()
    nInitHwnd = GetWindow( nHwnd, GW_CHILD )

    nCurrWnd = GetWindow( nInitHwnd, ;
                          GW_HWNDFIRST )

    nCont = 0


    DO WHILE nCurrWnd # 0


      IF GetWindow(nCurrWnd, GW_OWNER) = 0


        IF IsWindowVisible( nCurrWnd ) = 1 ;
           OR lOcultos 

          nLength=GetWindowTextLength(nCurrWnd)
          IF nLength > 0

            nCont = nCont + 1

            cTmp=REPLICATE( CHR(0), nLength+1 )
            =GetWindowText( nCurrWnd, ;
                            @cTmp, ;
                            nLength + 1 )
            DIMENSION &cMatriz.[nCont,2]
            &cMatriz.[nCont,1] = ;
              SUBSTR( cTmp, 1, nLength )
            &cMatriz.[nCont,2] = ;
              nCurrWnd
          ENDIF
        ENDIF
      ENDIF

      nCurrWnd = GetWindow( nCurrWnd, ;
                            GW_HWNDNEXT )
    ENDDO && (nCurrWnd # 0)

    *** Retornar el número de procesos
    RETURN nCont