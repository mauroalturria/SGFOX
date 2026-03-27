******************************************************************
* AUTOR: Claudia Antoniow
* FECHA: 13/03/2002
* ULTIMA MODIFICACION: 21/04/2002
******************************************************************
*************************************************************
* Estos datos asterisqueados los trae de los otros programas
* mdmasx=ctod('01/07/2002')
*mddiasem=dow(mdmasx)
*do sp_conexion
**************************************************************

do sp_Busco_TabReservado_med
dimension ntipot(20)
store '' to ntipot
mret = SQLExec(mcon1, "SELECT tipoturno, Abreviatura FROM Tabtipoturno ", "mwkTTCXN")
select mwkTTCXN
scan
	if tipoturno>0
		ntipot(tipoturno)=Abreviatura
	endif
endscan
use in select('controlturno')
create cursor  controlturno (codmed n(9),nombre c(100),cantfranja n(5),cantreal n(5),tipoturno n(2),descrip c(5))

if mxambito >1
	mccpoamb = " codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif


sele MWKResMedico
go top
dimension tipot(20)
store 0 to tipot
do while !eof('MWKResMedico')

	mntipotur = MWKResMedico.tipoturno
	mhRdesde  = MWKResMedico.horaRdesde
	mhRhasta  = MWKResMedico.horaRHasta
	mncodmed  = MWKResMedico.codmed
	store 0 to tipot
	if !isnull(mhRdesde)
		mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mhRdesde),minute(mhRdesde),0)
		mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mhRHasta),minute(mhRHasta),0)
		mret=sqlexec(mcon1,'select tipoturno from turnos '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
			'and horatur >= ?mthorad  and horatur < ?mthorah '+;
			'and tipoturno = 0','mwkTurctrl')
		tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')
		mret=sqlexec(mcon1,'update turnos set tipoturno=?mntipotur '+;
			'where diasem=?mddiasem and codmed=?mncodmed and horatur >=?mthorad  '+;
			'and horatur <?mthorah and tipoturno=0','mwkTurres')
		if mret < 0
			mret = 0
		endif
	else
		for i=1 to 10 step 1
			mFldHorad = 'MWKResMedico.horaRes' + alltrim(str(i))
			mthora    = &mFldHorad
			if !isnull(mthora)
				mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthora),minute(mthora),0)
				mret=sqlexec(mcon1,'update turnos set tipoturno=?mntipotur '+;
					'where diasem=?mddiasem and codmed=?mncodmed and horatur =?mthorar '+;
					'and tipoturno=0','mwkTurres')
				tipot(mntipotur) = tipot(mntipotur) +1
				if mret < 0
					mret = 0
				endif
			endif
		endfor
	endif
	for itt = 1 to 20
		if tipot(itt) > 0
			mret=sqlexec(mcon1,'select tipoturno,nombre from turnos,prestadores '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed and codmed = prestadores.id '+;
				'and tipoturno = ?itt and fechatur = ?mdmasX','mwkTurresCtrl')
			if reccount('mwkTurresCtrl') < tipot(itt)
				insert into controlturno values (mncodmed,mwkTurresCtrl.nombre ,tipot(itt),reccount('mwkTurresCtrl') ,itt,ntipot(itt))
				mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
					"values (  ?mncodmed, ?itt, ?mdmasX, ?tipot(itt) , ?myip, 22 &mvicpoamb) ")
			endif
		endif
	next itt

	skip 1 in MWKResMedico
	if eof('MWKResMedico')
		exit
	endif
enddo

do sp_Busco_TabReservado_espe

do while !eof('MWKResEspec')

	mntipotur = MWKResEspec.tipoturno
	mhRdesde  = MWKResEspec.horaRdesde
	mhRhasta  = MWKResEspec.horaRHasta
	mccodesp  = MWKResEspec.codesp
	mcdedonde ='dambula'
	do sp_medicos_espec_reservas

	do while !eof('mwkMedico')
		mncodmed=mwkMedico.id
		store 0 to tipot
		if !isnull(mhRdesde)
			mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mhRdesde),minute(mhRdesde),0)
			mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mhRHasta),minute(mhRHasta),0)
			mret=sqlexec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno = 0','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')
			mret=sqlexec(mcon1,'update turnos set tipoturno=?mntipotur '+;
				'where diasem=?mddiasem and codmed=?mncodmed and horatur >=?mthorad  '+;
				'and horatur <?mthorah and tipoturno=0','mwkTurres')
			if mret < 0
*wait windows 'NO!' timeout 0.3
				mret = 0
			endif
		else
			for i=1 to 10 step 1
				mFldHorad = 'MWKResEspec.horaRes' + alltrim(str(i))
				mthora    = &mFldHorad
				if !isnull(mthora)
					mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthora),minute(mthora),0)
					mret=sqlexec(mcon1,'update turnos set tipoturno=?mntipotur '+;
						'where diasem=?mddiasem and codmed=?mncodmed and horatur=?mthorar '+;
						'and tipoturno=0','mwkTurres')
					tipot(mntipotur) = tipot(mntipotur) +1
					if mret < 0
*wait windows 'NO!' timeout 0.3
						mret = 0
					endif
				endif
			endfor
		endif
		for itt = 1 to 20
			if tipot(itt) > 0
				mret=sqlexec(mcon1,'select tipoturno,nombre from turnos,prestadores '+;
					'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed and codmed = prestadores.id '+;
					'and tipoturno = ?itt and fechatur = ?mdmasX ','mwkTurresCtrl')
				if reccount('mwkTurresCtrl') < tipot(itt)
					insert into controlturno values (mncodmed,mwkTurresCtrl.nombre ,tipot(itt),reccount('mwkTurresCtrl') ,itt,ntipot(itt))
					mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
						"values (  ?mncodmed, ?itt, ?mdmasX, tipot(itt) , ?myip, 22 &mvicpoamb) ")
				endif
			endif
		next itt

		skip 1 in mwkMedico
		if eof('mwkMedico')
			exit
		endif
	enddo
	skip 1 in MWKResEspec
	if eof('MWKResEspec')
		exit
	endif
enddo
if reccount('controlturno')>0
	select controlturno
	go top
	mfecha = date()
	mcpathact = allt(sys(5))+sys(2003)
	cd "C:\tempdoc"
	i=0
	mcarch = "RES"+ alltrim(dtos(mfecha))+'.xls'
	do while file(mcarch )
		i=i+1
		mcarch = "RES"+ alltrim(dtos(mfecha))+alltrim(str(i,2,0))+'.xls'
	enddo
	copy to &mcarch type xl5
	cd alltrim(mcpathact)
	messagebox("FALTO TIPIFICAR ALGUNOS TURNOS, CONTROLE EL ARCHIVO QUE SE ENCUENTRA EN LA CARPETA TEMPDOC LLAMADO "+MCARCH,64,"Control de Turnos")
endif

