*****************************
* Autor: Claudia C. Antoniow
*****************************
* Fecha Creación :22/09/2003
*****************************
* para :frmprep03
parameter vr_afi, vr_grup, vr_fecha_d, vr_fecha_h

if !empty(vr_afi)
	mret=sqlexec(mcon1," SELECT a.FechaAtencion, a.HoraAtencion, "+;
				   " CentroAtencion.descripcion as centros, Prestadores.nombre, "+;
				   " Prestaciones.descripcion as prestaciones, "+;
				   " a.MotivoAnulacion, planillas.tipopaciente "+;
				   " FROM Atenciones as a, CentroAtencion, Planillas, Prestadores, "+;
				   " prestaciones "+;
				   " WHERE a.idafiliado = ?vr_afi "+;
				   " AND FechaAtencion between ?vr_fecha_d and ?vr_fecha_h "+;
				   " AND a.idplanilla = planillas.id AND a.idprestador = prestadores.id"+;
				   " AND a.idprestacion = prestaciones.id "+;
				   " AND Planillas.idCentroAtencion = CentroAtencion.id "+;
				   " ORDER BY fechaAtencion, horaAtencion ","MwkConsafi")
	if mret <0
		messagebox('Error de Cursor, avisar a sistemas',64,'Validacion')
		cancel
		mret=0
	endif				   
endif
if !empty(vr_grup)
	mret=sqlexec(mcon1," SELECT a.NombreAfiliado, a.FechaAtencion, a.HoraAtencion, "+;
						" CentroAtencion.descripcion as centros, Prestadores.nombre, "+;
						" Prestaciones.descripcion as prestaciones, "+;
  						" a.MotivoAnulacion, planillas.tipopaciente, "+;
  						" a.idafiliado "+;
						" FROM Atenciones as a, CentroAtencion, Planillas, Prestadores, "+;
 						" prestaciones "+;
 						" WHERE a.idgrupo = ?vr_grup "+;
 						" AND FechaAtencion between ?vr_fecha_d and ?vr_fecha_h "+;
 						" AND a.idplanilla = planillas.id AND a.idprestador = prestadores.id "+;
 						" AND a.idprestacion = prestaciones.id "+;
 						" AND Planillas.idCentroAtencion = CentroAtencion.id "+;
 						" ORDER BY idafiliado, fechaAtencion, horaAtencion ","MwkConsafi")
	if mret < 0
		messagebox('ERROR DE CURSOR, AVISAR A SISTEMAS ',64,'Validacion')
		cancel
		mret=0
	endif				   
endif					   