*
* Menu btn dcho Informes
*
Lparameters nameform,lmenu,mtitulo,nbar

If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif

Define Popup menúcontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo

Define Bar 1 Of menúcontex Prompt "INICIO DE ESTUDIO";
	SKIP For lmenu(1)
Define Bar 2 Of menúcontex Prompt "FIN DE ESTUDIO" ;
	SKIP For lmenu(2)
Define Bar 3 Of menúcontex Prompt "AUSENTE" ;
	SKIP For lmenu(3)
Define Bar 4 Of menúcontex Prompt "ESTUDIO NO REALIZADO" ;
	SKIP For lmenu(4)
*!*	Define Bar 5 Of menúcontex Prompt "RECIBIDO EN FACT." ;
*!*		SKIP For lmenu(5)
*!*	Define Bar 6 Of menúcontex Prompt "PARA ARCHIVO" ;
*!*		SKIP For lmenu(6)
*!*	Define Bar 7 Of menúcontex Prompt "PRESTAMO" ;
*!*		SKIP For lmenu(7)
*!*	Define Bar 8 Of menúcontex Prompt "RETENIDA POR LEGALES" ;
*!*		SKIP For lmenu(8)
*!*	 
mcmd1 = Alltrim(nameform)+'.menu(1)'
On Selection Bar 1 Of menúcontex &mcmd1
mcmd2 = Alltrim(nameform)+'.menu(2)'
On Selection Bar 2 Of menúcontex  &mcmd2
mcmd3 = Alltrim(nameform)+'.menu(3)'
On Selection Bar 3 Of menúcontex  &mcmd3
mcmd4 = Alltrim(nameform)+'.menu(4)'
On Selection Bar 4 Of menúcontex  &mcmd4
*!*	mcmd5 = Alltrim(nameform)+'.menu(5)'
*!*	On Selection Bar 5 Of menúcontex  &mcmd5
*!*	mcmd6 = Alltrim(nameform)+'.menu(6)'
*!*	On Selection Bar 6 Of menúcontex  &mcmd6
*!*	mcmd7 = Alltrim(nameform)+'.menu(7)'
*!*	On Selection Bar 7 Of menúcontex  &mcmd7
*!*	mcmd8 = Alltrim(nameform)+'.menu(8)'
*!*	On Selection Bar 8 Of menúcontex  &mcmd8
*!*	mcmd9 = Alltrim(nameform)+'.menu(9)'
*!*	On Selection Bar 9 Of menúcontex  &mcmd9
*!*	mcmd10 = Alltrim(nameform)+'.menu(10)'
*!*	On Selection Bar 10 Of menúcontex  &mcmd10
*!*	mcmd11 = Alltrim(nameform)+'.menu(11)'
*!*	On Selection Bar 11 Of menúcontex  &mcmd11
*!*	mcmd12 = Alltrim(nameform)+'.menu(12)'
*!*	On Selection Bar 12 Of menúcontex  &mcmd12
*!*	mcmd13 = Alltrim(nameform)+'.menu(13)'
*!*	On Selection Bar 13 Of menúcontex  &mcmd13
Activate Popup menúcontex Bar nbar
