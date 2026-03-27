***
** busco control facturacion
***

parameter mfecd,mfech
mdesdef = prg_dtoc(mfecd)
mhastaf	= prg_dtoc(mfech+1)

mret = sqlexec(mcon1, "select fecha,prg,usuario, " + ;
	" PAC_nombrepaciente,PAC_codadmision, PAC_habitacion, PAC_cama, " + ;
	"  ENT_descrient, pac_codhci " + ;
	" from Tabverc "+;
	" left join pacientes 	on codadmision		= PAC_codadmision" + ;
	" left join coberturas 	on PAC_codadmision 	= COB_pacientes " +;
	" left join entidades 	on COB_codentidad 	= ENT_codent " +;
	" where fecha>=?mdesdef and fecha<=?mhastaf and control = 0 "+;
	" and habcama like 'LLAMADAS%' " +;
	" group by PAC_codadmision " , "mwkTabCtrlCall")
if mret < 0
	messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")
endif
