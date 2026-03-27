*
* Acutalizacacion de datos anexos Plan de Tratamiento Citostatico
*
Lparameters mbusidplan,mubica,mpisoc,mtalla,mpeso,msupc,mformula,mesquema

mret = sqlexec(mcon1,"update TabFarmPlan set TFP_ubicacion=?mubica,"+;
	"TFP_pisocama=?mpisoc,TFP_talla=?mtalla,TFP_peso=?mpeso,TFP_supcor=?msupc,"+;
	"TFP_formula=?mformula,TFP_esquema=?mesquema"+;
	" where id=?mbusidplan")

If mret < 0
*=aerror(merror)
*messagebox(merror(3))
	Messagebox("EN ACTUALIZACION DE DATOS PLANILLA DE TRATAMIENTOS"+CHR(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
