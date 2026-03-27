*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
***************************************************
* Calculo el porcentaje de sobreoferta ingresado
*
***************************************************
lparameters mtipotu
if vartype(mtipotu)#"N"
	ctpo = "0,5,7"
else
	ctpo = transf(mtipotu)
endif

mtfechr=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(MwkSobre.horahasta),minute(MwkSobre.horahasta),0)
mtfechr2=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(MwkSobre.horadesde),minute(MwkSobre.horadesde),0)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret=sqlexec(mcon1,"SELECT fechatur, diasem,Count(horatur)as Cantur,"+;
	"(Count(horatur)*?mnporc) as porc " + ;
	"FROM Turnos  " + ;
	"WHERE &mccpoamb codmed =?mncodmed AND tipoturno in (&ctpo) " +;
	" AND fechatur = ?mtfechatur AND diasem = ?mndiasem " +;
	" AND horatur >= ?mtfechr2 And horatur <= ?mtfechr " +;
	"GROUP BY fechatur " + ;
	"ORDER BY fechatur",'MwkPorcSOfer')

if mret < 0
	messagebox('ERROR DE CURSOR PORCENTAJES, REINTENTE',16,'Validación')
	mret=0
endif

