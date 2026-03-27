*
* Busqueda de Insumos Medicamentos Citostáticos, Maestro Farmacia x Vencimientos
* El parametro mwhere lo recibe armado con un "and ..."
*
Lparameters mper1,mper2,mwhere

If type('mwhere')#"C"
	mwhere = ''
Endif

mwhere = mwhere + " and TCI_vence >= ?mper1 and TCI_vence <= ?mper2 order by TCI_vence"

If used('mwkInsVen')
	Use in mwkInsVen
Endif

mret = sqlexec(mcon1,"select * from TabFarmCitosI where TCI_fechapasiva is null "+mwhere,"mwkInsVen")

If mret < 0
	Messagebox("EN BUSQUEDA DE INSUMOS",16,"ERROR")
Endif
