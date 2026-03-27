*       *********************************************************
*       *
*       * 04/11/2004           PROTOMENU.MPR            10:50:48
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
Lparameters nameform,lmenu,mtitulo,nbar
If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif
Define Popup menucontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo
Define Bar 1 Of menucontex Prompt "RETIRO NORMAL" ;
	SKIP For lmenu(1)
Define Bar 2 Of menucontex Prompt "SIN INFORME MEDICO" ;
	SKIP For lmenu(2)
Define Bar 3 Of menucontex Prompt "SIN COMPROBANTE";
	SKIP For lmenu(3)
Define Bar 4 Of menucontex Prompt "S/COMPROB.+ S/INFORME" ;
	SKIP For lmenu(4)
Define Bar 5 Of menucontex Prompt "ESTUDIO NO REALIZADO" ;
	SKIP For lmenu(5)
Define Bar 6 Of menucontex Prompt "DETALLE INFORMES" ;
	SKIP For lmenu(6)
Define Bar 7 Of menucontex Prompt "ESTUDIO A REPETIR" ;
	SKIP For lmenu(7)
Define Bar 8 Of menucontex Prompt "SE ADJUNTAN ESTUDIOS ANTERIORES" ;
	SKIP For lmenu(8)
Define Bar 9 Of menucontex Prompt "RECEPCION INFORME" ;
	SKIP For lmenu(9)
Define Bar 10 Of menucontex Prompt "VISUALIZA TEXTO" ;
	SKIP For lmenu(10)
Define Bar 11 Of menucontex Prompt "VISUALIZA PDF" ;
	SKIP For lmenu(11)
Define Bar 12 Of menucontex Prompt "VISUALIZA IMAGEN" ;
	SKIP For lmenu(12)
Define Bar 13 Of menucontex Prompt "DETALLE VALE" ;
	SKIP For lmenu(13)
Define Bar 14 Of menucontex Prompt "DOCUMENTO / IMAGEN" ;
	SKIP For lmenu(14)

** Marcelo Torres, 14/08/2017
If Alen(lmenu) > 14
	Define Bar 15 Of menucontex Prompt "MARCAR REGISTRO PARA EXPORTAR" ;
		SKIP For lmenu(15)
    Define Bar 16 Of menucontex Prompt "EXPORTAR A PDF" ;
		SKIP For lmenu(16)
Endif

mcmd1= Alltrim(nameform)+'.menu(1)'
On Selection Bar 1 Of menucontex &mcmd1
mcmd2= Alltrim(nameform)+'.menu(2)'
On Selection Bar 2 Of menucontex  &mcmd2
mcmd3= Alltrim(nameform)+'.menu(3)'
On Selection Bar 3 Of menucontex  &mcmd3
mcmd4= Alltrim(nameform)+'.menu(4)'
On Selection Bar 4 Of menucontex  &mcmd4
mcmd5= Alltrim(nameform)+'.menu(5)'
On Selection Bar 5 Of menucontex  &mcmd5
mcmd6= Alltrim(nameform)+'.menu(6)'
On Selection Bar 6 Of menucontex  &mcmd6
mcmd7= Alltrim(nameform)+'.menu(7)'
On Selection Bar 7 Of menucontex  &mcmd7
mcmd8= Alltrim(nameform)+'.menu(8)'
On Selection Bar 8 Of menucontex  &mcmd8
mcmd9= Alltrim(nameform)+'.menu(9)'
On Selection Bar 9 Of menucontex  &mcmd9
mcmd10= Alltrim(nameform)+'.menu(10)'
On Selection Bar 10 Of menucontex  &mcmd10
mcmd11= Alltrim(nameform)+'.menu(11)'
On Selection Bar 11 Of menucontex  &mcmd11
mcmd12= Alltrim(nameform)+'.menu(12)'
On Selection Bar 12 Of menucontex  &mcmd12
mcmd13= Alltrim(nameform)+'.menu(13)'
On Selection Bar 13 Of menucontex  &mcmd13
mcmd14= Alltrim(nameform)+'.menu(14)'
On Selection Bar 14 Of menucontex  &mcmd14

If Alen(lmenu) > 14
	mcmd15= Alltrim(nameform)+'.menu(15)'
	On Selection Bar 15 Of menucontex &mcmd15
	
	mcmd16= Alltrim(nameform)+'.menu(16)'
	On Selection Bar 16 Of menucontex &mcmd16
Endif

Activate Popup menucontex Bar nbar
