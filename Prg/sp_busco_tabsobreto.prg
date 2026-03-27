****
**  Busco sobreturnos - sobreoferta - plan de salud
****
Parameter mcodmed, lvigen,vr_fecvig


If Vartype(vr_fecvig)<>"D"
	vr_fecvig = sp_busco_fecha_serv('DD')
ENDIF
mfecha = vr_fecvig 
 
If Type('lvigen') # "N"
	lvigen = 0
Endif

mccpoamb = ''
mccpoamb1 = ''

If mxambito > 1
	mccpoamb = " and codambito = ?mxambito "
	mccpoamb1 = " and medpresta.codambito = ?mxambito "

Endif

Use in select("mwkhoradoc1")
Use in select("mwkhoradoc2")
Use in select("mwkhoradoc3")
Use in select("mwkhoradoc4")
Use in select("mwkhoradoc6")
Use in select("mwkhoradoc7")

cvigen   = Iif(lvigen=0,'',' and fvigenh >= ?mfecha and fvigend <> fvigenh ')
cvigenmp = Iif(lvigen=0,'',' and fecvigenh >= ?mfecha and fecvigenh <> fecvigend ')

mret = SQLExec(mcon1, "select diasem, horadesde, horahasta, cantidad, porcentaje, " + ;
	"fvigend, fvigenh, id, codmed " + ;
	"from tabsobretoa " +  ;
	"where centromedico = ?mxcentromedico and codmed = ?mcodmed " + cvigen + mccpoamb +;
	"order by diasem, horadesde,fvigenH desc, fvigend desc", "mwkhoradoc1")

If mret < 0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mret = SQLExec(mcon1, "select medpresta.diasem, medpresta.horadesde, medpresta.horahasta, medpresta.fecvigend, medpresta.fecvigenh, medpresta.codmed " + ;
	"from medpresta inner join TabUbicacion "+;
	" on {fn concat({fn CONCAT(TabUbicacion.piso, TabUbicacion.descrip) },TabUbicacion.numero)} = MedPresta.sala " +  ;
	" where medpresta.diasem > 0 and medpresta.codmed = ?mcodmed and  TabUbicacion.centromedico = ?mxcentromedico " + cvigenmp + mccpoamb1 + ;
	" group by medpresta.codmed, medpresta.diasem, medpresta.horadesde, medpresta.horahasta, medpresta.fecvigend, medpresta.fecvigenh " + ;
	" order by medpresta.diasem, medpresta.horadesde, medpresta.horahasta, medpresta.fecvigenh desc, medpresta.fecvigend desc ", "mwkhoradoc2")
*"  and fecvigenh >= ?mfecha " + ;

If mret < 0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mret = SQLExec(mcon1, "select  diasem, horadesde, horahasta, cantidadps, fecvigend, " + ;
	"fecvigenh, id, codmed " + ;
	"from tabprepaga " +  ;
	"where centromedico = ?mxcentromedico and codmed = ?mcodmed " + cvigenmp + mccpoamb+;
	"order by  diasem, horadesde, fecvigenh desc, fecvigend desc", "mwkhoradoc3")
*and fecvigenh >= ?mfecha

If mret < 0
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

msql = " select iif(diasem = 2, 'Lun ', iif(diasem = 3, 'Mar ', " + ;
	"iif(diasem = 4, 'Mie ', iif(diasem = 5, 'Jue ', " + ;
	"iif(diasem = 6, 'Vie ', iif(diasem = 7, 'Sab ', 'Dom '))))))  + iif(isnull(horadesde),space(18),leftc(ttoc(horadesde,2), 5) " + ;
	"+ ' ' + left(ttoc(horahasta,2), 5)) as horario, " + ;
	"fvigend as desde, fvigenh as hasta, porcentaje, cantidad, " + ;
	"id, horadesde, horahasta, codmed from mwkhoradoc1 into cursor mwkhoradoc6"

msql1 = " select iif(diasem = 2, 'Lun ', iif(diasem = 3, 'Mar ', " + ;
	"iif(diasem = 4, 'Mie ', iif(diasem = 5, 'Jue ', " + ;
	"iif(diasem = 6, 'Vie ', iif(diasem = 7, 'Sab ', 'Dom '))))))  + iif(isnull(horadesde),space(18),leftc(ttoc(horadesde,2), 5) " + ;
	"+ ' ' + left(ttoc(horahasta,2), 5)) as horario, " + ;
	"fecvigend as fdesde, fecvigenh as fhasta, diasem, horadesde, horahasta, codmed " + ;
	"from mwkhoradoc2 into cursor mwkhoradoc7"

msql2 = " select iif(diasem = 2, 'Lun ', iif(diasem = 3, 'Mar ', " + ;
	"iif(diasem = 4, 'Mie ', iif(diasem = 5, 'Jue ', " + ;
	"iif(diasem = 6, 'Vie ', iif(diasem = 7, 'Sab ', 'Dom '))))))  + iif(isnull(horadesde),space(18),leftc(ttoc(horadesde,2), 5) " + ;
	"+ ' ' + left(ttoc(horahasta,2), 5)) as horario, " + ;
	"fecvigend as desde, fecvigenh as hasta, cantidadps, " + ;
	"id, horadesde, horahasta, codmed from mwkhoradoc3 into cursor mwkhoradoc8"

Return .T.
