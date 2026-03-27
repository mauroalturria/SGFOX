****
** Separo los datos stock
****
* Cod_error recibe el codigo del art. que dió error
* Num_error reibe el numero de error tabulado
* Parametros mresp1 es el string de errores,
* nreg representa la cantidad max de errores posibles para el comprobante
* y tipo si es C es cabecera de comprobante y D es detalle del comprobante

Parameter mresp1, nreg, tipo

Public ARRAY Num_error(nreg),cod_error(nreg)

If tipo = 'C'
	For i=1 TO nreg
		If i=1
			Num_error(i) = VAL(subs(mresp1,  1, (atc(chr(9), mresp1, i) -1)))
		Else
			j=i-1
			Num_error(i) = VAL(subs(mresp1, j, (atc(chr(9), mresp1, i)-1)))
		Endif

	Endfor

Endif

If tipo ='D'
	For i=1 TO nreg
		m = i
		If i = 1
			cod_error(i) = subs(mresp1,  1, (atc(chr(9), mresp1, i) -1))
			j = atc(chr(9), mresp1, i) + 1
			k = atc(chr(1), mresp1, m) -1
			Num_error(i) = VAL(subs(mresp1, j, k))
		Else
			j= k + 2
			cod_error(i) = subs(mresp1,  j, (atc(chr(9), mresp1, i)-j))
			j = atc(chr(9), mresp1, i) + 1
			k = atc(chr(1), mresp1, m) - 1
			Num_error(i) = VAL(subs(mresp1, j, k))
		Endif

	Endfor
Endif

Return .T.
