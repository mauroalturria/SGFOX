****************************************************************************

********************************
* prog SaveImg()
* recupera los datos binarios y los transforma

lparameters pcData,pcImg,miresp
*-- Se validan los parámetros necearios
if vartype(pcData)<>"C" or vartype(pcIMG)<>"C"
	miresp = ""
else
*-- Se verifica que el archivo destino indicado sea válido
	local nFH
	nFH=fcreate(pcIMG)
	if nFH < 0
		miresp =""
	else
		=fclose(nFH)
	endif
*-- Se obtiene el tipo de imágen a crear
	local cExt
	cExt=left(pcData,3)
	pcIMG=forceext(pcIMG,cExt)
*-- Se crea el archivo de imágen
*
	strtofile(subs(pcData,4),pcImg)
*
	miresp =pcImg
endif
****************************************************************************

********************************
