*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************

mdia = sp_busco_fecha_serv('DT')

mhhmmTur	= Val(Left(Ttoc(mthorad,2),2)+Substr(Ttoc(mthorad,2),4,2))

If Vartype(mcObservac)#'C'
	mcObservac = ' '
Endif
mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif
If Vartype( msolicigia)="N"
	mcicpoamb = mcicpoamb +",solicigia "
	mvicpoamb = mvicpoamb +",?msolicigia "
Endif
If Vartype(mbloqturent)<>"N"
	mbloqturent = 0
ENDIF
If Vartype(mnucodprest )<>"N"
	mnucodprest = 0
Endif
mret=SQLExec(mcon1,"INSERT INTO turnos (bloqueado,afiliado,codent,codesp,codmed,codserv,"+;
	"confirmado,diasem,fechatur,hhmmtur,horatur,tipotomado,"+;
	"tipoturno,usuariogenera, fechagenera, nrovale, observa,UsuarioSector,codprest &mcicpoamb,ambcentro ) " + ;
	"VALUES (?mbloqturent,?mcafil,?mncodent,?mccodesp,?mncodmed,?mncodserv,"+;
	"0,?mndiasem,?mtfechatur,?mhhmmTur,?mthorad,0,?mntipotur,"+;
	"?midusu, ?mdia, 0,?mcObservac,0,?mnucodprest &mvicpoamb ,?mxcentromedico )")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	Do prg_cancelo
Endif
