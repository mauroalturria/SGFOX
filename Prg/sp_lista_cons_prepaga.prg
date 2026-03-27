**********************
*sp_lista_cons_prepaga
**********************
**********************
* Claudia Antoniow
**********************
* Fecha:05/11/2002
**********************
* Actualizado:
**********************************************
parameters vr_fechades, vr_fechahas, vr_cond, vr_quelista

if vr_quelista=1
	mret = sqlexec(mcon1," SELECT prepagas.descripcion as prepagas, "+;
						 "	centroatencion.descripcion as centros, "+;
						 "  especialid.ESP_descripcion as especialidad, "+;
						 "  sum(CASE WHEN idservicio =2200 and planillas.tipopaciente='AMB'"+;
						 " THEN cantidad ELSE 0 END) as ConsAMB, "+;
						 " sum(CASE WHEN idservicio <>2200 and planillas.tipopaciente='AMB' "+;
						 " THEN cantidad ELSE 0 END) as PracAMB, "+;
						 " sum(CASE WHEN idservicio = 8000 and planillas.tipopaciente='GUA' "+;
						 " THEN cantidad ELSE 0 END) as ConsGUA, "+;
						 " sum(CASE WHEN idservicio <>8000 and planillas.tipopaciente='GUA' "+;
						 " THEN cantidad ELSE 0 END) as PracGUA "+;
						 " FROM atenciones, prestaciones, prepagas, CentroAtencion, "+;
						 " Planillas, especialid " +;
					     " WHERE atenciones.idprestacion = prestaciones.id " +;
					     " AND atenciones.idprepaga = prepagas.id "+;
					     " AND centroatencion.id =Planillas.idcentroAtencion "+;
	 					 " AND atenciones.idplanilla =Planillas.id  " +;
	 					 " AND prestaciones.idespecialidad =especialid.ESP_codesp " +;
					     " AND fechaatencion between ?vr_fechades and ?vr_fechahas " + vr_cond +;
					     " GROUP BY atenciones.idprepaga, centroatencion.id, ESP_codesp "+;
						 " ORDER BY atenciones.idprepaga, centroatencion.id, "+;
						 " ESP_codesp " ,"MWKConsumo")
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif
	
endif
if vr_quelista=2
	mret = sqlexec(mcon1," SELECT prepagas.descripcion as prepagas, "+;
						 "	centroatencion.descripcion as centros, "+;
						 "  especialid.ESP_descripcion as especialidad, nombre as medico, "+;
						 "  sum(CASE WHEN idservicio =2200 and planillas.tipopaciente = 'AMB'"+;
						 " THEN cantidad ELSE 0 END) as ConsAMB, "+;
						 " sum(CASE WHEN idservicio <>2200 and planillas.tipopaciente = 'AMB' "+;
						 " THEN cantidad ELSE 0 END) as PracAMB, "+;
						 " sum(CASE WHEN idservicio = 8000 and planillas.tipopaciente = 'GUA' "+;
						 " THEN cantidad ELSE 0 END) as Consgua , "+;
						 " sum(CASE WHEN idservicio <>8000 and planillas.tipopaciente = 'GUA' "+;
						 " THEN cantidad ELSE 0 END) as Pracgua "+;
						 " FROM atenciones, prestaciones, prepagas, CentroAtencion, "+;
						 " Planillas, especialid, prestadores " +;
					     " WHERE atenciones.idprestacion = prestaciones.id " +;
					     " AND atenciones.idprepaga = prepagas.id"+;
					     " AND centroatencion.id =Planillas.idcentroAtencion "+;
	 					 " AND atenciones.idplanilla =Planillas.id  " +;
	 					 " AND prestaciones.idespecialidad =especialid.ESP_codesp " +;
	 					 " AND atenciones.idprestador = prestadores.id " +;
					     " AND fechaatencion between ?vr_fechades and ?vr_fechahas " + vr_cond +;
					     " GROUP BY atenciones.idprepaga, centroatencion.id, ESP_codesp, "+;
					     " atenciones.idprestador "+;
						 " ORDER BY atenciones.idprepaga, centroatencion.id,  "+;
						 " ESP_descripcion, nombre " ,"MWKConsumo")
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif

endif					   
if vr_quelista=3
	mret = sqlexec(mcon1," SELECT prepagas.descripcion as prepagas, "+;
						 "	centroatencion.descripcion as centros, "+;
						 "  especialid.ESP_descripcion as especialidad, nombre as medico, "+;
						 "  prestaciones.descripcion, "+;
						 "  sum(CASE WHEN planillas.tipopaciente='AMB' "+;
						 " THEN cantidad ELSE 0 END) as totalAMB, "+;
						 " sum(CASE WHEN  planillas.tipopaciente='GUA' "+;
						 " THEN cantidad ELSE 0 END) as totalGUA "+;
						 " FROM atenciones, prestaciones, prepagas, CentroAtencion, "+;
						 " Planillas, especialid, prestadores " +;
					     " WHERE atenciones.idprestacion = prestaciones.id " +;
					     " AND atenciones.idprepaga = prepagas.id "+;
					     " AND centroatencion.id =Planillas.idcentroAtencion "+;
	 					 " AND atenciones.idplanilla =Planillas.id  " +;
	 					 " AND prestaciones.idespecialidad =especialid.ESP_codesp " +;
	 					 " AND atenciones.idprestador = prestadores.id " +;
					     " AND fechaatencion between ?vr_fechades and ?vr_fechahas " + vr_cond +;
					     " GROUP BY atenciones.idprepaga, centroatencion.id,"+;
					     "  ESP_codesp, atenciones.idprestador, atenciones.idprestacion "+;
						 " ORDER BY atenciones.idprepaga, centroatencion.id,  "+;
						 " ESP_descripcion, nombre,prestaciones.descripcion" ,"MWKConsumo")
					   
	if mret < 0
		messagebox('ERROR EN EL CURSOR DE CONSUMOS, AVISAR A SISTEMAS',64,'Validacion')
		mret = 0
		cancel
	endif

endif