
*** Funcion de filtrado
Lparameters tcTexto

Local lcPermitidos, lcResultado, lnI, lcChar

* Lista base: alfabeto español, números y símbolos permitidos
lcPermitidos = "abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZáéíóúÁÉÍÓÚüÜ0123456789,-_?¿!¡+=()/*+."

* Concatenamos el Espacio (32), Enter (13) y Salto de línea (10)
lcPermitidos = lcPermitidos + Chr(32) + Chr(13) + Chr(10)

lcResultado  = ""

* Recorremos el texto carácter por carácter
For lnI = 1 To Len(tcTexto)
	lcChar = Substr(tcTexto, lnI, 1)

* Si el carácter está en la lista de permitidos, lo acumulamos
	If Chrtran(lcChar, lcPermitidos, "") = ""
		lcResultado = lcResultado + lcChar
	Else
		lcResultado = lcResultado + " "
	Endif
Endfor

Return lcResultado
