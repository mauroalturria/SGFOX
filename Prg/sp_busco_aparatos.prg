*!*	-------------------------------------------------------------------
*!*	Aparatos
*!*	-------------------------------------------------------------------
Parameter mWhere, mCursor, mFechaHoy

if vartype(mCursor)#"C"
	mCursor = "mwkApa"
Endif 

if vartype(mFechaHoy) # "D" Or vartype(mFechaHoy) # "T"
	mFechaHoy = sp_busco_fecha_serv('DT')
Endif 

mFechaNull = '1900-01-01' 

mret = sqlexec(mcon1,"SELECT TabAparatos.* " + ;
	"FROM TabAparatos " + ;
	"Where (Apa_FecPasiva = ?mFechaNull Or Apa_FecPasiva > ?mFechaHoy) " +  mWhere + " " + ;
	"ORDER BY Apa_Descrip ", mCursor )

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "VALIDACION")
	Return .f. 
endif
