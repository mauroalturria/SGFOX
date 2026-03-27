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
Lparameters nameform,lmenu,mtitulo,nbar
If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif
Define Popup menucontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo
Define Bar 1 Of menucontex Prompt "ALTA COMPLEJIDAD" ;
	SKIP For lmenu(1)
Define Bar 2 Of menucontex Prompt "LABORATORIO" ;
	SKIP For lmenu(2)
Define Bar 3 Of menucontex Prompt "INFORMES";
	SKIP For lmenu(3)
Define Bar 4 Of menucontex Prompt "HCE" ;
	SKIP For lmenu(4)
Define Bar 5 Of menucontex Prompt "EGRESO DE PACIENTES" ;
	SKIP For lmenu(5)
Define Bar 6 Of menucontex Prompt "INTERCONSULTA" ;
	SKIP For lmenu(6)
Define Bar 7 Of menucontex Prompt "REGISTRO DE RECIEN NACIDO" ;
	SKIP For lmenu(7)
Define Bar 8 Of menucontex Prompt "EVALUACIÓN DE PACIENTE" ;
	SKIP For lmenu(8)
Define Bar 9 Of menucontex Prompt "PISOS HCE - MEDICOS" ;
	SKIP For lmenu(9)
Define Bar 10 Of menucontex Prompt "PISOS HCE - ENFERMERIA" ;
	SKIP For lmenu(10)
Define Bar 11 Of menucontex Prompt "DEMORAS Y DIFICULTADES" ;
	SKIP For lmenu(11)
Define Bar 12 Of menucontex Prompt "PISOS HCE - AUDITORES" ;
	SKIP For lmenu(12)
Define Bar 13 Of menucontex Prompt "ENFERMERIA - E C G " ;
	SKIP For lmenu(13)

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
mcmd11 = Alltrim(nameform)+'.menu(11)'
On Selection Bar 11 Of menucontex &mcmd11
mcmd12 = Alltrim(nameform)+'.menu(12)'
On Selection Bar 12 Of menucontex &mcmd12
mcmd13 = Alltrim(nameform)+'.menu(13)'
On Selection Bar 13 Of menucontex &mcmd13

Activate Popup menucontex Bar nbar
