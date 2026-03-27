*****
***** Busco prestadores reeemplazantes
*****
lparameters mifech
if vartype(mifech)#"D"
	mifec = sp_busco_fecha_serv("DD") - 1
endif
mret = sqlexec(mcon1,'select Tabmedexterno.*,ESP_codesp,ESP_descripcion '+;
	' from Tabmedexterno '+;
	' left join Especialid on Tabmedexterno.codesp = Especialid.ESP_codesp ' + ;
	' where Tabmedexterno.fechaIngreso >= ?mifec  order by nombre,fechaIngreso ', "mwkprestapr" )
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
endif

