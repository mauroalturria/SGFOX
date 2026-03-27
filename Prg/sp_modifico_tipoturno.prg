***********************************************
* AUTOR: Claudia Antoniow
* FECHA: 08/02/2002
* MODIFICADO POR ULT. VEZ:08/02/2002
***********************************************

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"update turnos set tipoturno=?mntipotur " +;
			" where &mccpoamb codmed=?mncodmed and diasem=?mddiasem and horatur =?mthorad and tipoturno=0 ")
			
if mret <0
	messagebox('ERROR DE CURSOR RUTINA modifico_tipoturno,AVISAR A SISTEMA',16,'VALIDACION')
	mret=0
endif