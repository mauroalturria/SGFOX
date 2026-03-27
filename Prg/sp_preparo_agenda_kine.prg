*******************************
* AUTOR:Claudia Antoniow
* FECHA:20/02/2002
*MODIFICADA :22/02/2002
*******************************
**************************************************
*generacion de los turnos en blanco para la agenda
**************************************************
Lparameters lreserv,lplans
If Vartype(lreserv)<>"N"
	lreserv=0
Endif
If Vartype(lplans)<>"N"
	lplans=0
Endif
*if mddiasem <>1
mncanttur=0
Do sp_busco_feriado

If Eof('MWKFeriados') Or Bof('MWKFeriados')
	lcSql = " select  EXE_CodEspecialidad ,tipoturno,codent "+;
		',EXE_VigenciaDesde ,EXE_VigenciaHasta'+;
		" FROM Zabespecexcluentidad,entidexclu "+;
		" where EXE_VigenciaHasta > {fn curdate()}  "+ ;
		" and (Zabespecexcluentidad.codambito = ?mxambito or Zabespecexcluentidad.codambito  = 1) "+;
		" and EXE_TipoExclusion = 1 and codent = EXE_CodEntidad "+;
		" and fecpasiva = '1900-01-01' and tpopac = 'AMB' "
	If !Prg_EjecutoSql(lcSql,"mwkentnoTipoturno")
		Return .F.
	Endif
	lcSql = " select PXE_CodPrestacion ,tipoturno,codent "+;
		',PXE_VigenciaDesde,PXE_VigenciaHasta'+;
		" FROM ZabPrestacExcluEntidad ,entidexclu "+;
		" where PXE_VigenciaHasta > {fn curdate()}   "+ ;
		" and (ZabPrestacExcluEntidad.codambito = ?mxambito or ZabPrestacExcluEntidad.codambito  = 1) "+;
		" and PXE_TipoExclusion = 6 and codent = PXE_CodEntidad "+;
		" and fecpasiva = '1900-01-01' and tpopac = 'AMB' "
	If !Prg_EjecutoSql(lcSql,"mwkentnoTpoturPres")
		Return .F.
	Endif
	Do sp_medicoprestac_diasem_Kine With mccodesp,mddiasem,mdmasX

	Sele MWKmedpresta1
	Go Top

	Do While !Eof('MWKmedpresta1')

* variables que necesito para el proceso genero turnos

		mthorad_ini   = MWKmedpresta1.horadesde
		mthorah_ini   = MWKmedpresta1.horahasta

		If mntipotur  = 0 Or mntipotur =3
			mtdura    = MWKmedpresta1.duracion
		Endif

		If MWKmedpresta1.canturnos > 0
			mncanttur = MWKmedpresta1.canturnos
		Else
			mncanttur = 1
		Endif
		mccodesp  = ""  && MWKmedpresta1.codesp
		mncodserv = 0   && MWKmedpresta1.codserv
		mncodmed  = MWKmedpresta1.codmed
		mndiasem  = mddiasem
		mtfechatur= mdmasX
		mthorad   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorad_ini),Minute(mthorad_ini),0)
		mthorah   =Datetime(Year(mdmasX),Month(mdmasX),Day(mdmasX),Hour(mthorah_ini),Minute(mthorah_ini),0)

		Do sp_genero_turnos.prg
		If MWKmedpresta1.codmed = 1535 And myip = '172.16.1.7'
*			Set Step On
		Endif
		Sele MWKmedpresta1
		mncodmed  = MWKmedpresta1.codmed
***
*** aca meti mano
***
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
	Go Top
	If  lreserv =1
		mccodesp=Alltrim(Mwkespecial.ESP_codesp)
		Do sp_marco_reservados_kine
		mccodesp=Alltrim(Mwkespecial.ESP_codesp)
		Do reservados_x_tabla_kine
	Endif
	If lplans =1
		mccodesp=Alltrim(Mwkespecial.ESP_codesp)
		Do sp_plan_de_salud_espe
	Endif
	If myip = '172.16.1.7'
	*	Set Step On
	Endif
	If mxambito < 20
*** porcentaje d eturnos PE
		If mxambito =1
*** porcentaje d eturnos PE
			Do prg_proceso_porc_x_franjaPE  With  ' and (grupo < 2 AND turnos.tipoturno<>6)    ',0
		Else
			Do prg_proceso_porc_x_franjaPE  With   ' and turnos.tipoturno in ( 0,16)   ',0
		Endif

	Endif
	Use	In Select('MWKmedpresta1')

Endif
*endif

