********************************************
**Autor: Claudia Antoniow
**Fecha: 21/12/2004
********************************************
parameters vr_fecha_proc

mret=sqlexec(mcon1," SELECT TabReemplazoAmb.* "+;
			 " FROM TabreemplazoAmb ,franjahoraria "+;
			 " WHERE ?vr_fecha_proc between TabreemplazoAmb.fvigend "+;
			 " AND TabReemplazoAmb.fvigenh "+; 
			 " AND idfranja=franjahoraria.id ","MwkLisReemplazos")

if mret < 0
	messagebox('ERROR DEL CURSOR AVISAR A SISTEMAS',16,'VALIDACION')
	mret=0
	cancel
endif				 