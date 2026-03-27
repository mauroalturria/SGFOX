parameter tnOpcion, mId, mAPG_Afiliado, mAPG_FechaHoraPed,  mAPG_RespTxt, mAPG_RespSvr   

do case
	case tnOpcion= 1		&& Alta

	
	mApgIp = MyIp
	
	mret = sqlexec(mcon1,"insert into TabCtrlApliGem " + ;
	"(APG_Afiliado, APG_FechaHoraPed, Apg_Ip ) " + ;
		"values(?mAPG_Afiliado, ?mAPG_FechaHoraPed, ?mApgIp)")

case tnOpcion= 2 && Upd
	mAPG_FechaHoraResp = sp_busco_fecha_serv('DT')
	 
	mret = sqlexec(mcon1, "update TabCtrlApliGem  set "+ ;
		"APG_RespTxt = ?mAPG_RespTxt , APG_FechaHoraResp = ?mAPG_FechaHoraResp , " + ;
		"APG_RespSvr = ?mAPG_RespSvr  " + ;
		"where id = ?mid")
	
endcase

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE ACTUALIZACION",48,"VALIDACION")
 	Return .f.
Endif  