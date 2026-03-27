****************************************************************
** Busco Reservados por tabla, por medico
****************************************************************
mddiasem=dow(mdmasX)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ' tabreservado.id>5000 and '	
endif
mret=sqlexec(mcon1,"SELECT * FROM tabreservado WHERE &mccpoamb centromedico = ?mxcentromedico and diasem = ?mddiasem " + ;
	"and codmed in (select codmed from medpresta where &mccpoamb diasem = ?mddiasem and "+;
	" fecvigend <> fecvigenh and ?mdmasX between fecvigend and fecvigenh ) " + ;
	" and ?mdmasX between fecvigend and fecvigenh " + ;
	" and fecvigend < fecvigenh " +;
	"order by tipoturno desc, codmed" ,"MWKResMedico")
if mret < 0
	messagebox('ERROR DE CURSOR, REINTENTE',16,'Validación')
	mret=0
endif
	If mxambito = 1
		mccpoamb = ' '
	Endif

