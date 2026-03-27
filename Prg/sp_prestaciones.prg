*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* ULTIMA MODIFICACION:07/05/2002
*******************************
******************************************************************************
*Ejecuta el cursor de prestaciones filtrado por especialidad, recibe en una
*variable el codigo de médico que busca y en otra el codigo de la especialidad
******************************************************************************
lparameters nconmemo
if vartype(nconmemo) #"N"
	nconmemo = 0
endif

*do sp_conexion.prg
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
	mccpoambp =	",Tabprestambito.PA_turnosmultip "+;
		" FROM prestacions " + ;
		" left outer join TabPRESTambito ON ( Tabprestambito.pa_codiprest= pre_codprest and Tabprestambito.PA_codambito = ?mxambito ) "
else
	mccpoamb = ''
	mccpoambp =	",PRE_turnosMultip  as PA_turnosmultip "+;
		" FROM prestacions "
endif

mret=sqlexec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona ,"+;
	"PRE_codservicio,PRE_turnosMultip " + mccpoambp +;
	"WHERE PRE_fechapasiva is null and PRE_agendaturnos='S' "+;
	"and PRE_especialidad = ?mccodesp and " +;
	"PRE_codprest NOT IN (SELECT codprest from medpresta " + ;
	"WHERE codmed = ?mncodmed and codesp = ?mccodesp &mccpoamb ) " + ;
	"GROUP BY PRE_codprest " + ;
	"ORDER BY PRE_descriprest ","Mwkprestac")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR1, REINTENTE",16, "Validacion")
	mret=0
endif

*AND a.Horadesde IS NULL AND a.HoraHasta IS NULL


use in select('Mwkprestasig')
use in select('Mwkprestasigpre')

if  nconmemo = 0
	mret=sqlexec(mcon1,"SELECT a.codprest, b.PRE_descriprest, b.PRE_especialidad,b.pre_tipomuestra,b.PRE_Lateralidad ,b.PRE_tipozona , "+;
		"a.codserv, b.PRE_turnosMultip " + ;
		"FROM medpresta as a, prestacions as b " + ;
		"WHERE a.codmed = ?mncodmed and b.PRE_especialidad =?mccodesp " + ;
		"and a.codprest=b.PRE_codprest and PRE_fechapasiva is null " + mccpoamb + ;
		"GROUP BY b.PRE_codprest " + ;
		"ORDER BY b.PRE_descriprest ","Mwkprestasig")
else
	mret=sqlexec(mcon1,"SELECT a.codprest, b.PRE_descriprest, b.PRE_especialidad,b.pre_tipomuestra,b.PRE_Lateralidad ,b.PRE_tipozona , "+;
		"a.codserv, b.PRE_turnosMultip " + ;
		"FROM medpresta as a, prestacions as b " + ;
		"WHERE a.codmed = ?mncodmed and b.PRE_especialidad =?mccodesp " + ;
		"and a.codprest=b.PRE_codprest and PRE_fechapasiva is null " + mccpoamb +;
		" union all SELECT a.MEP_codprest as codprest, b.PRE_descriprest, b.PRE_especialidad,b.pre_tipomuestra,b.PRE_Lateralidad ,b.PRE_tipozona , "+;
		"b.PRE_codservicio as codserv, b.PRE_turnosMultip " + ;
		"FROM TabMEFranja,TabMEMedpresta as a, prestacions as b " + ;
		"WHERE TabMEFranja.MEF_codmed = ?mncodmed and TabMEFranja.id =  MEP_idFranja "+;
		" and b.PRE_especialidad =?mccodesp " + ;
		"and a.MEP_codprest=b.PRE_codprest and PRE_fechapasiva is null " + mccpoamb ,"Mwkprestasigpre")
	select * from Mwkprestasigpre group by  codprest order by PRE_descriprest into cursor Mwkprestasig
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR2, REINTENTE",16, "Validacion")
	mret=0
endif




