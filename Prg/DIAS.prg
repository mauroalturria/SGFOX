Clear

ldFecha = Ctod("01/07/2015")

lcAno = Transform(Year(ldFecha))
lcMes = Transform(cMonth(ldFecha))

?lcAno
?lcMes 

ldFecha1 = Ctod("01/" + Transform(Month(ldFecha)) + "/" + lcAno)
ldFecha2 = Ctod("01/" + Transform(Month(ldFecha)+1) + "/" + lcAno)-1

?"--"
?ldFecha1 
?ldFecha2 


lnDiaSem = Dow(ldFecha1) && arranca del domingo 1
?lnDiaSem

If lnDiaSem <> 1
	ldFecIni = ldFecha1 - (lnDiaSem)
Endif 

?ldFecIni


