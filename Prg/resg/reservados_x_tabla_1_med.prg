*************************************************************
* AUTOR: Claudia Antoniow
* FECHA: 13/03/2002
* ULTIMA MODIFICACION: 05/06/2003
*************************************************************
*************************************************************
* Estos datos asterisqueados los trae de los otros programas
* mdmasx=ctod('30/03/2002')
* mddiasem=dow(mdmasx)
* mncodemed=156
* mccodesp='CLIN'
* do sp_conexion
**************************************************************
parameter vr_tipotur, vr_thorad, vr_thorah
dimension tipot(20)
store 0 to tipot
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ' tabreservado.id>5000 and '
endif
mret=SQLExec(mcon1,'SELECT tabreservado.* FROM tabreservado,tabtipoturno WHERE   '+;
	' tabreservado.tipoturno= tabtipoturno.tipoturno and &mccpoamb diasem  = ?mddiasem ' +;
	'and codmed = ?mncodmed ' +  vr_tipotur +;
	'and ?mdmasX between fecvigend and fecvigenh and fecvigenh <> fecvigend ' ,'MWKResMedico')

if mret < 0
	mret = 0
else

	do while !eof('MWKResMedico') and MWKResMedico.codmed=mncodmed
		mntipotur = MWKResMedico.tipoturno
		mhRdesde  = MWKResMedico.horaRdesde
		mhRhasta  = MWKResMedico.horaRHasta
		do case
			case ctot(ttoc(vr_thorad,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorad,2)) >ctot(ttoc(MWKResMedico.horaRdesde,2))
				mhRdesde  = MWKResMedico.horaRdesde
			case ctot(ttoc(vr_thorah,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorah ,2)) <ctot(ttoc(MWKResMedico.horaRHasta,2))
				mhRhasta  = MWKResMedico.horaRHasta
			otherwise
				mhRdesde   = vr_thorad
				mhRhasta   = vr_thorah
		endcase

		if  (ttoc(MWKResMedico.horahasta-1,2)< ttoc(mhRdesde ,2) or ttoc(MWKResMedico.horadesde,2) >ttoc(mhRhasta  ,2))
			skip 1 in MWKResMedico
			if eof('MWKResMedico')
				exit
			else
				loop
			endif
		endif


		mncodmed  = MWKResMedico.codmed

		if !isnull(MWKResMedico.horaRdesde)
* armo la hora que necesito buscar
			if ttoc(mhRdesde,2)   > ttoc(MWKResMedico.horadesde,2)
				mthorad_ini   = mhRdesde
			else
				mthorad_ini   = MWKResMedico.horadesde
			endif
			if ttoc(mhRhasta,2)   <ttoc(MWKResMedico.horahasta,2)
				mthorah_ini   = mhRhasta
			else
				mthorah_ini   = MWKResMedico.horahasta
			endif
			mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthorad_ini),minute(mthorad_ini ),0)
			mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthorah_ini),minute(mthorah_ini),0)
			if mxambito =1
				mccpoamb =''
			endif
			mret=SQLExec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno in (0,4)','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')

			mret=SQLExec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
				'where &mccpoamb diasem = ?mddiasem and codmed =?mncodmed '+;
				'and horatur >=?mthorad  and horatur < ?mthorah ' +;
				'and tipoturno in (0,4) ','mwkTurres')
			if mret < 0
				mret = 0
			endif
		else
			mncrit     = MWKResMedico.criterio
			mncant_res = MWKResMedico.cantidad
			mhRdesde  = MWKResMedico.horaRdesde
			mhRhasta  = MWKResMedico.horaRHasta
			do case
				case ctot(ttoc(vr_thorad,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorad,2)) >ctot(ttoc(MWKResMedico.horaRdesde,2))
					mhRdesde  = MWKResMedico.horaRdesde
				case ctot(ttoc(vr_thorah,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorah,2)) <ctot(ttoc(MWKResMedico.horaRHasta,2))
					mhRhasta  = MWKResMedico.horaRHasta
				otherwise
					mhRdesde   = vr_thorad
					mhRhasta   = vr_thorah

			endcase

*mthorad    = MWKResMedico.horadesde
*mthorah    = MWKResMedico.horahasta
			if nvl(mncant_res,0)=0
				for i=1 to 10 step 1
					mFldHorad = 'MWKResMedico.horaRes' + alltrim(str(i))
					mthora    = &mFldHorad
					if mxambito =1
						mccpoamb =''
					endif
					if !isnull(mthora)
						mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),hour(mthora),minute(mthora),0)
						mret=SQLExec(mcon1,'select tipoturno from turnos '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar '+;
							'and tipoturno in (0,4)','mwkTurctrl')
						tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')

						mret = SQLExec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar and tipoturno in (0,4)','mwkTurres')
						if mret < 0
						Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

							if myip ='172.16.1.7'
								set step on
							endif
							messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
							mret = 0
						endif
					endif
				endfor
			else
				do case
					case mncrit = 10
						do prg_proceso_porc_x_franja with mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
					case mncrit = 11
						do prg_proceso_cant_x_franja with mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
					case mncrit = 12

						do prg_proceso_cant_x_hora with mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
				endcase
			endif
		endif
		if eof('MWKResMedico')
			exit
		else
			skip 1 in MWKResMedico
		endif
	enddo
endif

**Nuevo controlar
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ' tabreservado.id>5000 and '
endif
mret=SQLExec(mcon1,'SELECT tabreservado.* FROM tabreservado,tabtipoturno WHERE   tabreservado.tipoturno= tabtipoturno.tipoturno and  &mccpoamb diasem=?mddiasem AND codmed is null '+;
	' And ?mdmasX between fecvigend and fecvigenh and fecvigenh <> fecvigend ' +  vr_tipotur +;
	' AND codesp in (select codesp from medpresta' +;
	' where &mccpoamb codmed =?mncodmed group by codesp)','MWKResEspec')
if mret < 0
	mret=0
else

	do while !eof('MWKResEspec')

		mntipotur = MWKResEspec.tipoturno
		mhRdesde  = MWKResEspec.horaRdesde
		mhRhasta  = MWKResEspec.horaRHasta
		do case
			case ctot(ttoc(vr_thorad,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorad,2)) >ctot(ttoc(MWKResEspec.horaRdesde,2))
				mhRdesde  = MWKResEspec.horaRdesde
			case ctot(ttoc(vr_thorah,2)) = ctot('00:00:00') or  ctot(ttoc(vr_thorah,2)) <ctot(ttoc(MWKResEspec.horaRHasta,2))
				mhRhasta  = MWKResEspec.horaRHasta
			otherwise
				mhRdesde   = vr_thorad
				mhRhasta   = vr_thorah


		endcase
		if  (ttoc(MWKResMedico.horahasta-1,2)< ttoc(mhRdesde ,2) or ttoc(MWKResMedico.horadesde,2)>ttoc(mhRhasta  ,2))
			skip 1 in MWKResEspec
			if eof('MWKResEspec')
				exit
			else
				loop
			endif

		endif



		mccodesp  = MWKResEspec.codesp


*mcdedonde ='dambula'
*do sp_medicos_espec_reservas

*do while !eof('mwkMedico')

		mncodmed=mwkMedico.id

		if !isnull(mhRdesde)
			mthorad = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
				hour(mhRdesde),minute(mhRdesde),0)
			mthorah = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
				hour(mhRhasta),minute(mhRhasta),0)
			if mxambito = 1
				mccpoamb = ' '
			endif

			mret=SQLExec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno = 0 ','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')
			mret=SQLExec(mcon1,'update turnos set tipoturno=?mntipotur '+;
				'where &mccpoamb diasem=?mddiasem and codmed=?mncodmed '+;
				'and horatur >=?mthorad  and horatur <?mthorah and tipoturno = 0 ','mwkTurres')
			if mret < 0
*wait windows 'NO!' timeout 0.3
				mret = 0
			endif
		else
			if mxambito = 1
				mccpoamb = ' '
			endif
			mncrit     = MWKResEspec.criterio
			mncant_res = MWKResEspec.cantidad
			mthorad    = MWKResEspec.horadesde
			mthorah    = MWKResEspec.horahasta
			if nvl(mncant_res,0)=0
				for i=1 to 10 step 1
					mFldHorad = 'MWKResEspec.horaRes' + alltrim(str(i))
					mthora    = &mFldHorad
					if !isnull(mthora)
						mthorar = datetime(year(mdmasX),month(mdmasX),day(mdmasX),;
							hour(mthora),minute(mthora),0)
						mret=SQLExec(mcon1,'select tipoturno from turnos '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar '+;
							'and tipoturno = 0 ','mwkTurctrl')
						tipot(mntipotur) = tipot(mntipotur) + reccount('mwkTurctrl')
						mret=SQLExec(mcon1,'update turnos set tipoturno=?mntipotur '+;
							'where &mccpoamb diasem=?mddiasem and codmed=?mncodmed ' +;
							'and horatur=?mthorar and tipoturno = 0 ','mwkTurres')

						if mret < 0
*wait windows 'NO!' timeout 0.3
							mret = 0
						endif
					endif
				endfor
			else
				do case
					case mncrit = 10
						do prg_proceso_porc_x_franja with mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
					case mncrit = 11
						do prg_proceso_cant_x_franja with mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
					case mncrit = 12
						do prg_proceso_cant_x_hora with mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
				endcase
			endif
		endif

		skip 1 in MWKResEspec
		if eof('MWKResEspec')
			exit
		endif
	enddo
endif
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif
if mxambito = 1
	mccpoamb = ' '
endif
for itt = 1 to 20
	if tipot(itt) > 0
		ctipot = tipot(itt)
		mret=SQLExec(mcon1,'select tipoturno from turnos '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+ ;
			'and tipoturno = ?itt and fechatur = ?mdmasX ','mwkTurresCtrl')
		if reccount('mwkTurresCtrl') < tipot(itt)
			mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb ) "+;
				"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot , ?myip, 22 &mvicpoamb ) ")

		endif
	endif
next itt
