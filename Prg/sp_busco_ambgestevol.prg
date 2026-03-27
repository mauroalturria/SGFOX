Lparameters tcCursor, tcWhere

If Parameters() < 1
	tcCursor = "mwkAmbGestEvol"
Endif 

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif 

If Not "WHERE" $ UPPER(tcWhere) And !Empty(tcWhere)
	tcWhere = "Where " + tcWhere
Endif 	

mRet = SQLExec(mcon1,"Select TabAmbGestEvol.*, " + ;
	"a.Descrip as AGE_dinamUterTxt, " + ;
	"b.Descrip as AGE_tonoUterTxt " + ;
	"from TabAmbGestEvol " + ;
	"Left join TabEstados as a on a.Id = TabAmbGestEvol.AGE_dinamUter " + ;
	"Left join TabEstados as b on b.Id = TabAmbGestEvol.AGE_tonoUter " + ;
	" " + tcWhere + " " , tcCursor)

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 