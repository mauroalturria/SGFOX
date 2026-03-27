*
* Tablas Incidentes adversos, Hechos
*
If used('mwkHechosg')
	Use in mwkHechosg
Endif
mret  =  sqlexec(mcon1,"select TLH_descrip,id as TLH_idcod from TabLGHechos", "mwkHechosg")
If mret < 0
	Messagebox("EN LA TABLA HECHOS GENERADOR DEL REQUERIMIENTO"+;
		chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
