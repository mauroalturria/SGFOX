*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
****************************************************************
* Muevo todo lo que tengo en la lista de Prestaciones
* a la lista de médico prestacion
****************************************************************

sele Mwkprestac
go top
do while not eof() 
	mncodprest =mwkprestac.PRE_codprest
	mncodser   =mwkprestac.PRE_codservicio
	mncanttur  =mwkprestac.PRE_turnosMultip
	do sp_muevo_uno_a_medpresta.prg
	skip
	if eof()
		exit
	else
		loop
	endif
enddo				