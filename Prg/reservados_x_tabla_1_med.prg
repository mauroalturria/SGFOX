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
Parameter vr_tipotur, vr_thorad, vr_thorah
Dimension tipot(100)
Store 0 To tipot
IF myip ='172.16.1.7'
*SET STEP ON
endif
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ' tabreservado.id>5000 and '
Endif
mret=SQLExec(mcon1,'SELECT tabreservado.* FROM tabreservado,tabtipoturno WHERE   '+;
	' tabreservado.tipoturno= tabtipoturno.tipoturno and &mccpoamb centromedico = ?mxcentromedico and diasem  = ?mddiasem ' +;
	'and codmed = ?mncodmed ' +  vr_tipotur +;
	'and ?mdmasX between fecvigend and fecvigenh and fecvigenh <> fecvigend ' ,'MWKResMedicoprev')
If mret < 0
	mret = 0
Else
	Select Id, Diasem ,Nvl(HORArDESDE,HORADESDE) As HORADESDE,  Nvl(HORArHASTA,HORAHASTA) As HORAHASTA, HORArDESDE,  HORArHASTA, HoraRes1, HoraRes10,;
		HoraRes2, HoraRes3, HoraRes4,  HoraRes5, HoraRes6, HoraRes7,  HoraRes8, HoraRes9, TipoTurno,;
		cantidad, codambito, codesp,  codmed, criterio, fechagraba,  fecvigend, fecvigenh, guardia,;
		usuario, internado From MWKResMedicoprev Into Cursor MWKResMedico

	Do While !Eof('MWKResMedico') And MWKResMedico.codmed=mncodmed
		mntipotur = MWKResMedico.TipoTurno
		mhRdesde  = MWKResMedico.HORArDESDE
		mhRhasta  = MWKResMedico.HORArHASTA
		Do Case
			Case Ctot(Ttoc(vr_thorad,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorad,2)) >Ctot(Ttoc(MWKResMedico.HORArDESDE,2))
				mhRdesde  = MWKResMedico.HORArDESDE
			Case Ctot(Ttoc(vr_thorah,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorah ,2)) <Ctot(Ttoc(MWKResMedico.HORArHASTA,2))
				mhRhasta  = MWKResMedico.HORArHASTA
			Otherwise
				mhRdesde   = vr_thorad
				mhRhasta   = vr_thorah
		Endcase

		If  (Ttoc(MWKResMedico.HORAHASTA-1,2)< Ttoc(mhRdesde ,2) Or Ttoc(MWKResMedico.HORADESDE,2) >Ttoc(mhRhasta  ,2))
			Skip 1 In MWKResMedico
			If Eof('MWKResMedico')
				Exit
			Else
				Loop
			Endif
		Endif


		mncodmed  = MWKResMedico.codmed

		If !Isnull(MWKResMedico.HORArDESDE)
* armo la hora que necesito buscar
			If Ttoc(mhRdesde,2)   > Ttoc(MWKResMedico.HORADESDE,2)
				mthorad_ini   = mhRdesde
			Else
				mthorad_ini   = MWKResMedico.HORADESDE
			Endif
			If Ttoc(mhRhasta,2)   <Ttoc(MWKResMedico.HORAHASTA,2)
				mthorah_ini   = mhRhasta
			Else
				mthorah_ini   = MWKResMedico.HORAHASTA
			Endif
			mthorad = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorad_ini),Minute(mthorad_ini ),0)
			mthorah = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorah_ini),Minute(mthorah_ini),0)
			If mxambito =1
				mccpoamb =''
			Endif
			mret=SQLExec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno in (0,4)','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + Reccount('mwkTurctrl')

			mret=SQLExec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
				'where &mccpoamb diasem = ?mddiasem and codmed =?mncodmed '+;
				'and horatur >=?mthorad  and horatur < ?mthorah ' +;
				'and tipoturno in (0,4) ','mwkTurres')
			If mret < 0
				mret = 0
			Endif
		Else
			mncrit     = MWKResMedico.criterio
			mncant_res = MWKResMedico.cantidad
			mhRdesde  = MWKResMedico.HORArDESDE
			mhRhasta  = MWKResMedico.HORArHASTA
			Do Case
				Case Ctot(Ttoc(vr_thorad,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorad,2)) >Ctot(Ttoc(MWKResMedico.HORArDESDE,2))
					mhRdesde  = MWKResMedico.HORArDESDE
				Case Ctot(Ttoc(vr_thorah,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorah,2)) <Ctot(Ttoc(MWKResMedico.HORArHASTA,2))
					mhRhasta  = MWKResMedico.HORArHASTA
				Otherwise
					mhRdesde   = vr_thorad
					mhRhasta   = vr_thorah

			Endcase

*mthorad    = MWKResMedico.horadesde
*mthorah    = MWKResMedico.horahasta
			If Nvl(mncant_res,0)=0
				For i=1 To 10 Step 1
					mFldHorad = 'MWKResMedico.horaRes' + Alltrim(Str(i))
					mthora    = &mFldHorad
					If mxambito =1
						mccpoamb =''
					Endif
					If !Isnull(mthora)
						mthorar = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthora),Minute(mthora),0)
						mret=SQLExec(mcon1,'select tipoturno from turnos '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar '+;
							'and tipoturno in (0,4)','mwkTurctrl')
						tipot(mntipotur) = tipot(mntipotur) + Reccount('mwkTurctrl')

						mret = SQLExec(mcon1,'update turnos set tipoturno = ?mntipotur '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar and tipoturno in (0,4)','mwkTurres')
						If mret < 0
							Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()

							If myip ='172.16.1.7'
								Set Step On
							Endif
							Messagebox('ERROR:No se generaron turnos Especiales',16,'Validacion')
							mret = 0
						Endif
					Endif
				Endfor
			Else
				Do Case
					Case mncrit = 10
						Do prg_proceso_porc_x_franja With mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
					Case mncrit = 11
						Do prg_proceso_cant_x_franja With mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
					Case mncrit = 12

						Do prg_proceso_cant_x_hora With mncant_res,mncodmed,mdmasX,mntipotur,;
							mddiasem,mthorad, mthorah
				Endcase
			Endif
		Endif
		If Eof('MWKResMedico')
			Exit
		Else
			Skip 1 In MWKResMedico
		Endif
	Enddo
Endif

**Nuevo controlar
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ' id>5000 and '
Endif
mret=SQLExec(mcon1,'SELECT * FROM tabreservado,tabtipoturno WHERE   tipoturno= tabtipoturno.tipoturno and  '+;
	' &mccpoamb diasem=?mddiasem AND codmed is null '+;
	' And ?mdmasX between fecvigend and fecvigenh and fecvigenh <> fecvigend ' +  vr_tipotur +;
	' AND codesp in (select codesp from medpresta' +;
	' where &mccpoamb codmed =?mncodmed  And ?mdmasX between fecvigend and fecvigenh group by codesp)','MWKResEspec')
If mret < 0
	mret=0
Else

	Do While !Eof('MWKResEspec')

		mntipotur = MWKResEspec.TipoTurno
		mhRdesde  = MWKResEspec.HORArDESDE
		mhRhasta  = MWKResEspec.HORArHASTA
		Do Case
			Case Ctot(Ttoc(vr_thorad,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorad,2)) >Ctot(Ttoc(MWKResEspec.HORArDESDE,2))
				mhRdesde  = MWKResEspec.HORArDESDE
			Case Ctot(Ttoc(vr_thorah,2)) = Ctot('00:00:00') Or  Ctot(Ttoc(vr_thorah,2)) <Ctot(Ttoc(MWKResEspec.HORArHASTA,2))
				mhRhasta  = MWKResEspec.HORArHASTA
			Otherwise
				mhRdesde   = vr_thorad
				mhRhasta   = vr_thorah


		Endcase
		If  (Ttoc(MWKResMedico.HORAHASTA-1,2)< Ttoc(mhRdesde ,2) Or Ttoc(MWKResMedico.HORADESDE,2)>Ttoc(mhRhasta  ,2))
			Skip 1 In MWKResEspec
			If Eof('MWKResEspec')
				Exit
			Else
				Loop
			Endif

		Endif



		mccodesp  = MWKResEspec.codesp


*mcdedonde ='dambula'
*do sp_medicos_espec_reservas

*do while !eof('mwkMedico')

		mncodmed=mwkMedico.Id

		If !Isnull(mhRdesde)
			mthorad = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
				hour(mhRdesde),Minute(mhRdesde),0)
			mthorah = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
				hour(mhRhasta),Minute(mhRhasta),0)
			If mxambito = 1
				mccpoamb = ' '
			Endif

			mret=SQLExec(mcon1,'select tipoturno from turnos '+;
				'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
				'and horatur >= ?mthorad  and horatur < ?mthorah '+;
				'and tipoturno = 0 ','mwkTurctrl')
			tipot(mntipotur) = tipot(mntipotur) + Reccount('mwkTurctrl')
			mret=SQLExec(mcon1,'update turnos set tipoturno=?mntipotur '+;
				'where &mccpoamb diasem=?mddiasem and codmed=?mncodmed '+;
				'and horatur >=?mthorad  and horatur <?mthorah and tipoturno = 0 ','mwkTurres')
			If mret < 0
*wait windows 'NO!' timeout 0.3
				mret = 0
			Endif
		Else
			If mxambito = 1
				mccpoamb = ' '
			Endif
			mncrit     = MWKResEspec.criterio
			mncant_res = MWKResEspec.cantidad
			mthorad    = MWKResEspec.HORADESDE
			mthorah    = MWKResEspec.HORAHASTA
			If Nvl(mncant_res,0)=0
				For i=1 To 10 Step 1
					mFldHorad = 'MWKResEspec.horaRes' + Alltrim(Str(i))
					mthora    = &mFldHorad
					If !Isnull(mthora)
						mthorar = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
							hour(mthora),Minute(mthora),0)
						mret=SQLExec(mcon1,'select tipoturno from turnos '+;
							'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+;
							'and horatur  = ?mthorar '+;
							'and tipoturno = 0 ','mwkTurctrl')
						tipot(mntipotur) = tipot(mntipotur) + Reccount('mwkTurctrl')
						mret=SQLExec(mcon1,'update turnos set tipoturno=?mntipotur '+;
							'where &mccpoamb diasem=?mddiasem and codmed=?mncodmed ' +;
							'and horatur=?mthorar and tipoturno = 0 ','mwkTurres')

						If mret < 0
*wait windows 'NO!' timeout 0.3
							mret = 0
						Endif
					Endif
				Endfor
			Else
				Do Case
					Case mncrit = 10
						Do prg_proceso_porc_x_franja With mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
					Case mncrit = 11
						Do prg_proceso_cant_x_franja With mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
					Case mncrit = 12
						Do prg_proceso_cant_x_hora With mncant_res,mncodmed,mdmasX,;
							mntipotur,mddiasem,mthorad,mthorah
				Endcase
			Endif
		Endif

		Skip 1 In MWKResEspec
		If Eof('MWKResEspec')
			Exit
		Endif
	Enddo
Endif
mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif
If mxambito = 1
	mccpoamb = ' '
Endif
For itt = 1 To 100
	If tipot(itt) > 0
		ctipot = tipot(itt)
		mret=SQLExec(mcon1,'select tipoturno from turnos '+;
			'where &mccpoamb diasem = ?mddiasem and codmed = ?mncodmed '+ ;
			'and tipoturno = ?itt and fechatur = ?mdmasX ','mwkTurresCtrl')
		If Reccount('mwkTurresCtrl') < tipot(itt)
			mret = SQLExec(mcon1, "insert into turnosaudit (afiliado, turnoid, fechatomado, usuario, observa, codigo &mcicpoamb ) "+;
				"values (  ?mncodmed, ?itt, ?mdmasX, ?ctipot , ?myip, 22 &mvicpoamb ) ")

		Endif
	Endif
Next itt
