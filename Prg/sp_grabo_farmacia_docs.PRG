*
* Grabo documentos emitidos por Farmacia (Etiqueta, Hoja de Trabajo, Obs. Enfermeria formato PDF
*
Lparameters mlnropof,mltipo,mtarch,mlpartida

if vartype(mlpartida)<>"C"
	mlpartida = ""
endif

mlfec = sp_busco_fecha_serv("DT")

mret  = sqlexec(mcon1,"insert into TabFarmDocs"+;
	" (TFD_nropof,TFD_salida,TFD_documento,TFD_tipo,TFD_fecha,TFD_partida)"+;
	" values"+;
	" (?mlnropof,?mltipo,?__DATA.archivo,?mtarch,?mlfec,?mlpartida)")

If mret <= 0
	Messagebox("EN GRABACION DE ARCHIVO",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
