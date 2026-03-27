*
* Busqueda de Vales
*
Parameters mifiltro,mopcion

If !used('mwkprestadores')
	mret = sqlexec(mcon1,"select id as idprest,nombre from prestadores", "mwkprestadores" )
	If mret < 0
		Messagebox("EN MAESTRO DE PRESTADORES",16,"ERROR")
		Return
	Endif
Endif

If used('mwkInformes')
	Use in mwkinformes
Endif

mret = sqlexec(mcon1,"select val_codadmision,val_nroprotocolo,VAL_codvaleasist,"+;
	"val_prestador,val_codservvale,VAL_tipopaciente,val_fechasolicitud,ser_descripserv,"+;
	"TabValObs.TVO_Obser as tpobserva,TabValObs.TVO_SubEstado as tpestado,val_codpun "+;
	" FROM servicios,valesasist  "+;
	" left join TabValObs ON (TabValObs.TVO_codpun = valesasist.val_codpun"+;
	" and TabValObs.TVO_SubEstado=?mopcion) "+;
	" where val_codservvale=ser_codserv  " + mifiltro,"mwkInformes")

If mret < 0
	Messagebox("EN CONSULTA DE VALES",16,"ERROR")
Endif
