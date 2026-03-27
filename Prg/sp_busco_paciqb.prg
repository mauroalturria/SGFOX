****
** Busco datos del protocolo quirurgico IQB
****
parameter mopcion,mfecdes,mfechas,mbusco
mwhere = " PAC_fechaalta>= ?mfecdes and PAC_fechaalta<= ?mfechas "
mwhere = mwhere + iif(vartype(mbusco)#"C", ' ',mbusco)
do case
case mopcion = 1
mret = sqlexec(mcon1, "select TQI_admision, TQI_fechahora, TQI_usuario,TQI_tipoPac,"+;
	"PAC_nombrepaciente, PAC_codhce, PAC_codadmision,"+;
	"PAC_edad, PAC_sexo, PAC_telefresponsab, PAC_fechaadmision,  "+;
	"PAC_fechaalta, PAC_horaalta,  PAC_observalta "+;
	" from TabquiroIQB inner join Pacientes on TQI_admision = Pac_codadmision "+;
	" where "+mwhere,"mwkQuiroIQB")
endcase
if mret < 0
*	messagebox("EN ACTUALIZACION PROTOCOLO QUIRURGICO",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
