****
** saca caracteres no permitidos y caracteres de control
****
parameter mchar ,ccharmalos 
if vartype(ccharmalos )#"C"
	ccharmalos = "³ÁÉÍÓÚÀÈÌÒÙàèìòùÇ±‘ÑðÐ^/\'$:ñ¥·ÿŸº?¿!¡%&()=¨;.ª|¬[]{}-Â"
endif
FOR icm= 1 TO 19  
	ccharmalos = ccharmalos +CHR(icm)
NEXT icm

mchar = STRTRAN(mchar,'AÂ#','*')
mchar = STRTRAN(mchar,'AÂ±','*')
mchar = STRTRAN(mchar,'Ã¯Â¿Â½','*')
mchar = STRTRAN(mchar,'AÂ ','*')
mchar = STRTRAN(mchar,'AÂ¡','*')
mchar = STRTRAN(mchar,'AÂ©','*')
mchar = STRTRAN(mchar,'AÂ­','*')
mchar = STRTRAN(mchar,'IÂ­','*')
mchar = STRTRAN(mchar,'AÂ³','*')
mchar = STRTRAN(mchar,'AÂº','*')
mchar = STRTRAN(mchar,'Ã','*')
mchar = strtran(mchar, '"', "*")
mchar = strtran(mchar, chr(6), "*")
mchar = strtran(mchar, chr(9), "*")
mchar = strtran(mchar, chr(1), "*")
mchar = CHRTRAN(mchar, ccharmalos , "******************************************************")


return mchar