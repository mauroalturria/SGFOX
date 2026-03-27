****
** sQL DE BUSQUEDA DE TURNOS
****
Parameters tbNoshowmsg

If Used('mwkmedp')
	Select mwkmedp
	Use
Endif

If Used('mwktur')
	Select mwktur
	Use
Endif
mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif

mbusqueda = ''
If msql_espe <> ''
	mbusqueda = "medpresta.codesp = ?msql_espe "
Endif

If msql_presta > 0
	If mbusqueda = ''
		mbusqueda = " medpresta.codprest = ?msql_presta " 
	Else
		mbusqueda = mbusqueda + " and medpresta.codprest = ?msql_presta "
	Endif
Endif

If msql_codmed > 0
	If mbusqueda = ''
		mbusqueda = "medpresta.codmed = ?msql_codmed "
	Else
		mbusqueda = mbusqueda + " and medpresta.codmed = ?msql_codmed "
	Endif
Endif

*=esc_log("FQ MEDPRESTA - " + mwktabambito.Ambito)

mret = SQLExec(mcon1, "select codmed, diasem, horadesde, horahasta, codprest, sala, " + ;
	"fecvigend, fecvigenh, hdesde1, hhasta1,hhmmdes,hhmmhas,duracion as durtur,reservados " + ;
	"from medpresta " + ;
	"where &mbusqueda " + mccpoamb+;
	"and diasem > 0 and generaagen = 1 and " + ;
	"fecvigenh > ?msql_fecha and fecvigenh <>fecvigend " , "mwkmedp")

If mret < 0
	Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
	Cancel
Endif

Select codmed From mwkmedp Group By codmed Into Cursor mwkseparo

mlis_id = " turnos.codmed in(0"
If Reccount('mwkseparo')= 0
	mlis_id =  " "
	If Not tbNoshowmsg
		Messagebox("NO HAY MEDICO ASOCIADO A ESTA PRESTACION", 64,"Validacion")
	Endif 	
Else
*	if reccount('mwkseparo')< 20
	Do While !Eof('mwkseparo')
		mlis_id = mlis_id + "," + Allt(Str(mwkseparo.codmed, 5))
		Skip 1 In mwkseparo
	Enddo
	mlis_id = mlis_id + ") and "
*!*		else
*!*			mlis_id = " turnos.codmed in( select codmed from medpresta " + ;
*!*				"where &mbusqueda " + ;
*!*				"and diasem > 0 and generaagen = 1 and " + ;
*!*				"fecvigenh > ?msql_fecha and fecvigenh <>fecvigend) and "
*!*		endif
Endif
mitiempo = Seconds()
ltfecnull = Ctot("01/01/1900") 


msql_turnosgi = ''
*!*	msql_turnosgi = "and turnos.Id not in (Select GI_IdTurno from TabTurnosGI where GI_FecPasiva = ?ltfecnull and GI_FecAlta >= ?msql_fecha )"

misql = "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codmed, " + ;
	"turnos.codserv, turnos.codesp, turnos.diasem, turnos.tipoturno, hhmmtur,  " + ;
	"prestadores.nombre,turnos.fechagenera,tabtipoturno.liberable,tabtipoturno.abreviatura,tabtipoturno.grupo " + ;
	"from turnos, prestadores,tabtipoturno " + ;
	"where  turnos.tipoturno = tabtipoturno.tipoturno and " + ;
	"Exists(select 1 from turnos " + ;
		"where turnos.afiliado = 0 and " + ;
		"" + mlis_id + " tipoturno &msql_nivel and " + msql_dias + " fechatur >= ?msql_fecha " + mccpoamb + " &msql_horas ) and " + ; 
	"turnos.codmed = prestadores.id and " + ;
	"turnos.afiliado = 0  and " +  mlis_id + ;
	"turnos.tipoturno &msql_nivel and " + ;
	msql_dias  + ;
	"turnos.fechatur >= ?msql_fecha " + mccpoamb+;
	"&msql_horas " + "&msql_turnosgi  " 


*=esc_log("FQ TURNOS - " + mwktabambito.Ambito)

mret = SQLExec(mcon1,misql , "mwktur")
Select * from mwktur order by horatur,id desc into cursor mwktur  &&&agreado por Carmen 27/12/19
Select turnos.Id, turnos.fechatur, turnos.horatur, turnos.codmed, ;
	turnos.codserv, turnos.codesp, turnos.diasem, turnos.tipoturno, ;
	medpresta.codprest, medpresta.horadesde, medpresta.horahasta,  ;
	medpresta.sala, fecvigend, fecvigenh, nombre,hhmmdes,hhmmhas,hhmmtur,;
	medpresta.reservados,turnos.fechagenera,turnos.liberable,turnos.abreviatura,turnos.grupo   ;
	from mwktur As turnos, mwkmedp As medpresta ;
	where medpresta.codmed = turnos.codmed And  ;
	medpresta.diasem = turnos.diasem And  ;
	fechatur >= fecvigend And fechatur < fecvigenh  ;
	group By fechatur, horatur, turnos.codmed, turnos.tipoturno, medpresta.hdesde1 ;
	order By fechatur, horatur, turnos.codmed, turnos.tipoturno Into Cursor mwkturnos



