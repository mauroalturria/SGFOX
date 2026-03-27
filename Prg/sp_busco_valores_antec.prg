Lparameters tnRegistracio, tcWhere , tcCursor

If Vartype(tcWhere) # "C" 
	tcWhere = ""
Endif 	

If Vartype(tcCursor) # "C" 
	tcCursor = "mwkAntecPac"
Endif 	

mfecNull = Ctod("01/01/1900")

mRet = Sqlexec(mcon1,"Select " + ;
	"CAST(STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS CHAR(80)) AS NOMBRE, " + ;
	"TabAntecPac.*, " + ;
	"TabEstados.Descrip as Familiar, " + ;
	"cast(TabAntecPac.AT_valor as Int) as At_ValorId, At_Alert " + ;
	"from TabAntecPac " + ;
	"Left Join TabEstados on TabAntecPac.AT_IdFam = TabEstados.Id " + ;
	"Left Join Prestadores on TabAntecPac.At_CodMed = Prestadores.Id " + ;
	"Left join TabMedExterno on TabAntecPac.At_CodMed = TabMedExterno.Id " + ;
	"Inner join TabAntecedentes on TabAntecedentes.Id = TabAntecPac.AT_IdAnt " + ;
	"where AT_registracio = ?tnRegistracio " + tcWhere + "" + ;
	"group by at_idant Order by TabAntecPac.ID desc", tcCursor)

If mRet <= 0

	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 