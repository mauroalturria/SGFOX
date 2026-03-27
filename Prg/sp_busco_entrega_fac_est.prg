*
* Busqueda de Vales
*
Parameters mifiltro,mopcion
 

mret = sqlexec(mcon1,"select val_codadmision,val_nroprotocolo,VAL_codvaleasist,"+;
	"val_prestador,val_codservvale,VAL_tipopaciente,val_fechasolicitud,ser_descripserv,"+;
	"TabValObs.TVO_Obser as tpobserva,TabValObs.TVO_SubEstado as tpestado,val_codpun "+;
	" FROM servicios,valesasist  "+;
	" inner join TabValObs ON  TabValObs.TVO_codpun = valesasist.val_codpun "+;
 	" where TabValObs.TVO_Fechamov>= {fn curdate()} val_codservvale=ser_codserv"+;
 	" and TabValObs.TVO_SubEstado "+mopcion   + mifiltro+;
 	" order by VAL_codvaleasist,TVO_Fechamov" ,"mwkInfest")

If mret < 0
	Messagebox("EN CONSULTA DE VALES",16,"ERROR")
Endif
