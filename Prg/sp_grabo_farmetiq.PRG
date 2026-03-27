*
* Etiquetas de fraccionamiento, ingreso
*

mret = sqlexec(mcon1,"insert into TabFarmEtiq (TFE_fechaemite,TFE_codinsumo,TFE_desenetiq,"+;
	"TFE_desmaestr,TFE_estadocambio,TFE_lote,TFE_vencimiento,TFE_idusuario,TFE_auditado) "+;
	"values (?ldatos(1),?ldatos(2),?ldatos(3),?ldatos(4),?ldatos(5),?ldatos(6),"+;
	"?ldatos(7),?ldatos(8),0)")

If mret < 0
	Messagebox("EN INGRESO DE ETIQUETAS DE FRACCIONAMIENTO"+CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
