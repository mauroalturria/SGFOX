****************************************************************************

********************************
* progs:LoadImg()
*   Convierte una imágen en una cadena de caracteres que puede ser guardada
*   en un campo memo normal.
*   Autor: V. Espina
*
lparameters pcImg,miimagen
*
*-- Se validan los parámetros necesarios
*
if vartype(pcImg)<>"C" or not file(pcImg)
	miimagen = ""
else

*-- Se lee el archivo fuente
*
	local nFH,cData
	nFH=fopen(pcImg)
	cData=""
	do while not feof(nFH)
		cData=cData + fread(nFH,512)
	enddo
	=fclose(nFH)


*-- Se devuelve la cadena que representa a la imágen
*
	miimagen = upper(justext(pcImg))+cData
endif
*
