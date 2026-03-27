*
* Busqueda de Obs. Derivaciones
*
Lparameters mbusid

If used('mwkderobs')
	Use in mwkderobs
Endif

mret = sqlexec(mcon1,"select * from TabDerivaObs where TDO_idderiva=?mbusid","mwkderobs")

If mret < 0
	Messagebox("EN BUSQUEDA DE OBSERVACIONES DE DERIVACIONES",16,"ERROR")
Endif
