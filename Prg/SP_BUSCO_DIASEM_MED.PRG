*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
**********************************************************
*Busca Las prestaciones asignadas al médico
**********************************************************
if val(mcdiasem) > 0
	for i=1 to len(mcdiasem) step 1
		if isblank(mcwhere1) or (i=1)
			mcwhere1=" AND ("
		else
			mcwhere1=mcwhere1 + " OR "
		endif

		mcwhere1=mcwhere1+ "a.diasem =" + substr(mcdiasem,i,1) + ""
	endfor
else
	mcwhere1=""
endif

mret=sqlexec(mcon1,"SELECT a.codprest, b.PRE_descriprest, b.PRE_especialidad, a.codserv " + ;
	"FROM medpresta as a, prestacions as b " + ;
	"WHERE (a.codmed = ?mncodmed and a.codprest=b.PRE_codprest) and b.PRE_fechapasiva is null " +;
	 mcwhere1 + ") " + ;
	"Group by a.codprest " + ;
	"ORDER BY b.PRE_descriprest ","Mwkprestasig1")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0

endif
