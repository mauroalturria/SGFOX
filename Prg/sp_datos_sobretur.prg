*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************

***************************************************
* Calculo el porcentaje de sobreoferta ingresado
* OJO!!!! en este caso 'mnporc' trae la cantidad de
* turnos que tiene el médico
***************************************************
mdHora_d=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(thorad),minute(thorad),0)
mdHora_h=datetime(year(mtfechatur),month(mtfechatur),day(mtfechatur),hour(thorah),minute(thorah),0)

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"SELECT fechatur, diasem ,Count(horatur)as Cantur " + ;
	" FROM Turnos, Tabtipoturno " + ;
	" WHERE &mccpoamb Turnos.tipoturno = Tabtipoturno.tipoturno and codmed  = ?mncodmed  "+;
	" AND fechatur = ?mtfechatur and horatur >=?mdHora_d and " + ;
	" horatur <=?mdHora_h and Tabtipoturno.grupo IN (0,1,3) GROUP BY fechatur, diasem ",'MwkPorcSOfer')

if mret < 0
	messagebox('ERROR DE CURSOR1, REINTENTE',16,'Validación')
	mret=0

endif

