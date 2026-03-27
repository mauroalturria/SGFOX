*
* Encuestas examen de residencias
*

If used('mwkencues')
	Use in mwkencues
Endif

mret = sqlexec(mcon1,"select * from TabResEncues"+;
	" where TRE_anio=?mranio and TRE_evento=?mreven","mwkencues")
If mret < 0
	Messagebox("EN CONSULTA DE ENCUESTAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif

