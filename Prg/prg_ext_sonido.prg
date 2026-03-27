Parameters lnOpcion, lcValor 

Local lbResu

Do case
	Case lnOpcion = 1
		lbResu = Inlist(lcValor,'WAV','MP3')
	Case lnOpcion = 2
		lbResu = " ('WAV','MP3') "
Endcase

Return (lbResu)