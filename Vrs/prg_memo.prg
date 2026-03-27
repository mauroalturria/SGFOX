****
** convierte fecha para busqueda
****
Parameter mlinea,mchar
if len(alltrim(mlinea ) + alltrim(mchar))>255
	mlinea = alltrim(mlinea) + chr(10)+alltrim(mchar)
else 
	mlinea = alltrim(mlinea) + alltrim(mchar)
endif	
Return mlinea


