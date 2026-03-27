*
* Tablas Epidemiologia ( Guardia - Dengue Serotipo )
*

If used("mwkserotipo")
	Use in mwkserotipo
Endif

If used("mwkserotipo2")
	Use in mwkserotipo2
Endif

mret = sqlexec(mcon1,"select * from TabEstados"+;
	" where propietario = 2 and tipo = 3 order by estado","mwkserotipo")

If mret < 0
	Messagebox("EN CONSULTA EPIDEMIOLOGICA - SEROTIPOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else
	Select * from mwkserotipo into cursor mwkserotipo2
Endif
