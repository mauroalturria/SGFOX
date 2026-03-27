*
* conversion Hr + Min + Seg
*
Lparameters m.parm1

	Local m.dummy,m.hora,m.minuto,m.segundo
	m.parm1 = Int(m.parm1)
	m.hora = Int(m.parm1/3600)
	m.parm1 = m.parm1 - (m.hora*3600)
	m.minuto = Int(m.parm1/60)
	m.segundo = m.parm1 - (m.minuto*60)

	*m.parm1 = Strtran(Str(m.hora,4,0)+":"+Str(m.minuto,2,0)+":"+Str(m.segundo,2,0)," ","0")
	
	*m.parm1 = Strtran(Str(m.hora,2,0)+":"+Str(m.minuto,2,0)+":"+Str(m.segundo,2,0)," ","0")

	mhor = Str(m.hora,4,0)
	mmin = Strtran(Str(m.minuto,2,0)," ","0")
	mseg = Strtran(Str(m.segundo,2,0)," ","0")

	m.parm1 = mhor + ":" + mmin + ":" + mseg 

	If m.parm1 = "0"
		m.parm1 = Substr(m.parm1,3)
		If m.parm1 = "0"
			m.parm1 = Substr(m.parm1,2)
		Endif
	Endif

Return m.parm1
