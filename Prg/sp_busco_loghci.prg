*
* Registro de LOG HCI Archivo de Internados
*

lparameters madm

if used('mwkDetLoga')
	use in mwkdetloga
endif

if used('mwkDetLogb')
	use in mwkdetlogb
endif

if used('mwkDetLog')
	use in mwkdetlog
endif

mret = sqlexec(mcon1,"select TLO_fecestado,"+;
	"hce_descrip,tlo_idusuario,tlo_obser,tlo_estado "+;
	" from tabhcilog left join tabhcestado on tabhcestado.hce_id = tabhcilog.tlo_estado"+;
	" where tlo_admision=?madm","mwkDetLoga")

if mret < 0
	messagebox("EN CONSULTA DE MOVIMIENTOS DE LOG PARA LA ADMISION"+chr(10)+;
		"solicitada - avise a sistemas",16,"ERROR")
else

	mret = sqlexec(mcon1,"select hcmfechasal,HCE_descrip,hcmusuario,hcmdestino,hcmretira,hca_estado "+;
		" from tabhcimovst left join tabhciarchivo on  hci_nroadm = hcmnroadm"+;
		" left join tabhcestado on tabhcestado.hce_id = tabhciarchivo.hca_estado"+;
		" where hcmnroadm=?madm","mwkDetLogb")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3),16,"ERROR")
	else
		select TLO_fecestado,hce_descrip,left(tlo_idusuario,15) as tlo_idusuario,tlo_obser,space(30) as hcmretira,tlo_estado ;
			from mwkdetloga ;
			union ;
			select hcmfechasal as tlo_fecestado ,hce_descrip,;
			hcmusuario as tlo_idusuario,padr(hcmdestino,200) as tlo_obser, hcmretira  ;
			,hca_estado as tlo_estado ;
			from mwkdetlogb ;
			into cursor mwkdetlog

	endif

endif
