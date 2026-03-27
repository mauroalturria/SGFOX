****************************
**Autor: Claudia Antoniow T.
**fecha 12/01/2005
*****************************
parameters vr_fecdes, vr_fechas, vr_otra_busq
mfecnul = CTOD("01/01/1900")

mret =sqlexec(mcon1,'SELECT b.nombre, '+;
	' CASE WHEN b.horadesde >'1900-01-01 00:00:00''+;
	' THEN b.horadesde END as Horadesde,'+;
	' CASE WHEN b.horahasta >'1900-01-01 00:00:00''+;
	' THEN b.horahasta END as Horahasta,'+;
	' b.fvigend,b.fvigenh,'+;
	' prestadores.nombre as reemplaza_a,'+;
	' f.diasem, '+;
	' cast(f.horadesde as time) as horad,'+;
	' cast(f.horahasta as time) as horah'+;
	' FROM tabreemplazoamb as b, prestadores,'+;
	' tabbloqueoamb as r, franjahoraria as f '+;
	' WHERE (fecpasivap = ?mfecnul or fecpasivap > ?vr_fecdes) and b.codmed=prestadores.id and b.codmed= r.codmed '+;
	' and b.idfranja=f.id '+;
	' and  ?vr_fecdes >= b.fvigend and ?vr_fechas <= b.fvigenh '+ vr_otra_busq +;
	' GROUP BY b.codmed, b.fvigend, b.fvigenh '+;
	' Order by prestadores.nombre, b.fvigend, b.fvigenh','MwkMedReemp')

if mret < 0
	messagebox('Error de Cursor, avisar a sistemas ',16,'Validacion')
	mret=0
	cancel
endif
