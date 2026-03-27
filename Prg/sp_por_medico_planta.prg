*******************************************
** Fecha: 10/01/2005
** Autor: Claudia Antoniow T.
*******************************************
parameters vr_fecdes, vr_fechas, vr_otra_busq
mfecnul = ctod("01/01/1900")

mret=sqlexec(mcon1,'SELECT prestadores.nombre, '+;
	' CASE WHEN b.horadesde >'1900-01-01 00:00:00''+;
	' THEN b.horadesde END as Horadesde,'+;
	' CASE WHEN b.horahasta >'1900-01-01 00:00:00' '+;
	' THEN b.horahasta END as Horahasta,'+;
	' b.fvigend,b.fvigenh,'+;
	' CASE  WHEN reemplazo=2 THEN r.nombre ELSE 'NO' END as reemplazo,'+;
	' f.diasem, '+;
	' cast(f.horadesde as time) as horad, cast(f.horahasta as time) as horah '+;
	' FROM tabbloqueoamb as b, prestadores, '+;
	' tabreemplazoamb as r, franjahoraria as f '+;
	' WHERE (fecpasivap = ?mfecnul or fecpasivap > ?vr_fecdes) and b.codmed=prestadores.id and b.codmed=* r.codmed '+;
	' and b.idfranja=f.id '+;
	' and  ?vr_fecdes >= b.fvigend and ?vr_fechas <= b.fvigenh '+ vr_otra_busq +;
	' GROUP BY b.codmed, b.fvigend, b.fvigenh '+;
	' Order by prestadores.nombre, b.fvigend, b.fvigenh ','MwkMediPlan')
if mret < 0
	messagebox('Error de Cursor, avisar a sistemas ',16,'Validacion')
	cancel
	mret = 0
else
	if used('MwkMediPlan')
		select nombre, Horadesde, Horahasta, fvigend, fvigenh, reemplazo,;
			iif(diasem=2,'LUN',iif(diasem=3,'MAR',iif(diasem=4,'MIE',;
			iif(diasem=5,'JUE',iif(diasem=6,'VIE','SAB'))))) as diasem,;
			horad, horah from MwkMediPlan into cursor MwkMedicoPta
	endif
endif


