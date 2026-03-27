Lparameters lta
Local carte
carte = ''
If lta ="PS"
	carte = 'Plan Intregrador'
Endif
If lta ="OU"
	carte = 'Afiliado O.Social y Sindical'
Endif
If lta ="OS"
	carte = 'Afiliado O.Social'
Endif
If lta ="MO"
	carte = 'Monotributista'
Endif
If lta ="NO"
	carte = 'Sin datos'
Endif
RETURN PADR(CARTE,30)
