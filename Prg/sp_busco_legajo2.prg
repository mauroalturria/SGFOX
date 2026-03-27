*
* Total de Legajos maestro TTLegajos para combo 
*

If used('mwklegajos2')
	Use in mwklegajos2
Endif

mret = sqlexec(mcon3,"select legajo as LEG_ID,cast({fn concat(trim(apellido),"+;
	"{fn concat(' ',trim(nombre))})} as CHAR(40) ) as LEG_APELLIDO"+;
	",id from TTLegajos order by apellido","mwklegajos2")
If mret < 0
	Messagebox("Error de lectura AVISE A SISTEMAS",16,"ERROR")
else
Endif

