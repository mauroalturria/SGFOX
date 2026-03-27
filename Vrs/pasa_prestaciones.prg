public mcon1,mcon3
do sp_conexion_tablas
do sp_conexion

mret = sqlexec(mcon1, "SELECT PRE_codprest,"+;
	"PRE_descriprest,PRE_codservicio,"+;
	"PRE_fechapasiva,PRE_automatica,"+;
	"PRE_tipocpto,PRE_diagterap,"+;
	"PRE_nomenclada,PRE_cargasincontro,"+;
	"PRE_cargayconforme,PRE_profcirugia,"+;
	"PRE_ordencirugia,PRE_usomatdescart,"+;
	"PRE_alimenticio,PRE_modeloproducto,"+;
	"PRE_tipomodelo,PRE_especialidad,"+;
	"PRE_agrupacprestac,PRE_secagrupquirof,"+;
	"PRE_CODCUENTA,PRE_AgendaTurnos,"+;
	"PRE_Internacion,PRE_duracion,"+;
	"PRE_retiroestudios,PRE_turnosmultip "+;
	"FROM PRESTACIONS where pre_codservicio=9400 " ,"PA") 
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
messagebox("Borrar los datos de PRESTACIO de TABLAS antes")
set step on

select pa

scan
	mret = sqlexec(mcon3, "insert into PRESTACION (PRE_codprest,"+;
		" PRE_descriprest,PRE_codservicio,"+;
		" PRE_fechapasiva,PRE_automatica,"+;
		" PRE_tipocpto,PRE_diagterap,"+;
		" PRE_nomenclada,PRE_cargasincontro,"+;
		" PRE_cargayconforme,PRE_profcirugia,"+;
		" PRE_ordencirugia,PRE_usomatdescart,"+;
		" PRE_alimenticio,PRE_modeloproducto,"+;
		" PRE_tipomodelo,PRE_especialidad,"+;
		" PRE_agrupacprestac,PRE_secagrupquirof,"+;
		" PRE_CODCUENTA,PRE_AgendaTurnos,"+;
		" PRE_Internacion,PRE_duracion,"+;
		" PRE_retiroestudios,PRE_turnosmultip )"+;
		" values (?pa.PRE_codprest,"+;
		" ?pa.PRE_descriprest,?pa.PRE_codservicio,"+;
		" ?pa.PRE_fechapasiva,?pa.PRE_automatica,"+;
		" ?pa.PRE_tipocpto,?pa.PRE_diagterap,"+;
		" ?pa.PRE_nomenclada,?pa.PRE_cargasincontro,"+;
		" ?pa.PRE_cargayconforme,?pa.PRE_profcirugia,"+;
		" ?pa.PRE_ordencirugia,?pa.PRE_usomatdescart,"+;
		" ?pa.PRE_alimenticio,?pa.PRE_modeloproducto,"+;
		" ?pa.PRE_tipomodelo,?pa.PRE_especialidad,"+;
		" ?pa.PRE_agrupacprestac,?pa.PRE_secagrupquirof,"+;
		" ?pa.PRE_CODCUENTA,?pa.PRE_AgendaTurnos,"+;
		" ?pa.PRE_Internacion,?pa.PRE_duracion,"+;
		" ?pa.PRE_retiroestudios,?pa.PRE_turnosmultip )")	
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
endscan	