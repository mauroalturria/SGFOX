****************************************************************************

********************************
* prog SaveBin()
* recupera los datos binarios y los transforma

lparameters pcData,pcBin,miresp,cext
*-- Se validan los parámetros necearios
if vartype(pcData)<>"C" or vartype(pcBin)<>"C"
	miresp = ""
else
*-- Se verifica que el archivo destino indicado sea válido
	local nFH
	nFH=fcreate(pcBin)
	if nFH < 0
		miresp =""
	else
		=fclose(nFH)
	endif
*-- Se fuerza el tipo de archivo a crear
	pcBin=forceext(pcBin,cExt)
*-- Se crea el archivo de Archivo
*
	nbytes  = strtofile(pcData,pcBin)
*	
	if cExt="DOC"
		erase &pcBin
	endif
	if nbytes > 0
		miresp =pcBin
	endif
endif
****************************************************************************

********************************
