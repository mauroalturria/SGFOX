*
* Busqueda de especialidad x turno a bloquear 1 / 2
*
Lparameters mturno

If used('MWKespecial')
	Use in MWKespecial
Endif
mwtur =	iif (vartype(mturno)="N"," and Esp_TurnoBloqueo = ?mturno",'')

mret = sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion, Esp_TurnoBloqueo "+;
	" FROM especialid" + ;
	" WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' "+mwtur +;
	" ORDER BY ESP_descripcion","MWKespecial")

If mret	<= 0
	Messagebox("EN BUSQUEDA DE ESPECIALIDADES"+chr(10)+;
	"AVISE A SISTEMAS",16, "ERROR")
Endif
