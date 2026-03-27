************************************************************************
* Esta rutina ejecuta el cursor de médicos que tienen
* prestaciones ya asignadas y que no se encuentra bloqueado para generar
* el archivo de busqueda de turnos
************************************************************************

parameter mddiasem, mdmasx
fechatop = ctod('01/01/1900')
marchivo = "Bus" + strtran(dtoc(mdmasx), '/','')

mret=sqlexec(mcon1," SELECT * FROM medpresta " + ;
	"WHERE diasem = ?mddiasem AND Codesp <> 'KINE' AND " + ;
	"fechaUltAgenda <= ?mdmasX AND " + ;
	"GeneraAgen = 1 AND Codmed IN " + ;
	"(SELECT id FROM Prestadores " + ;
	"WHERE (fecpasivap = ?fechatop or fecpasivap > ?mdmasx ) "+;
	"and (fecpasiva > ?mdmasX OR fecpasiva = ?fechatop) " +;
	"AND bloquedesde <?mdmasX and bloquehasta < ?mdmasX ) " +;
	"ORDER BY Codmed, diasem, horadesde, codesp ",'MWKmedpresta1')


if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR diasem, AVISAR A SISTEMAS",16, "Validacion")
	mret=0

else
	select * from MWKmedpresta1 into table &marchivo

endif


