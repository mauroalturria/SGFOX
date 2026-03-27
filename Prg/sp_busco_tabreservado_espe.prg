*************************************************************
* Busco Reservados por tabla -Especialidad
* FECHA=26/03/2002 AUTOR:Claudia Antoniow
*
*************************************************************
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ' tabreservado.id>5000 and '	
endif
mret=sqlexec(mcon1,'SELECT * FROM tabreservado WHERE &mccpoamb centromedico = ?mxcentromedico and diasem=?mndiasem AND ' +;
	'?mdmasX between fecvigend and fecvigenh AND '+;
	'codesp is not Null AND codmed is null ' +;
	" and fecvigend < fecvigenh " +;
	'order by tipoturno desc,codesp asc','MWKResEspec')

if mret < 0
	messagebox('ERROR DE CURSOR, REINTENTE',16,'Validación')
	mret=0
endif
	If mxambito = 1
		mccpoamb = ' '
	Endif
