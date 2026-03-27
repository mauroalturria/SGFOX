*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
* MODIFICADO :02/06/2003
******************************
************/*/**************************************************
* Muevo todo lo que tengo en la lista de medico- prestaciones
****************************************************************

sele Mwkprestasig
go top
do while not eof('Mwkprestasig') 
	mncodprest = Mwkprestasig.codprest
	mncodser   = Mwkprestasig.codserv	
	
	do sp_valida_tieneturnos_01
	
	if eof('MWKTieneTur') or bof('MWKTieneTur')
		do sp_elimino_uno_a_medpresta
	else
		messagebox('No se puede Eliminar la prestacion '+ chr(13)+;
		Mwkprestasig.PRE_descriprest + chr(13) + ' Tiene turnos Asignados',64,'Operacion Invalida')
	endif			
	skip in Mwkprestasig
	if eof('Mwkprestasig')
		exit
	else
		loop
	endif
enddo				