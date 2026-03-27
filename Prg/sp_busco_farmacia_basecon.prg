*
* Busqueda en Base de Conocimientos
*

Lparameters mid

If used('mwkbaseco2')
	Use in mwkbaseco2
Endif

mret = sqlexec(mcon1,"select id as lid, TBC_psolucd from TabFarmBaseco"+;
" where TBC_inscod=?mid","mwkbaseco2")

If mret < 0
	Messagebox("EN BUSQUEDA DE INSUMO EN BASE DE CONOCIMIENTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
