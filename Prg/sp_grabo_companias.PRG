*
* Grabacion de Companias
*
Lparameters mdesc,mtipo,mtipo2

mfnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"insert into TabLGAseg (TLA_nombre,TLA_tipo,TLA_tipo2,TLA_fecpasiva)"+;
	" values (?mdesc,?mtipo,?mtipo2,?mfnull)")

If mret < 0
	=aerror(merror)
	Messagebox("EN INGRESO, MAESTRO DE ASEGURADORAS"+chr(10)+;
		merror(3)+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
