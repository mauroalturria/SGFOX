*
* Etiquetas de Fraccionamiento, busqueda
*

Lparameters mwhere

If used("mwkinsumos")
	Use in mwkinsumos
Endif

mret = sqlexec(mcon1,"select TFE_fechaemite,TFE_codinsumo,TFE_desenetiq,"+;
	"TFE_desmaestr,TFE_estadocambio,TFE_lote,TFE_vencimiento,TFE_idusuario,TFE_vencimiento "+;
	"from TabFarmEtiq"+mwhere,"mwkinsumos")

If mret < 0
	Messagebox("EN BUSQUEDA DE ETIQUETAS DE FRACCIONAMIENTO"+CHR(10)+"AVISE a SISTEMAS",16,"ERROR")
Endif
