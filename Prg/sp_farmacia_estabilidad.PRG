*
* Estabilidad de los principios activos
*
Lparameters mbusca

If used('mwkestable')
	Use  in mwkestable
Endif

mret = sqlexec(mcon1,"select TFE_inscod,TFP_insdes,TFE_solucion,TFE_concentra,"+;
	"TFE_uconcon,TFE_conserva,TFE_envase,TFE_estabilidad,TFE_uestab "+;
	"from TabFarmEstab "+;
	"join TabFarmPActivo on TFP_inscod = TFE_inscod "+;
	"where TFE_inscod=?mbusca","mwkestable")

If mret < 0
	Messagebox("EN CONSULTA DE ESTABILIDAD"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
