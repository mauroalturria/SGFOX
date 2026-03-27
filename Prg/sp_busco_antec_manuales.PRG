Lparameters tcCodEsp, tnRegistracio, tcWhere, tcCursor

*!*	tnRegistracio = 820225
*!*	tcCodEsp = 'OBST'
*!*	tcWhere = ''
*!*	tcCursor = 'mwkM'

mRet = Sqlexec(mcon1,"Select TabAntecedentes.*, " + ;
	"CAST(STRING(NVL(Prestadores.NOMBRE,''), NVL(TabMedExterno.nombre,' ')) AS CHAR(80)) AS NOMBRE, " + ;
	"TabAntecPac.ID AS IdAntPac, " + ;
	"TabAntecPac.AT_Alert, TabAntecPac.AT_IdAnt, TabAntecPac.AT_IdFam, TabAntecPac.AT_Obs, TabAntecPac.AT_valor, " + ;
	"TabAntecPac.AT_codmed, TabAntecPac.AT_FecAlta, TabAntecPac.AT_fpasiva, TabAntecPac.AT_registracio, " + ;
	"TabEstados.Descrip as Familiar, " + ;
	"cast(TabAntecPac.AT_valor as Int) as At_ValorId, At_Alert " + ;
	"from TabAntecedentes " + ;
	"Left Join TabAntecPac on TabAntecPac.At_IdAnt = TabAntecedentes.Id and AT_registracio = ?tnRegistracio " + ;
	"Left Join TabEstados on TabAntecPac.AT_IdFam = TabEstados.Id " + ;
	"Left Join Prestadores on TabAntecPac.At_CodMed = Prestadores.Id " + ;
	"Left join TabMedExterno on TabAntecPac.At_CodMed = TabMedExterno.Id " + ;
	"where TA_CodEsp = ?tcCodEsp and Trim(Ta_Tipo) = 'M' " + ;
	" " + tcWhere , tcCursor)

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  