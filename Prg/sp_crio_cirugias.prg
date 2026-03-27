********************************
** Generar Crio cirugías
** Dra Vargas Anabel
*******************************

mcafil=0
mncodent=0
mccodesp=''
mncodmed=280
mncodserv=0

mccpoamb = ''
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif


mtfechatur=mdmasx
mthorad=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),08,0,0)
mthorah=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),11,0,0)
mtdura=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),0,15,0)
mntipotur=0

do while mthorad < mthorah
	mhhmmTur	= val(left(ttoc(mthorad,2),2)+substr(ttoc(mthorad,2),4,2))
	mret=sqlexec(mcon1,"INSERT INTO turnos (afiliado,codent,codesp,codmed,codserv,"+;
		"confirmado,diasem,fechatur,hhmmtur,horatur,tipotomado,tipoturno,"+;
		"usuario,observa,UsuarioSector,codprest &mcicpoamb) " + ;
		"VALUES (?mcafil,?mncodent,?mccodesp,?mncodmed,?mncodserv,"+;
		"0,?mddiasem,?mtfechatur,?mhhmmTur,?mthorad,0,?mntipotur,?midusu, ' ',0,?mnucodprest  &mvicpoamb)")

	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		mret=0
	endif

	mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
enddo

mthorad=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),11,0,0)
mthorah=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),13,0,0)
mtdura=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),0,30,0)
mntipotur=4
If Vartype(mnucodprest )<>"N"
	mnucodprest = 0
Endif
do while mthorad < mthorah
	mhhmmTur	= val(left(ttoc(mthorad,2),2)+substr(ttoc(mthorad,2),4,2))
	mret=sqlexec(mcon1,"INSERT INTO turnos (afiliado,codent,codesp,codmed,codserv,"+;
		" confirmado,diasem,fechatur,hhmmtur,horatur,tipotomado,tipoturno,"+;
		"usuario, observa,UsuarioSector,codprest  &mcicpoamb) " + ;
		"VALUES (?mcafil,?mncodent,?mccodesp,?mncodmed,?mncodserv,"+;
		" 0,?mddiasem,?mtfechatur,?mhhmmTur,?mthorad,0,?mntipotur,?midusu, ' ',0,?mnucodprest  &mvicpoamb)")

	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
		mret=0
	endif

	mthorad = SumaTime(mthorad,mtdura,mtfechatur,0)
enddo



************************************************************
************************************************************
function SumaTime(vrFechaHr1,vrFechaHr2,vrFechaX,vrMinu_mas)
************************************************************
	mttot_min1 =0
	mttot_min2 =0
	if !isblank(vrfechax)
		mddate = vrFechaX
	else
		if used('MWKFecServ')
			mddate = iif(('MWKFecServ.fechaHora')#'T',ttod(MWKFecServ.fechaHora),MWKFecServ.fechaHora)
		else
			mddate = sp_busco_fecha_serv('DD')
		endif
	endif
	if !isblank(vrFechaHr1)
		mttot_min1 = hour(vrFechaHr1)*60 + minute(vrFechaHr1)
	endif
	if !isblank(vrFechaHr2)
		mttot_min2  = hour(vrFechaHr2)*60 + minute(vrFechaHr2)
	endif
	mnsumat    = mttot_min1 + mttot_min2+vrMinu_mas

	if mnsumat > 0
		if int(mnsumat/60) >= 24
			mthr  = int(mnsumat/60)%24     &&Modulo 24
		else
			mthr  = int(mnsumat/60)
		endif
		mtmin = (mnsumat % 60)   &&Modulo 60

		mdtime= datetime(year(mddate),month(mddate),day(mddate),mthr,mtmin,0)
****************************
* Armo el string del time
*****************************
		mchr  = strtran(str(mthr,2),' ','0')
		mcmin = strtran(str(mtmin,2),' ','0')
		mttime = mchr + ':' + mcmin + ':00'
	endif
	return mdtime
