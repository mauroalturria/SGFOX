*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*Modificado:21/02/2002
*******************************
*********************************************************************************
* Ejecuta el cursor de especialidades, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************


mret = sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
				   " WHERE ESP_descripcion is not Null " +;
				   " ORDER BY ESP_descripcion","MWKespecial")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR Especialidad, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
endif	