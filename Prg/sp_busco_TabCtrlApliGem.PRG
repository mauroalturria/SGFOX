Parameters tnOpcion, tnId, ttFecHora, tcCursor

do case
	case tnOpcion = 1		

	mret = sqlexec(mcon1,"Select * from TabCtrlApliGem " + ;
	"Where  Id = ?tnId",tcCursor)

case tnOpcion = 2 
	mret = sqlexec(mcon1,"Select * from TabCtrlApliGem " + ;
	"Where APG_FechaHoraPed = ?ttFecHora and Apg_Ip = ?MyIp ",tcCursor)

case tnOpcion = 3
	mret = sqlexec(mcon1,"Select Top 1 * from TabCtrlApliGem " + ;
	"Where APG_FechaHoraResp is null ",tcCursor)

endcase

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  