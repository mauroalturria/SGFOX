****
** saca caracteres no permitidos y caracteres de control
****
parameter mchar
mchar = CHRTRAN(mchar, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}", "###  ")
mchar = strtran(mchar, '"', "")
mchar = strtran(mchar, chr(9), " ")
mchar = strtran(mchar, chr(1), " ")
mchar = strtran(mchar, ',', " ")

return mchar