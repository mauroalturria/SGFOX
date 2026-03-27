lparameters miestado,origen
do case
	case origen="GUA"
		morigen = " and dguardia = 1 "

	case origen="AMB"
		morigen = " and dambula = 1 "
	otherwise
		morigen = ''
endcase
mret = sqlexec(mcon1," select * from TabPreregMed "+;
	"left join especialid on especialid.esp_codesp = TabPreregMed.codesp "+;
	"where estado = ?miestado &morigen ","mwkPreregMed")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0

endif
