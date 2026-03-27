*
* Busqueda de Vales
*
parameters mifiltro,mopcion 

if !used('mwkprestadores')
	mret = sqlexec(mcon1,"select id as idprest,nombre from prestadores", "mwkprestadores" )
	if mret < 0
		messagebox("EN MAESTRO DE PRESTADORES",16,"ERROR")
		return
	endif
endif

if used('mwkInformes')
	use in mwkinformes
endif

if used('mwkInformesa')
	use in mwkinformesa
endif

if used('mwkInformesb')
	use in mwkinformesb
endif

mret = sqlexec(mcon1,"select val_codadmision,val_nroprotocolo,VAL_codvaleasist,"+;
	"val_prestador,val_codservvale,VAL_tipopaciente,val_fechasolicitud,ser_descripserv,"+;
	"TabValObs.TVO_Obser as tpobserva,TabValObs.TVO_SubEstado as tpestado,val_codpun"+;
	" FROM servicios,valesasist "+;
	" left join TabValObs on TabValObs.TVO_codpun=valesasist.val_codpun and TabValObs.TVO_SubEstado=?mopcion"+;
	" where val_codservvale=ser_codserv " + mifiltro,"mwkInformesa")
	
if mret > 0
	select *,sp_busco_npac(val_codadmision,2) as lcampos from mwkinformesa into cursor mwkinformesb
	select *,left(lcampos,40) as PAC_nombrepaciente,val(right(lcampos,;
		len(lcampos)-40)) as PAC_codhci from mwkinformesb into cursor mwkinformes
	use in mwkinformesa
	use in mwkinformesb
else
	messagebox("EN CONSULTA DE VALES",16,"ERROR")
endif

return
