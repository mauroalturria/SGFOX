*********************************************************************************
* BUSCA PADRON OTROS
*********************************************************************************
parameter mbusco1

 
mret = sqlexec(mcon1,"SELECT Padotrosdatos.ID, Padotrosdatos.Campo, Padotrosdatos.Contenido," + ;
"  Padotrosdatos.FechaDesde, Padotrosdatos.FechaHasta," +;
"  Padcabe.NroAfiliado, Padcabe.Documento, Padcabe.ApeyNom " + ;
" FROM SQLUser.PadOtrosDatos Padotrosdatos, SQLUser.PadCabe Padcabe" +;
" WHERE Padcabe.ID = Padotrosdatos.IdPadCabe " + mbusco1 , "mwkbuspadr")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
Endif  

