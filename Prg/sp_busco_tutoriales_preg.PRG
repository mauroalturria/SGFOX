*
* Busqueda de preguntas frecuentes y videos tutoriales
*
Lparameters mprovie

If used('mwkpregunta')
	Use in 'mwkpregunta'
Endif

*!* mestado,
*!*	mestado = 3 && 'c/Respuesta'
*!*	mprovie = 1 && Proviene de 'Guardia'
*!* TVT_idestado=?mestado and

mret = sqlexec(mcon1,"select TVT_pregunta,TVT_codmed,TVT_fechapreg,TVT_respesc,TVT_idvideo,TVT_idestado"+;
	" from TabVTutorial where TVT_idproviene=?mprovie","mwkpregunta")

If mret < 0
	Messagebox("EN CONSULTA DE PREGUNTAS FRECUENTES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
