Lparameters nameform,lmenu,mtitulo,nbar
SET STEP ON 
If Type('mtitulo')#"C"
	mtitulo = "Seleccione Opcion"
Endif

Define Popup menucontex SHORTCUT Relative From Mrow(),Mcol() Title mtitulo
Define Bar 1 Of menucontex Prompt "VISUALIZA RESPUESTAS" ;
	SKIP For lmenu(1)
Define Bar 2 Of menucontex Prompt "VISUALIZA ARCHIVOS" ;
	SKIP For lmenu(2)
*!*	Define Bar 3 Of menucontex Prompt "VISUALIZA ARCHIVOS Y RESPUESTAS";
*!*		SKIP For lmenu(3) 
mcmd1= Alltrim(nameform)+'.menu(1)'
On Selection Bar 1 Of menucontex &mcmd1
mcmd2= Alltrim(nameform)+'.menu(2)'
On Selection Bar 2 Of menucontex  &mcmd2
*!*	mcmd3= Alltrim(nameform)+'.menu(3)'
*!*	On Selection Bar 3 Of menucontex  &mcmd3 
	Activate Popup menucontex Bar nbar
