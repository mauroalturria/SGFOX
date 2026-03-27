*
* Busqueda de pregunta desde su número original y tema, a los efectos de obtener texto y respuestas
*
Lparameters mconsulta,mtema, morig
If mconsulta = 1
	If used('mwkpregrespu')
		Use in mwkpregrespu
	Endif
	If mtema = 'F'
		mret = sqlexec(mcon1,"select * from TabResExaF where TRE_preguntanro=?morig"+;
		" and TRE_anio=?mranio and TRE_evento=?mreven","mwkpregrespu")
	Else
		mret = sqlexec(mcon1,"select * from TabResExa where TRE_preguntanro=?morig"+;
		" and TRE_anio=?mranio and TRE_evento=?mreven","mwkpregrespu")
	Endif
Else
	If used('mwkotrapreg')
		Use inmwkotrapreg
	Endif
	mret = sqlexec(mcon1,"select * from TabResTemas where TRT_Idpregorg=?morig"+;
		" and TRT_tema<>?mtema and TRT_tema<>'F'"+;
		" and TRT_anio=?mranio and TRT_evento=?mreven","mwkotrapreg")
Endif
If mret <= 0
	Messagebox("EN BUSQUEDA, DE LA PREGUNTA"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
