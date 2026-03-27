lParameters mpre_codprest, mpre_retiroestudios

mret = sqlexec(mcon1, "Update prestacions set pre_retiroestudios = ?mpre_retiroestudios where pre_codprest = ?mpre_codprest ")

if mret <= 0 
	messagebox("Error al generar la actualización", 48, "Validación")
	CANC
Endif 