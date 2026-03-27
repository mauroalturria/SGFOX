****
**  Busco sectores internacion
****
Lparameters mtsec,mbusco

Use In Select("mwksectorint")
If Vartype(mbusco)#"C"
	mbusco = ''
Endif
If Type ('mtsec') # "N"				&&& si no le pasa nada toma internacion sino TODOS
	mwhere = " where sec_internacion = 1 "+mbusco
Else
	mwhere 	= " where 1 = 1 "+mbusco
ENDIF
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"

If mwkhabcmsec.estado = 1
	mwhere =mwhere + " and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	mwhere +" order by sec_descripsec", "mwksectorint")

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3),16, "Validacion")
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
Endif
