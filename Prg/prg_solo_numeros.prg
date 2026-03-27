****
** verifica que sean solo numeros
****
parameter mchar
return !EMPTY(CHRTRAN(alltrim(mchar),"1234567890",""))
