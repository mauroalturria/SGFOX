****
** deja solo numeros
****
parameter mchar,lsinblank
mcNum = CHRTRAN(upper(mchar), ",_#@%&*+QWERTYUIOPASDFGHJKLZXCVBNMÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}-", "")
if lsinblank
	mcNum = strtran(mcNum, ' ', "")
endif
mcNum = strtran(mcNum, '"', "")
mcNum = strtran(mcNum, chr(9), "")
mcNum = strtran(mcNum, chr(1), "")

return mcNum