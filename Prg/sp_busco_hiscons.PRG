*
* Busqueda de Historial Consultas
*
Lparameters mnrohcl

If used('mwkhiscon')
	Use in mwkhiscon
Endif

mret = sqlexec(mcon1,"select * from TabConHis where TCH_nrohclinica=?mnrohcl","mwkhiscon")

If mret < 0
	Messagebox("EN EL HISTORIAL DE CONSULTAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

