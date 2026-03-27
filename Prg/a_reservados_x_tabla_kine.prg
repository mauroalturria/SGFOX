******************************************************************
* AUTOR: Claudia Antoniow
* FECHA: 13/03/2002
* ULTIMA MODIFICACION: 05/06/2003
******************************************************************
*************************************************************
* Estos datos asterisqueados los trae de los otros programas
* mdmasx=ctod('01/07/2002')
* mddiasem=dow(mdmasx)
* do sp_conexion
**************************************************************
*mdmasX    =ctod('20/05/2004')
*mccodesp  ='FONI'

do sp_Busco_TabReservado_Kine
dimension tipot(20)
store 0 to tipot

sele MWKResMedico
go top
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
do while !eof('MWKResMedico')

	mntipotur = MWKResMedico.tipoturno
	mhRdesde  = MWKResMedico.horaRdesde
	mhRhasta  = MWKResMedico.horaRHasta
	mncodmed  = MWKResMedico.codmed
	store 0 to tipot
	if mxambito = 1
		mccpoamb = ' '
	endif
	if !isnull(mhRdesde)
		mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
			hour(mhRdesde),minute(mhRdesde),0)
		mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
			hour(mhRHasta),minute(mhRHasta),0)
		mret=sqlexec(mcon1,'select turnos.tipoturno from turnos,tabtipoturno '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
			'and horatur >= ?mthorad  and horatur < ?mthorah and tabtipoturno.tipoturno = turnos.tipoturno '+;
			'and (turnos.tipoturno<> 6 and tabtipoturno.grupo<>3) ','mwkTurctrl')
		tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')

		mret=sqlexec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
			'and horatur >= ?mthorad  and horatur < ?mthorah   '+;
			' and tipoturno <>6  and tipoturno not in (select tipoturno from tabtipoturno where grupo = 3) '+;
			' and tipoturno<> 9 ','mwkTurres')
		if mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

			if myip ='172.16.1.7'
				set step on
			endif
			messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
			mret = 0
		endif

	else
		mncrit     = MWKResMedico.criterio
		mncant_res = MWKResMedico.cantidad
		mthorad    = MWKResMedico.horadesde
		mthorah    = MWKResMedico.horahasta

		if mxambito = 1
			mccpoamb = ' '
		endif
		if nvl(mncant_res,0)=0
			for i=1 to 10 step 1
				mFldHorad = 'MWKResMedico.horaRes' + alltrim(str(i))
				mthora    = &mFldHorad
				if !isnull(mthora)
					mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
						hour(mthora),minute(mthora),0)
					mret=sqlexec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
						'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				' and tipoturno <>6  and tipoturno not in (select tipoturno from tabtipoturno where grupo = 3) '+;
				'and horatur = ?mthorar and tipoturno<> 9  ','mwkTurres')
					tipot(mntipotur) = tipot(mntipotur) + 1
					if mret < 0
						messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
						mret = 0
					endif
				endif
			endfor
		else
			do case
				case mncrit = 10
					do prg_proceso_porc_x_franja with mncant_res,mncodmed,mdmasx,;
						mntipotur,mddiasem,mthorad,mthorah
				case mncrit = 11
					do prg_proceso_cant_x_franja with mncant_res,mncodmed,mdmasx,;
						mntipotur,mddiasem,mthorad, mthorah
				case mncrit = 12

					do prg_proceso_cant_x_hora with mncant_res,mncodmed,mdmasx,;
						mntipotur,mddiasem,mthorad, mthorah
			endcase
		endif
	endif
	if mxambito = 1
		mccpoamb = ' '
	endif
	for itt = 1 to 20
		if tipot(itt) > 0
			ctipot = tipot(itt)
			mret=sqlexec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and tipoturno = ?itt and fechatur = ?mdmasX ','mwkTurresCtrl')
			if reccount('mwkTurresCtrl') < tipot(itt)
				mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb) "+;
					"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot , ?myip, 22 &mvicpoamb ) ")
			endif
		endif
	next itt

	skip 1 in MWKResMedico
	if eof('MWKResMedico')
		exit
	endif
enddo

do sp_Busco_TabReservado_Espe

sele MWKResEspec
go top
set filter to codesp=mccodesp

do while !eof('MWKResEspec')

	mntipotur = MWKResEspec.tipoturno
	mhRdesde  = MWKResEspec.horaRdesde
	mhRhasta  = MWKResEspec.horaRHasta
	mccodesp  = MWKResEspec.codesp
	mcdedonde ='dambula'
	do sp_medicos_espec_reservas
	if mxambito = 1
		mccpoamb = ' '
	endif
	do while !eof('mwkMedico')
		mncodmed=mwkMedico.id
		store 0 to tipot
		if !isnull(mhRdesde)
			mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
				hour(mhRdesde),minute(mhRdesde),0)
			mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
				hour(mhRHasta),minute(mhRHasta),0)
			mret=sqlexec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno<> 9 ','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')
			mret=sqlexec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
		' and tipoturno <>6  and tipoturno not in (select tipoturno from tabtipoturno where grupo = 3) '+;
				'and tipoturno<> 9 ','mwkTurres')
			if mret < 0
				messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
				mret = 0
			endif
		else
			mncrit     = MWKResEspec.criterio
			mncant_res = MWKResEspec.cantidad
			mthorad    = MWKResEspec.horadesde
			mthorah    = MWKResEspec.horahasta
			if mxambito = 1
				mccpoamb = ' '
			endif
			if nvl(mncant_res,0)=0
				for i=1 to 10 step 1
					mFldHorad = 'MWKResEspec.horaRes' + alltrim(str(i))
					mthora    = &mFldHorad
					if !isnull(mthora)
						mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
							hour(mthora),minute(mthora),0)
						mret=sqlexec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
		' and tipoturno <>6  and tipoturno not in (select tipoturno from tabtipoturno where grupo = 3) '+;
							'and horatur = ?mthorar and tipoturno<> 9 ','mwkTurres')
						tipot(mntipotur) = tipot(mntipotur) + 1

						if mret < 0
							messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
							mret = 0
						endif
					endif
				endfor
			else
				do case
					case mncrit = 10
						do prg_proceso_porc_x_franja with mncant_res,mncodmed,mdmasx,;
							mntipotur,mddiasem,mthorad,mthorah
					case mncrit = 11
						do prg_proceso_cant_x_franja with mncant_res,mncodmed,mdmasx,;
							mntipotur,mddiasem,mthorad, mthorah
					case mncrit = 12
						do prg_proceso_cant_x_hora with mncant_res,mncodmed,mdmasx,;
							mntipotur,mddiasem,mthorad, mthorah
				endcase
			endif

		endif
		skip 1 in mwkMedico
		if eof('mwkMedico')
			exit
		endif
	enddo
	if mxambito = 1
		mccpoamb = ' '
	endif
	for itt = 1 to 20
		if tipot(itt) > 0
			ctipot = tipot(itt)
			mret=sqlexec(mcon1,'select tipoturno from turnos '+;
				'where diasem = ?mddiasem and codmed = ?mncodmed '+ mccpoamb +;
				'and tipoturno = ?itt and fechatur = ?mdmasX ','mwkTurresCtrl')
			if reccount('mwkTurresCtrl') < tipot(itt)
				mret = sqlexec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb ) "+;
					"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot , ?myip, 22 &mvicpoamb ) ")

			endif
		endif
	next itt
	skip 1 in MWKResEspec
	if eof('MWKResEspec')
		exit
	endif
enddo
