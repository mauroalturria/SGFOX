*
* Busca destino x nemonico del servicio seleccionado
*

Lparameters mbusnemo

If used('mwkdestinos')
	Use in mwkdestinos
Endif

mret=sqlexec(mcon1,"select CPDR_destino from CPDESTR"+;
	" where CPDR_mnemonico = ?mbusnemo","mwkdestinos")

If mret < 0
	Messagebox("EN BUSQUEDA DE DESTINO PARA EL SERVICIO",48,"Validación")
Endif
