******************************
* Autor: Claudia C. Antoniow
******************************
* Fecha : 22/05/03
******************************
* Fecha Ult. Modificacion : 22/05/03
**************************************
parameters vr_med, vr_fecha, vr_diasem, vr_horad, vr_horah,vr_turnitos
IF TTOC(vr_horah,2)="00:00:00"
	vr_horah = vr_horah+(24*3600)-1
endif
vr_dhorad=datetime(year(vr_fecha),month(vr_fecha),day(vr_fecha),hour(vr_horad),minute(vr_horad),0)
vr_dhorah=datetime(year(vr_fecha),month(vr_fecha),day(vr_fecha),hour(vr_horah),minute(vr_horah),0)

mtipott = IIF(VARTYPE(vr_turnitos)<>"C",' and turnos.tipoturno in (0,4,5,7) ',vr_turnitos)
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mret = sqlexec(mcon1,'Select turnos.id,horatur,turnos.tipoturno  from turnos,tabtipoturno '+;
	'Where tabtipoturno.tipoturno = turnos.tipoturno and &mccpoamb  codmed = ?vr_med and fechatur = ?vr_fecha '+;
	'And horatur Between ?vr_dhorad and ?vr_dhorah '+mtipott+' order by horatur,turnos.id ' ,'MwkturnosxFranja')
if mret < 0
	messagebox('Error en calculo de turnos ',16,'VALIDACION')
	mret = 0
endif
Select count(id) as totalturnos from MwkturnosxFranja  INTO CURSOR MwkCantxFranja