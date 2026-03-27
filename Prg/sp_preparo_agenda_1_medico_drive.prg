*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* MODIFICADO: 16/07/2003
* MODIFICADO: 15/06/2020
* MODIFICADO: 27/08/2020
* MODIFICADO: 08/09/2020
**************************************************
* generacion de los turnos en blanco para la agenda
**************************************************
* do sp_conexion.prg
LPARAMETERS lsegenera, hdes,hhas,xmcodesp,xtipo,xtipotur,lsolounmed,lfuerzogenera

If Vartype(xtipo)<>"N"
	xtipo=1
ENDIF
If Vartype(lsegenera)<>"N"
	lsegenera=1
Endif
If Vartype(lsolounmed)<>"C"
	lsolounmed = ''
Endif
If Vartype(xtipotur)<>"N"
	xtipotur = 0
Endif
mntipotur = xtipotur

If Vartype(lfuerzogenera)<>"N"
	lfuerzogenera = 0
ENDIF

*if mddiasem <>1
*!*		do sp_busco_feriado
*!*		if eof('MWKFeriados') or bof('MWKFeriados')
cctrlfecha  = Iif(Empty(lsolounmed) and lfuerzogenera = 0," and  fechaUltAgenda <= mdmasX ","")
Use In Select('MWKmedpresta1')

Do sp_medicoprestac_diasem_para1 With Mwkmedico.Id,xmcodesp
If Reccount('MWKmedpresta1') >0 AND lsegenera =1
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
	Endif
	Sele MWKmedpresta1
	Select *  From MWKmedpresta1 Where !(Ttoc(MWKmedpresta1.horahasta-1,2)< Ttoc(hdes ,2) Or ;
		ttoc(MWKmedpresta1.horadesde,2) > Ttoc(hhas  ,2) ) &cctrlfecha  ;
		into Cursor MWKmedpresta1f

	Sele MWKmedpresta1f
	Go Top
	Do While !Eof('MWKmedpresta1f')

* variables que necesito para el proceso genero turnos

		If hdes > MWKmedpresta1f.horadesde
			mthorad_ini   = hdes
		Else
			mthorad_ini   = MWKmedpresta1f.horadesde
		Endif
		If hhas<MWKmedpresta1f.horahasta
			mthorah_ini   = hhas
		Else
			mthorah_ini   = MWKmedpresta1f.horahasta
		Endif
*	if mntipotur = 0
		mtdura    = MWKmedpresta1f.duracion
*	endif
		If MWKmedpresta1f.canturnos >0
			mncanttur = MWKmedpresta1f.canturnos
		Else
			mncanttur = 1
		Endif
		mccodesp  = ""  && MWKmedpresta1f.codesp
		mncodserv = 0   && MWKmedpresta1f.codserv
		mncodmed  = MWKmedpresta1f.codmed
		mndiasem  = mddiasem
		mtfechatur= mdmasX
		mthorad   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
			hour(mthorad_ini),Minute(mthorad_ini),0)
		mthorah   = Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),;
			hour(mthorah_ini),Minute(mthorah_ini),0)
		mntipotur = xtipotur

		Do sp_genero_turnos
		If !Isnull(MWKmedpresta1f.guardia) Or !Isnull(MWKmedpresta1f.internado)
			If Minute(MWKmedpresta1f.guardia)>0 Or Minute(MWKmedpresta1f.internado)>0
* Para generar reservados por medpresta
				Do sp_marco_reservados_1_med With mthorad,mthorah
			Endif
		Endif
* Para generar reservados por tablas
* mccodesp  = MWKmedpresta1f.codesp
* do reservados_x_tabla_1_med

		Skip 1 In MWKmedpresta1f
		If Eof('MWKmedpresta1f')
			Exit
		Endif
	Enddo
*!*		endif
Endif

