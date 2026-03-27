****
** saca caracteres no permitidos y caracteres de control
****
parameter mchar ,ccharmalos 
if vartype(ccharmalos )#"C"
	ccharmalos = "³ÁÉÍÓÚÀÈÌÒÙàèìòùÇ±‘ÑğĞ^/\'$:ñ¥·ÿŸº?¿!¡%&()=¨;.ª|¬[]{}-Â"
endif
FOR icm= 1 TO 19  
	ccharmalos = ccharmalos +CHR(icm)
NEXT icm

mchar = STRTRAN(mchar,'AÂ#','Ñ')
mchar = STRTRAN(mchar,'Ã?','Ñ') &&renaper
mchar = STRTRAN(mchar,'AÂ±','Ñ')
mchar = STRTRAN(mchar,'Ã¯Â¿Â½','Ñ')
mchar = STRTRAN(mchar,'AÂ ','A')
mchar = STRTRAN(mchar,'AÂ¡','A')
mchar = STRTRAN(mchar,'AÂ©','E')
mchar = STRTRAN(mchar,'Ã©','E')&&renaper
mchar = STRTRAN(mchar,'AÂ­','I')
mchar = STRTRAN(mchar,'IÂ­','I')
mchar = STRTRAN(mchar,'Ì','I')&&renaper
mchar = STRTRAN(mchar,'AÂ³','O')
mchar = STRTRAN(mchar,'AÂº','U')
mchar = STRTRAN(mchar,'Âº','U') &&renaper
mchar = STRTRAN(mchar,'Ã','')
mchar = strtran(mchar, '"', " ")
mchar = strtran(mchar, chr(6), " ")
mchar = strtran(mchar, chr(9), " ")
mchar = strtran(mchar, chr(1), " ")
mchar = CHRTRAN(mchar, ccharmalos , "OAEIOUAEIOUáéíóúC#####                                ")


return mchar