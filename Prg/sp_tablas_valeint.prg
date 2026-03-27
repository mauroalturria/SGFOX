****
** Tablas para valeint
****

Use In Select("mwktmotalta")
mret = SQLExec(mcon1, "select * from motivoegreso where id <100000 order by mte_descripcion", "mwktmotalta")
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = " and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif
Use In Select("mwksectorint")
mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 "+mwcm+;
	" order by sec_descripsec", "mwksectorint")

Use In Select("mwkmotivoint")
mret = SQLExec(mcon1, "select * from motivointernac where mti_fechabaja is null and id <100000 " + ;
	"order by mti_descripcion", "mwkmotivoint")

Use In Select("mwktipoint")
mret = SQLExec(mcon1, "select * from tabtipoint where id <100000 order by descrip", "mwktipoint")

