*******************************
* AUTOR:Claudia Antoniow
* FECHA:27/06/2003
*******************************
*******************************
* Valida si existe la franja
*******************************
*do sp_conexion
Parameters vr_dia, vr_horad, vr_horah, vr_fvd, vr_fvh

*vr_dia = 4 - vr_horad ='08:00:00' - vr_horah ='10:00:00' - vr_struc ='T' - vr_Tserv = 1
*vr_Tturno = 0 - vr_fvd  = ctod('30/06/2003') - vr_fvh  = ctod('30/06/2003')
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif

mret=SQLExec(mcon1," SELECT * FROM FranjaHoraria " + ;
	" WHERE codmed = ?mncodmed    " + ;
	" AND diasem   = ?vr_dia      " + ;
	" AND hhmmdes = ?vr_horad " + ;
	" AND hhmmhas = ?vr_horah " + ;
	" AND fecvigend <> fecvigenH " + mccpoamb +;
	" AND (?vr_fvd  BETWEEN fecvigend AND fecvigenH " + ;
	" OR ?vr_fvh BETWEEN fecvigend AND fecvigenH )  ", "mwkFranja")

*  AND estructura = ?vr_struc  -" AND tiposervicio = ?vr_Tserv  " + ;
* 				   " AND tipoturno    = ?vr_Tturno " + ;

If mret < 0
	Messagebox("ERROR EN EL CURSOR DE VALIDACION DE FRANJAS, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	Cancel
Endif
