Parameters tnOpcion, tnCursor, tcWhere

If VarType(tcWhere) # "C"
	tcWhere = ""
Endif 

ldNull  = cTod("01/01/1900")

 USE IN SELECT(tnCursor)  
Do Case
	Case tnOpcion = 1
		lcSql = "SELECT * FROM TabQuiroProtoPrest " + tcWhere
	Case tnOpcion = 2
		lcSql = "SELECT TabQuiroProtoPrest.*, " + ;
			"Prestacions.Pre_Descriprest " + ;
			"FROM TabQuiroProtoPrest " + ;
			"Inner join Prestacions on Prestacions.Pre_CodPrest = TabQuiroProtoPrest.TPP_CodPrest " + ;
			"Where " + tcWhere
	
	Otherwise

Endcase 

if !Prg_EjecutoSql(lcSql,tnCursor,.f.)
	Return .f.
Endif 