*!*
*!*	busco ValesAsist para un paciente
*!*	---------------------------------------------------------------------------------------
parameter mOpcion, mCodadmision,minsumo,mfecha,mpend,mfechaH
mconf = ''
if mpend
	mconf = " and VAL_estado<3 "
endif
if vartype(mfecha)#"D"
	mfecha = sp_busco_fecha_serv("DD")
endif
use in select("mwktodopres")
if vartype(mfechaH)#"D"
	mfechaH = sp_busco_fecha_serv("DD")
endif
use in select("mwktodoins")
do case
	case mOpcion = 1 && vales con un insumo
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
			"PIA_codinsumo, pia_cantsolicitada,VAL_estado,val_observaciones " + ;
			"from presinsuvas, valesasist " + ;
			"where valesasist = pia_valesasist and " + ;
			"VAL_fechasolicitud >=?mfecha and PIA_codinsumo =?minsumo and " + ;
			"VAL_codservvale = 5410 and VAL_codadmision= ?mCodadmision  " +;
			mconf , "mwktodoins")
	case mOpcion = 2 && vales con una prestacion
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
			"PIA_codinsumo, pia_cantsolicitada,VAL_estado,VAL_NroProtocolo,val_observaciones " + ;
			"from presinsuvas, valesasist " + ;
			"where valesasist = pia_valesasist and " + ;
			"VAL_fechasolicitud >=?mfecha and Presinsuvas.PIA_codprest =?minsumo and " + ;
			"VAL_codadmision= ?mCodadmision  " +;
			mconf +" order by VAL_codvaleasist ", "mwktodopres")
	case mOpcion = 3 && vales con un insumo desde fecha
		mret = sqlexec(mcon1, "select valesasist.*,pia_cantsolicitada,CAST(valesasist.VAL_medicosolicit as CHAR(30)) as nombreC,"+;
			"prestadores.nombre,prestadores.matriculas,PAC_nombrepaciente, PAC_codhce,  IPR_receta ,IPR_tipoEgreso ,IPR_insumo,PIA_codinsumo,IPR_detalle   " + ;
			"from valesasist inner join presinsuvas on valesasist = pia_valesasist " + ;
			" inner join pacientes on PAC_codadmision = VAL_codadmision "+;
			" left join prestadores on valesasist.VAL_medicosolicit = prestadores.id "+;
			" inner join Zabinspsicoreceta on valesasist.VAL_codpun = IPR_valcodpun  "+;
			"where VAL_fechasolicitud >=?mfecha and VAL_fechasolicitud <=?mfechah and PIA_codinsumo =?minsumo and " + ;
			"VAL_codservvale = 5410 and VAL_estado= 3 order by IPR_receta  ", "mwktodoins")
	case mOpcion = 4 && vales sin conformar
		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
			"PIA_codinsumo, pia_cantsolicitada,VAL_estado,VAL_codsector,val_observaciones,VAL_NroProtocolo " + ;
			"from presinsuvas, valesasist " + ;
			"where valesasist = pia_valesasist and " + ;
			"VAL_fechasolicitud >=?mfecha and " + ;
			"VAL_codservvale = 5410 and VAL_codadmision= ?mCodadmision  " +;
			mconf , "mwktodoins")
endcase
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
