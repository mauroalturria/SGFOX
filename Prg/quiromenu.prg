Lparameters nameform,lmenu,mtitulo,nbar,bandera

If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif

Define Popup menucontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo

Do Case
Case  bandera = 1
	Define Bar 1 Of menucontex Prompt "ASIGNAR PACIENTE" ;
		SKIP For lmenu(2)
	mcmd1= Alltrim(nameform)+'.menu(1)'
	On Selection Bar 1 Of menucontex &mcmd1
Case  bandera = 2
	Define Bar 1 Of menucontex Prompt "BORRAR PACIENTE" ;
		SKIP For lmenu(2)
	mcmd1= Alltrim(nameform)+'.menu(2)'
	On Selection Bar 1 Of menucontex &mcmd1
Case  bandera = 3
	Define Bar 1 Of menucontex Prompt "ASIGNAR PACIENTE" ;
		SKIP For lmenu(1)
	Define Bar 2 Of menucontex Prompt "BORRAR PACIENTE" ;
		SKIP For lmenu(2)
	mcmd1= Alltrim(nameform)+'.menu(1)'
	On Selection Bar 1 Of menucontex &mcmd1
	mcmd1= Alltrim(nameform)+'.menu(2)'
	On Selection Bar 2 Of menucontex &mcmd1

Case  bandera = 4

	Define Bar 4 Of menucontex Prompt "PISOS HCE - MEDICOS " ;
		SKIP For lmenu(1)
		
	mcmd1= Alltrim(nameform)+'.menu(4)'
	On Selection Bar 4 Of menucontex &mcmd1

Endcase

Activate Popup menucontex Bar nbar