*
* Busqueda de Pacientes en H. Anteriores x Cod.Admision
*
Parameters madmision

If used('mwkpacint')
	Use in mwkpacint
Endif

mret = sqlexec(mcon1,"select * from TabHciAdm where adm_nroadm = ?madmision","mwkpacint")

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA HISTORIAS ANTERIORES"+chr(10)+;
		alltrim(merror(3))+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
