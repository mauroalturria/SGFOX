*
* Medicamentos Citostáticos, Insumos & Log de Movimientos
*

Lparameters mcodigo,mdescri,mpartida,munidad,mmedida,mtotals,;
	mrestos,mstoc,mlote,mvenc,mlmarca,mtgtin, mtserie
 
If vartype(mtgtin) <> 'C'
	mtgtin = ''
Endif

If vartype(mtserie) <> 'C'
	mtserie = ''
Endif

mret = sqlexec(mcon1, "insert into TabFarmCitosI" + ;
	" (TCI_insumocodigo,TCI_insumodescrip,TCI_partida,TCI_unidades,TCI_medida,TCI_total,"+;
	"TCI_utilizado,TCI_devolucion,TCI_resto,TCI_remanentes,TCI_tipoinsumo,TCI_lote,TCI_vence,"+;
	"TCI_reutilizados,TCI_marca,TCI_gtin,TCI_serie)"+;
	" values"+;
	" (?mcodigo,?mdescri,?mpartida,?munidad,?mmedida,?mtotals,0,0,"+;
	"?mrestos,?mstoc,'P',?mlote,?mvenc,0,?mlmarca,?mtgtin,?mtserie)" )

If mret < 0
	Messagebox("EN INGRESO DE MEDICAMENTOS CITOSTATICOS INSUMOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
Endif
