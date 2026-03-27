Local lcResu
lcResu = ""

lnLen = Alen(item_vale,1)
lnCantVales = 0

For I = 1 To lnLen
	If !Empty(item_vale(I,1))
		lnCantVales = lnCantVales + 1
	Endif
Next

lcTituloAnt = "" && "Prestaciones " + Chr(10)
*!*	lcTituloAnt = ""
*!*	Do Case
*!*		Case dat_vale[2] = "TC"
*!*			lcTituloAnt = "Tomografía computada de "
*!*		Case dat_vale[2] = "RM"
*!*			lcTituloAnt = "Resonancia Nuclear Magnética de "
*!*		Otherwise
*!*			Messagebox(dat_vale[2],48,"NO CONTEMPLADO")
*!*	Endcase

lcTitulo = ""

For lnPresta = 1 To lnCantVales
	If Empty(lcTitulo)
		lcTitulo = Proper(Alltrim(item_vale(lnPresta,3)))
	Else
		lcTitulo = lcTitulo + Chr(10) + Proper(Alltrim(item_vale(lnPresta,3)))
	Endif 
Next 

*!*	If lnCantVales = 1
*!*		lnPos = At(",",lcTitulo,1)
*!*		If lnPos > 0
*!*			lcTitulo = Substr(lcTitulo,1, -1 + lnPos )
*!*		Endif 	
*!*	Endif 

lcResu =  lcTituloAnt + lcTitulo
Return lcResu
?lcResu