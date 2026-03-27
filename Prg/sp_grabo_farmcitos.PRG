*
* Medicamentos Citostáticos
*
lparameters mcodigo,mdescris,mpartida,munidad,mmedida,mtotals,mtotals,;
mfechemi,musuario,mpacient

mret = sqlexec(mcon1, "insert into TabFarmCitosI " + ;
	"(TCI_insumocodigo,TCI_insumodescrip,TCI_partida,TCI_unidades,TCI_medida,TCI_total,"+;
	"TCI_utilizado,TCI_devolucion,TCI_resto,TCI_remanentes,TCI_tipoinsumo,TCI_insumodescripb) "+;
	"values "+;
	"(?mcodigo,?mdescris,?mpartida,?munidad,?mmedida,?mtotals,?mtotals,0,0,'N','S',?mdescriA)" )

If mret < 0
	Messagebox("EN LA ACTUALIZACION DE STOCK"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Else
	mret = sqlexec(mcon1, "insert into TabFarmCitosE" + ;
		"(TCE_partida,TCE_insumocodigo,TCE_medidauso,TCE_fechaemite,TCE_idusuario,TCE_nombrepac,"+;
		"TCE_insumodescrip,TCE_insumodescripb)"+;
		" values (?mpartida,?mcodigo,?mtotals,?mfechemi,?musuario,?mpacient,?mdescris,?mdescriA)")
	If mret < 0
		Messagebox("EN INGRESO, MAESTRO DE ETIQUETAS CITOSTATICOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Endif
Endif
