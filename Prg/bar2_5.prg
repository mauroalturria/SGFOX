
Param numero
numero=allt(numero)
largo=len(numero)
if int(largo/2) <> largo/2
numero='0'+numero
endif
largo=len(numero)
cadena='('
for cuenta = 0 to largo/2-1
par=substr(numero,(2*cuenta)+1,2)
*................
npar=val(par)
cpar=chr(npar+iif(npar<=49,48,142))
*................
cadena=cadena+cpar
endfor
cadena = cadena+')'
return cadena


