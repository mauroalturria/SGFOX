*       *********************************************************
*       *                                                         
*       * 04/11/2004           PISOSMENU.MPR            10:50:48  
*       *                                                         
*       *********************************************************
*       *                                                         
*       * Nombre del autor                                        
*       *                                                         
*       * Copyright (C) 2004 Nombre de compañía                   
*       * Dirección                                               
*       * Ciudad,     Código pos                                  
*       * País                                              
*       *                                                         
*       * Descripción:                                            
*       * Este PROGRAMA lo ha generado automáticamente GENMENU.    
*       *                                                         
*       *********************************************************


*       *********************************************************
*       *                                                         
*       *                    Definición de menú                   
*       *                                                         
*       *********************************************************
*
lparameters nameform,lmenu,mtitulo,nbar
if type('mtitulo')#"C"
	mtitulo = "Utilidades para la Indicación Médica"
ENDIF

nbar = 1
DEFINE POPUP menucontex SHORTCUT RELATIVE FROM MROW(),MCOL() title mtitulo
DEFINE BAR 1 OF menucontex PROMPT "ALFABETA " ;
	SKIP FOR lmenu(1)
DEFINE BAR 2 OF menucontex PROMPT "Interacciones Farmacológicas  " ;
	SKIP FOR lmenu(2)
DEFINE BAR 3 OF menucontex PROMPT "UpToDate ";
	SKIP FOR lmenu(3)
*!*	DEFINE BAR 4 OF menucontex PROMPT "BRONQUIOLITIS " ;
*!*		SKIP FOR lmenu(4)
*!*	DEFINE BAR 5 OF menucontex PROMPT "DENUNCIA DE OBITO" ;
*!*		SKIP FOR lmenu(5)
*!*	DEFINE BAR 6 OF menucontex PROMPT "DETALLE" ;
*!*		SKIP FOR lmenu(6)
*!*	DEFINE BAR 7 OF menucontex PROMPT "RETIRO DKV/MIK" ;
*!*		SKIP FOR lmenu(7)
*!*	DEFINE BAR 8 OF menucontex PROMPT "VISUALIZA TEXTO" ;
*!*		SKIP FOR lmenu(8)
*!*	DEFINE BAR 9 OF menucontex PROMPT "VISUALIZA DOC" ;
*!*		SKIP FOR lmenu(9)
*!*	DEFINE BAR 10 OF menucontex PROMPT "IMPRIME ETIQUETA" ;
*!*		SKIP FOR lmenu(10)
mcmd1= alltrim(nameform)+'.menuwm(1)'
ON SELECTION BAR 1 OF menucontex &mcmd1
mcmd2= alltrim(nameform)+'.menuwm(2)'
ON SELECTION BAR 2 OF menucontex  &mcmd2
mcmd3= alltrim(nameform)+'.menuwm(3)'
ON SELECTION BAR 3 OF menucontex  &mcmd3
mcmd4= alltrim(nameform)+'.menuwm(4)'
ON SELECTION BAR 4 OF menucontex  &mcmd4
*!*	mcmd5= alltrim(nameform)+'.menu(5)'
*!*	ON SELECTION BAR 5 OF menucontex  &mcmd5
*!*	mcmd6= alltrim(nameform)+'.menu(6)'
*!*	ON SELECTION BAR 6 OF menucontex  &mcmd6
*!*	mcmd7= alltrim(nameform)+'.menu(7)'
*!*	ON SELECTION BAR 7 OF menucontex  &mcmd7
*!*	mcmd8= alltrim(nameform)+'.menu(8)'
*!*	ON SELECTION BAR 8 OF menucontex  &mcmd8
*!*	mcmd9= alltrim(nameform)+'.menu(9)'
*!*	ON SELECTION BAR 9 OF menucontex  &mcmd9
*!*	mcmd10= alltrim(nameform)+'.menu(10)'
*!*	ON SELECTION BAR 10 OF menucontex  &mcmd10

ACTIVATE POPUP menucontex bar nbar
