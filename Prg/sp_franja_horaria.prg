******************************
* AUTOR: Claudia Antoniow
******************************
* Fecha : 26/11/2003
******************************
* TRAE LAS FRANJAS SIN AGRUPAR
******************************
Parameters vr_codmed, vr_hoy,vr_todas,lsinMK

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
ENDIF
 If Vartype(lsinMK)="N"
	mccpoamb = mccpoamb + " AND  FranjaHoraria.usuario <>'TURNOSMARKEY'   "
Endif
If Vartype(vr_todas)<>"N"
	vr_todas = 0
Endif
mccpocmed =''
If vr_todas = 0
	mccpocmed = " and centromed = ?mxcentromedico "
Endif
mret=SQLExec(mcon1," select diasem,horadesde,horahasta,fecvigend,fecvigenh, "+;
	" tiposervicio,estructura,imparchivo,tipoturno,id,hhmmdes,hhmmhas "+;
	" ,datediff('mi',horadesde, horahasta)  as minfran,centromed ,usuario  "+;
	" from franjaHoraria " +;
	" where fecvigenH >=?vr_hoy and codmed=?vr_codmed " +;
	" and fecvigenD < fecvigenH "+ mccpoamb+mccpocmed  +;
	" Order by diasem, horadesde, horahasta, fecvigend, fecvigenh","mwkfranjaH")

If mret < 0
	Messagebox('ERROR DE CURSOR FRANJAS HORARIAS',64,'VALIDACION')
	mret=0
Endif

Select Iif(diasem = 2,'Lun',Iif(diasem = 3,'Mar',;
	iif(diasem = 4,'Mie',Iif(diasem = 5,'Jue',;
	iif(diasem = 6,'Vie',Iif(diasem = 7, 'Sab', 'Dom')))))) As semana,Ttoc(horadesde,2) As horad,;
	ttoc(horahasta,2) As horah, fecvigend,fecvigenh, diasem,tiposervicio,;
	estructura,imparchivo,tipoturno,Id,hhmmdes,hhmmhas,minfran,centromed,usuario    ;
	from mwkfranjah Into Cursor mwkfranjahoraria
