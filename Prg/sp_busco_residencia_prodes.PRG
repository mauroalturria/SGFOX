*
* Busqueda de residencias acorde a procedencia y desempeño
*

mret = sqlexec(mcon1,"select TBE_apellido,TBE_nombre,TBE_dni,INS_sexo,INS_PromSIAR,"+;
	"INS_universidad,TBU_universidad,TRV_especialidad,INS_cargo,TBE_puntaje,TBE_tema,TBE_correctas"+;
	" from (TabResProfexa"+;
	" join TabResInscrip on TBE_dni=INS_numero and INS_anio=?mranio and INS_evento=?mreven)"+;
	" left join TabResUniv on (TabResUniv.ID=INS_universidad)"+;
	" left join TabResVac on (TRV_idespe=INS_cargo and TRV_anio=?mranio and TRV_evento=?mreven)"+;
	" where TBE_anio=?mranio and TBE_evento=?mreven"+;
	" order by TRV_especialidad,TBE_puntaje desc","mwkanalisis")
