*
* Menu btn dcho pasaje a facturacion
*
Lparameters nameform,lmenu,mtitulo,nbar

If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif

Define Popup menúcontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo

Define Bar 1 Of menúcontex Prompt "ENTREGADO A FACTURACION" ;
SKIP For lmenu(1)
Define Bar 2  Of menúcontex Prompt "RECIBIDO FACTURACION" ;
SKIP For lmenu(2)
Define Bar 3 Of menúcontex Prompt "DEVOLUCION" ;
SKIP For lmenu(3)
Define Bar 4 Of menúcontex Prompt "PARA CGA" ;
SKIP For lmenu(4)
Define Bar 5 Of menúcontex Prompt "RECIBIDO EN CGA" ;
SKIP For lmenu(5)
Define Bar 6 Of menúcontex Prompt "PENDIENTE" ;
SKIP For lmenu(6)
Define Bar 7 Of menúcontex Prompt "CERRADA" ;
SKIP For lmenu(7)

mcmd1 = Alltrim(nameform)+'.menu(1)'
On Selection Bar 1 Of menúcontex &mcmd1
mcmd2 = Alltrim(nameform)+'.menu(2)'
On Selection Bar 2 Of menúcontex  &mcmd2
mcmd3 = Alltrim(nameform)+'.menu(3)'
On Selection Bar 3 Of menúcontex  &mcmd3
mcmd4 = Alltrim(nameform)+'.menu(4)'
On Selection Bar 4 Of menúcontex &mcmd4
mcmd5 = Alltrim(nameform)+'.menu(5)'
On Selection Bar 5 Of menúcontex &mcmd5
mcmd6 = Alltrim(nameform)+'.menu(6)'
On Selection Bar 6 Of menúcontex &mcmd6
mcmd7 = Alltrim(nameform)+'.menu(7)'
On Selection Bar 7 Of menúcontex &mcmd7

 
Activate Popup menúcontex Bar nbar
