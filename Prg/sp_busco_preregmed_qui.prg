lparameters miestado
mret = sqlexec(mcon1," select TabPreregMed.*, ESP_codesp, ESP_descripcion, Tabusuario.idusuario from TabPreregMed "+;
	"left join especialid on especialid.esp_codesp = TabPreregMed.codesp "+;
	" left join TabUsuario on Tabusuario.IDCodMed = TabPreregMed.codmed "+;
	"where estado = ?miestado ","mwkPreregMed")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	mret=0

endif
