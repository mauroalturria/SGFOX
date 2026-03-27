lparameters nameform,lmenu,mtitulo,nbar
if type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
endif
DEFINE POPUP menucontex SHORTCUT RELATIVE FROM MROW(),MCOL() title mtitulo
DEFINE BAR 1 OF menucontex PROMPT "ASIGNAR QUIROFANO" ;
	SKIP FOR lmenu(1)
mcmd1= alltrim(nameform)+'.menu(1)'
ON SELECTION BAR 1 OF menucontex &mcmd1

ACTIVATE POPUP menucontex bar nbar