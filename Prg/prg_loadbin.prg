****************************************************************************
* progs:LoadBin()
*   Convierte un Archivo en una cadena de caracteres que puede ser guardada
*   en un campo memo normal.
*   Autor: V. Espina
*
lparameters pcBin, miimagen
*
*-- Se validan los parámetros necesarios
*
if vartype(pcBin)<>"C" or not file(pcBin)
	miimagen = ""
else

*-- Se lee el archivo fuente
*
	local nFH,cData
	nFH=fopen(pcBin)
	cData=""
	do while not feof(nFH)
		cData=cData + fread(nFH,512)
	enddo
	=fclose(nFH)

*-- Se devuelve la cadena que representa al Archivo
*
	miimagen = cData
	
endif
 
Return miimagen