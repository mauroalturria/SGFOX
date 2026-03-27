*
* Busqueda de Insumos Remanentes,
*
Lparameters mabuscar, mtipo

If used("mwkinsumos")
	Use in mwkinsumos
Endif

Do case
Case mtipo = 1
	mwhere = "TCI_remanentes = 'S' and TCI_resto > 0 and TCI_insumocodigo = ?mabuscar"
Case mtipo = 2
	mwhere = "TCI_remanentes = 'S' and TCI_resto > 0 and TCI_insumodescrip LIKE '%&mabuscar%'"
Case mtipo = 3
	mwhere = "TabfarmCitosI.ID = ?mabuscar"
Endcase

*!*	mret = sqlexec(mcon1, "select TCI_insumocodigo as INS_codinsumo, TCI_insumodescrip as INS_descriinsumo,"+;
*!*		"TCI_resto as INS_resto, TCI_partida as INS_partida, id,"+;
*!*		"TCI_lote as INS_lote,TCI_vence as INS_vence " + ;
*!*		"from TabfarmCitosI where " + mwhere, "mwkinsumos")

mret = sqlexec(mcon1, "select TCI_insumocodigo as INS_codinsumo, TCI_insumodescrip as INS_descriinsumo,"+;
	"TCI_resto as INS_resto, TCI_partida as INS_partida,TabfarmCitosI.id,"+;
	"TCI_lote as INS_lote,TCI_vence as INS_vence,"+;
	"TFP_pactivo,TBC_dosis,TBC_udosis,TabFarmbaseCo.id as lid,TabFarmbaseCo.TBC_formafarm"+;
	" from TabfarmCitosI"+;
	" join TabFarmbaseCo on TBC_inscod = TabfarmCitosI.TCI_insumocodigo"+;
	" join TabFarmPActivo on TFP_inscod = TabFarmbaseCo.TBC_inscod"+;
	" where "+ mwhere, "mwkinsumos")

If mret < 0
	Messagebox("EN CONSULTA DE INSUMOS REMANENTES"+CHR(10)+;
		"AVISAR A SISTEMAS", 16, "ERROR")
Endif
