*
* Confirmación de Aptitud para aquellos
*
Lparameters mregis

If used('mwkaptodat')
	Use in mwkaptodat
Endif

mret = sqlexec(mcon1,"select * from TabFarmApto where "+;
	"TFA_registracio = ?mregis","mwkaptodat")

If mret < 0
	Messagebox("EN CONSULTA DE CONFIRMACION DE APTO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
