*       *********************************************************
*       *
*       * 04/11/2004           ADMHCEMENU.MPR            10:50:48
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
Define Bar 1 Of menucontex Prompt "CPC HCE - MEDICOS" ;
	SKIP For lmenu(1)
Define Bar 2 Of menucontex Prompt "CPC HCE - ENFERMERIA" ;
	SKIP For lmenu(2)
 

mcmd1= Alltrim(nameform)+'.menu(1)'
On Selection Bar 1 Of menucontex &mcmd1
mcmd2= Alltrim(nameform)+'.menu(2)'
On Selection Bar 2 Of menucontex  &mcmd2
 

Activate Popup menucontex Bar nbar
