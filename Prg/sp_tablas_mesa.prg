mret = sqlexec(mcon1,"Select motivotext, idmotivo "+;
	"from motivos order by motivotext","mwkmotivos1")
if mret < 0
	do log_errores with error(), message(), message(1), program(), lineno()
	messagebox("Los Motivos no estan  disponibles - Informar a Sistemas",0+64,"Conexion")
endif
do sp_secagrup
mret = sqlexec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
	",SEC_secquirur,SEC_internacion from sectores " + ;
	"where sec_internacion = 1 order by sec_descripsec", "mwksectorint")
