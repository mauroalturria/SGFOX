********************************
* AUTOR: Claudia C. Antoniow T.
********************************
* FECHA: 25/07/2003
*************************
* Actulizado: 25/07/2003
****************************************************************************
* Busca el datos de franja recientemente ingresado o existente para registrar 
* las tablas de frecuencias,tabprepaga,tabso,tabst,bloqueos,tabreserva
****************************************************************************
parameters vr_codmed, vr_diasem, vr_mthrDes, vr_mthrHas, vr_vigend, vr_cursor,lsinMK

mccpocmed = " and centromed = ?mxcentromedico "
 If Vartype(lsinMK)="N"
	mccpocmed = mccpocmed + " AND  FranjaHoraria.usuario <>'TURNOSMARKEY'   "
Endif
mret=sqlexec(mcon1," SELECT FranjaHoraria.*,abreviatura FROM FranjaHoraria,tabtipoturno WHERE codmed = ?vr_codmed  "+;
				   " AND diasem = ?vr_diasem   AND horadesde = ?vr_mthrDes  "+;
				   " and FranjaHoraria.tipoturno = tabtipoturno.tipoturno  "+;
				   " AND horahasta = ?vr_mthrHas AND fecvigenh >= ?vr_vigend "+mccpocmed , vr_cursor)
				   
if mret<0
	messagebox("ERROR DE CURSOR,AVISAR A SISTEMA",16,"Validación")
	mret=0
	do prg_cancelo
endif				   