*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* MODIFICADA:22/02/2002
*******************************
**************************************************
*generacion de los turnos en blanco para la agenda
**************************************************

*if mddiasem <>1
mncanttur=0
Do sp_busco_feriado.prg

If Eof('MWKFeriados') Or Bof('MWKFeriados')

	Do sp_medicoprestac_diasem_para1 With Mwkmedico.Id
	Sele MWKmedpresta1
	mnucodprest = 0
	If Reccount('MWKmedpresta1') =1
		Select mwkvacexcl
		Go Top
		mvachab = ''
		Scan
			mvachab = mvachab + Alltrim(mwkvacexcl.Descrip) +","
		Endscan
		mvachab = Left(mvachab ,Len(mvachab )-1)
		If (Alltrim(Transform(MWKmedpresta1.codprest)) $ mvachab )
			mnucodprest = MWKmedpresta1.codprest
		Endif
		Sele MWKmedpresta1
	Endif
	Go Top


	Do While !Eof('MWKmedpresta1')

* variables que necesito para el proceso genero turnos

		mthorad_ini   = MWKmedpresta1.horadesde
		mthorah_ini   = MWKmedpresta1.horahasta


		If Inlist(mntipotur,0,3,4,5,7)
			mtdura    = MWKmedpresta1.duracion
		Endif

		If MWKmedpresta1.canturnos >0
			mncanttur = MWKmedpresta1.canturnos
		Else
			mncanttur = 1
		Endif
		mccodesp     = ""  && MWKmedpresta1.codesp
		mncodserv    = 0   && MWKmedpresta1.codserv
		mncodmed     = MWKmedpresta1.codmed
		mndiasem     = mddiasem
		mtfechatur   = mdmasX
		If mtthorad  = Ctot('00:00:00')
			mthorad   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
				hour(mthorad_ini),Minute(mthorad_ini),0)
		Else
			If Ttoc(mtthorad,2) < Ttoc(mthorad_ini,2)
				mthorad   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
					hour(mthorad_ini),Minute(mthorad_ini),0)
			Else
				mthorad   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
					hour(mtthorad),Minute(mtthorad),0)
			Endif
		Endif
		If mtthorah = Ctot('00:00:00')
			mthorah = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
				hour(mthorah_ini),Minute(mthorah_ini),0)
		Else
			If Ttoc(mtthorah,2) > Ttoc(mthorah_ini,2)
				mthorah   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
					hour(mthorah_ini),Minute(mthorah_ini),0)
			Else
				mthorah   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
					hour(mtthorah),Minute(mtthorah),0)
			Endif
		Endif
		Do sp_genero_turnos.prg

		Sele MWKmedpresta1
		mncodmed  = MWKmedpresta1.codmed

		mthorad   = MWKmedpresta1.hhmmdes
		mthorah   = MWKmedpresta1.hhmmhas
****
		Do sp_actualizo_fecha_agen	&& Actualiza 1 registro fechaUltAgenda en medpresta
		mthorad   = MWKmedpresta1.horadesde
		mthorah   = MWKmedpresta1.horahasta

		Skip 1 In MWKmedpresta1
		If Eof('MWKmedpresta1')
			Exit
		Else
			mncanttur = 0
		Endif
	Enddo
	Sele MWKmedpresta1
	Use
Endif
*endif

