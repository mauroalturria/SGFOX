*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
***************************************************
* Calculo el porcentaje de sobreoferta ingresado
*
***************************************************

sele MWKSobre
mthodes = MWKSobre.horadesde

mret = sqlexec(mcon1,"SELECT a.diasem, a.horahasta,a.Horadesde,a.porcentaje,a.cantidad,a.codesp,a.codserv FROM Medpresta as a " + ;
				   "WHERE a.codmed=?mncodmed AND a.diasem =?mndiasem And a.Horadesde = ?mthodes " + ;
				   "GROUP BY a.Horadesde " +;
				   "ORDER BY a.horadesde",'MWKHorasTr')
if mret < 0
	messagebox('ERROR DE CURSOR HORAS TRAB, AVISAR A SISTEMAS',16,'Validación')
	mret=0
endif			   

