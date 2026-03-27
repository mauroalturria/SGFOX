*
* Busqueda de Insumos Citostaticos en condiociones de uso ( con stock y activos ) correspodientes a un
* paciente localizado por su nro. de registracion
*
Lparameters mvalor

If used('mwkarmostk')
	Use in mwkarmostk
Endif

*!* Funcionando en Versión 5

*!*	mret = sqlexec(mcon1,"select TabFarmCitosI.*,TabFarmPActivo.TFP_pactivo"+;
*!*		" from TabFarmCitosI,TabFarmCitosP"+;
*!*		" join TabFarmPactivo on TabFarmPActivo.TFP_InsCod = TabFarmCitosI.TCI_insumocodigo"+;
*!*		" join TabFarmPlanI on TabFarmplanI.TFI_pactivo = TabFarmPActivo.TFP_pactivo and TabFarmplanI.TFI_fecpasiva is null"+;
*!*		" where TabFarmCitosI.TCI_resto > 0"+;
*!*		" and TabFarmCitosP.TCP_registracio = ?mvalor"+;
*!*		" and TabFarmCitosP.TCP_fechapasiva is null"+;
*!*		" and TabFarmCitosP.TCP_partida = TabFarmCitosI.TCI_partida"+;
*!*		" group by tci_partida,tci_insumocodigo,tci_lote,tci_vence","mwkarmostk")

*!* Corregido para Versión 2012
*!* 20-09-2012 se agrego Group by tci_serie

mret = sqlexec(mcon1,"Select TabFarmCitosI.*,TabFarmPActivo.TFP_pactivo"+;
	" From TabFarmCitosI"+;
	" Join TabFarmCitosP on TabFarmCitosP.TCP_registracio = ?mvalor"+;
	" And TabFarmCitosP.TCP_fechapasiva is null"+;
	" And TabFarmCitosP.TCP_partida = TabFarmCitosI.TCI_partida"+;
	" Join TabFarmPActivo on TabFarmPActivo.TFP_InsCod = TabFarmCitosI.TCI_insumocodigo"+;
	" Join TabFarmPlanI on TabFarmPlanI.TFI_pactivo = TabFarmPActivo.TFP_pactivo"+;
	" And TabFarmPlanI.TFI_fecpasiva is null"+;
	" Where TabFarmCitosI.TCI_resto > 0"+;
	" Group by TCI_partida,TCI_insumocodigo,tci_lote,tci_vence,tci_serie","mwkarmostk")

If mret < 0
	=Aerror(merror)
	Messagebox("EN BUSQUEDA DE INSUMOS CITOSTATICOS"+CHR(10)+;
		merror(3)+CHR(10)+;
		"NOTIFIQUE EL ERROR",16,"ERROR")
Endif

