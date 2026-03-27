****
** busco consumo por SERVICIO
****
Parameters xcodser, msql_cons,mfecdes 

mret = SQLExec(mcon1, "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_horasolicitud,pre_descriprest, " + ;
	"VAL_codvaleasist,PAC_nombrepaciente, PAC_sectorinternac,PAC_cama,PAC_habitacion, val_prestador,val_codservvale " + ;
	",VAL_observaciones,"+;
	"val_codpun,VAL_OperadorCarga,val_nrointfactura,VAL_estado,PAC_codhci,PAC_codhce,pia_codprest,ser_descripserv  "+;
	"from pacientes, valesasist " + ;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" inner join PRESTACIONS 	on prestacions.pre_codprest		= presinsuvas.pia_codprest" + ;
	" inner join servicios on VAL_codservvale = ser_codserv " + ;
	" where PAC_codadmision = VAL_codadmision and " + ;
	" VAL_codservvale = ?xcodser and VAL_fechasolicitud=?mfecdes  " , "mwkconsumos1")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif


msql_cons = "select VAL_codadmision, VAL_tipopaciente, VAL_fechasolicitud, VAL_codvaleasist, " + ;
	"PAC_nombrepaciente,pre_descriprest, ser_descripserv as servicio ,PAC_codhce,pia_codprest " + ;
	"from mwkconsumos1 group by VAL_fechasolicitud, VAL_codvaleasist,pia_codprest order by VAL_codvaleasist desc into cursor mwkconsu"
