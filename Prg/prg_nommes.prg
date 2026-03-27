****
** mes de fecha
****
Parameter mdia,mfto  &&& mfto = 1 Mes largo 2 = Mes corto 3 = Mes corto may
If Vartype(mfto)#"N"
	mfto = 1
Endif
If Vartype(mdia)#"D"
	Return ''
Else
	Local nommes
	Dimension nommes(12)
	Do Case
		Case mfto = 1
			nommes(1) = 'Enero'
			nommes(2) = 'Febrero'
			nommes(3) = 'Marzo'
			nommes(4) = 'Abril'
			nommes(5) = 'Mayo'
			nommes(6) = 'Junio'
			nommes(7) = 'Julio'
			nommes(8) = 'Agosto'
			nommes(9) = 'Septiembre'
			nommes(10) = 'Octubre'
			nommes(11) = 'Noviembre'
			nommes(12) = 'Diciembre'
		Case mfto = 2
			nommes(1) = 'Ene'
			nommes(2) = 'Feb'
			nommes(3) = 'Mar'
			nommes(4) = 'Abr'
			nommes(5) = 'May'
			nommes(6) = 'Jun'
			nommes(7) = 'Jul'
			nommes(8) = 'Ago'
			nommes(9) = 'Sep'
			nommes(10) = 'Oct'
			nommes(11) = 'Nov'
			nommes(12) = 'Dic'
		Case mfto = 3
			nommes(1) = 'ENE'
			nommes(2) = 'FEB'
			nommes(3) = 'MAR'
			nommes(4) = 'ABR'
			nommes(5) = 'MAY'
			nommes(6) = 'JUN'
			nommes(7) = 'JUL'
			nommes(8) = 'AGO'
			nommes(9) = 'SEP'
			nommes(10) = 'OCT'
			nommes(11) = 'NOV'
			nommes(12) = 'DIC'
	Endcase

	mimes = Month(mdia)
	Return nommes(mimes)
Endif
