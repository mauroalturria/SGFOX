*
* Busqueda de Insumos, medicamentos x codigo de insumo
*

Lparameters mabuscar, mtipo

If used("mwkinsumos")
	Use in mwkinsumos
Endif

*!* Consultar invertir el orden de busqueda considerando como Maestro principal
*!* TabFarmPActivo, ahora prioriza insumos porque tengo registros que no estan registrados en TabFar....
*!* y por su utilización podría ser necesario

Do case

Case mtipo = 1 && x Codigo
	mret = sqlexec(mcon1, "select INS_codinsumo,TFP_pactivo,INS_descriinsumo,insumos,"+;
		"TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid "+;
		"from TabFarmPActivo " + ;
		"join insumos on INS_codinsumo = TFP_inscod "+;
		"join TabFarmbaseCo on TBC_inscod = INS_codinsumo "+;
		"and INS_fechapasivo is null "+;
		"and INS_grupo in('M', 'U', 'W') "+;
		"where TFP_inscod = ?mabuscar" , "mwkinsumos")

Case mtipo = 2 && x Descripcion
	mret = sqlexec(mcon1, "select INS_codinsumo, TFP_pactivo, INS_descriinsumo, insumos "+;
		"from TabFarmPActivo " + ;
		"join insumos on INS_codinsumo = TFP_inscod "+;
		"and INS_fechapasivo is null "+;
		"and INS_grupo in('M', 'U', 'W') "+;
		"where TFP_insdes LIKE '%&mabuscar%' " , "mwkinsumos")

Case mtipo = 3 && x Principio Activo
	mret = sqlexec(mcon1, "select INS_codinsumo, TFP_pactivo, INS_descriinsumo, insumos "+;
		"from TabFarmPActivo " + ;
		"join insumos on INS_codinsumo = TFP_inscod "+;
		"and INS_fechapasivo is null "+;
		"and INS_grupo in('M', 'U', 'W') "+;
		"where TFP_pactivo LIKE '%&mabuscar%' " , "mwkinsumos")

Endcase

*!* D : CT no
*!* M : MEDICAMENTOS
*!* U : MEDICAMENTOS MONODROGAS 1
*!* W : MEDICAMENTOS MONODROGAS 2
*!* A : ACCESORIOS ASISTENCIALES ??? no


*!*		mret = sqlexec(mcon1, "select INS_codinsumo, TFP_pactivo, INS_descriinsumo, insumos "+;
*!*			"from insumos " + ;
*!*			"join TabFarmPActivo on TFP_inscod=INS_codinsumo "+;
*!*			"where INS_fechapasivo is null and "+;
*!*			"INS_grupo in('M', 'U', 'W') and "+;
*!*			"ins_descriinsumo LIKE '%&mabuscar%' " , "mwkinsumos")

If mret < 0
	=aerr(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
Endif
