***********
*  Consulto la tabbla TabMlPreocup, que me traiga todos los estudios de una cita y que no esten dados de baja**********
***********
parameters mCita
mCita = iif(empty(mCita),"IdCita",mCita)
mfecha = ctod('01/01/1900')
mret = sqlexec(mcon1," select descrip as Estudio ,observaciones as Descr," +;
	" tabmlestpreocup.id as idestudio,idcondicion,TabMlPreocup.id as id " +;
	" from TabMlPreocup left join tabmlestpreocup  on tabmlestpreocup.id = TabMlPreocup.idestudio "+;
	" where IdCita =  " + str(mCita )  + " and fechapasiva = ?mfecha" , "mwkEstudios")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
