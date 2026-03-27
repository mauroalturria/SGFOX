****
** busco totales por vales para rendimiento
****

*parameter mfecdes, mfechas, msql_tot

mfecdes = '01/10/2003'
mfechas = '30/10/2003'
mret = sqlexec(mcon1, "select ESP_codesp, ESP_descripcion, pia_cantsolicitada, " + ;
	"pia_codprest, VAL_codservvale, VAL_circuitoorigen " + ;
	"from valesasist, presinsuvas, especialid, prestacions " + ;
	"where valesasist = pia_valesasist  and " + ;
	"pia_codprest = pre_codprest    and " + ;
	"pre_especialidad = ESP_codesp  and " + ;
	"VAL_circuitoorigen in('1', '2') and " + ;
	"VAL_fechasolicitud >= to_date('01/10/2003','dd/mm/yyyy') and " + ;
	"VAL_fechasolicitud <= to_date('30/10/2003','dd/mm/yyyy')  " + ;
	"order by ESP_codesp", "mwktotval1" )


