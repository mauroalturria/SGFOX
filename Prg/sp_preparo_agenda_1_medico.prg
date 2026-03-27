*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* MODIFICADO: 16/07/2003
**************************************************
* generacion de los turnos en blanco para la agenda
**************************************************
* do sp_conexion.prg

*if mddiasem <>1
*!*		do sp_busco_feriado
*!*		if eof('MWKFeriados') or bof('MWKFeriados')
*!*
If Used('MWKmedpresta1')
	Sele MWKmedpresta1
	Use
Endif
If myip= '172.16.1.7'
*set step on
Endif
Do sp_medicoprestac_diasem_para1 With Mwkmedico.Id

Sele MWKmedpresta1
Go Top
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
Do While !Eof('MWKmedpresta1')

* variables que necesito para el proceso genero turnos

	mthorad_ini   = MWKmedpresta1.horadesde
	mthorah_ini   = MWKmedpresta1.horahasta
	If mntipotur = 0
		mtdura    = MWKmedpresta1.duracion
	Endif
	If MWKmedpresta1.canturnos >0
		mncanttur = MWKmedpresta1.canturnos
	Else
		mncanttur = 1
	Endif
	mccodesp  = ""  && MWKmedpresta1.codesp
	mncodserv = 0   && MWKmedpresta1.codserv
	mncodmed  = MWKmedpresta1.codmed
	mndiasem  = mddiasem
	mtfechatur= mdmasX
	mthorad   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
		hour(mthorad_ini),Minute(mthorad_ini),0)
	mthorah   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
		hour(mthorah_ini),Minute(mthorah_ini),0)
	mntipotur = 0

	Do sp_genero_turnos
	If !Isnull(MWKmedpresta1.guardia) Or !Isnull(MWKmedpresta1.internado)
		If Minute(MWKmedpresta1.guardia)>0 Or Minute(MWKmedpresta1.internado)>0
* Para generar reservados por medpresta
			Do sp_marco_reservados_1_med With mthorad,mthorah
		Endif
	Endif
* Para generar reservados por tablas
* mccodesp  = MWKmedpresta1.codesp
* do reservados_x_tabla_1_med

	Skip 1 In MWKmedpresta1
	If Eof('MWKmedpresta1')
		Exit
	Endif
Enddo
*	endif
*endif

